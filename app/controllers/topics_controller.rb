class TopicsController < ApplicationController
  PAGE_NUM = Settings.topics.page_num

  def index
    # 検索フォーム用インスタンス作成
    @search = Topic.ransack(params[:q])
    @is_searched = params[:q].present?

    # スレッド一覧オブジェクト
    @topics = @search.result.includes(:posts).reorder("posts.created_at desc").page(params[:page]).per(PAGE_NUM)

    # @topics = Topic.page(params[:page]).per(PAGE_NUM)

    # 入力フォーム用インスタンス作成
    @topic = Topic.new
    @topic.posts.build
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts # ページネーション不要
    @post = Post.new
  end

  def create
    @topic = Topic.new(topic_params)
    @topic = embedded_default(@topic)

    is_error = false
    is_analysis_error = false
    if topic_params[:posts_attributes].present?
      is_magick_byte_error = is_image_byte_error(topic_params[:posts_attributes])
      if is_magick_byte_error
        is_error = true
        flash[:errors] = {title: Settings.errors.post_create_title, errors: [Settings.errors.magick_byte]}
        logger.info("user error: マジックバイトエラー")
        redirect_to errors_path
      else
        if @topic.posts.present? && @topic.posts.first.valid?
          begin
            image_analysis(@topic.posts.first)
          rescue Exceptions::GoogleVisionApiException => e
            is_analysis_error = true
          end
        end
      end
    end

    if !is_error
      if @topic.save
        if is_analysis_error
          flash[:success] = "作成完了です！（画像内の文字は検索対象になりません）"
        else
          flash[:success] = "作成完了です！"
        end
        redirect_to topics_path
      else
        flash[:errors] = {title: Settings.errors.topic_create_title, errors: @topic.errors.full_messages}
        redirect_to errors_path
      end
    end
  end

  def destroy
    Topic.find(params[:id]).destroy
    flash[:success] = "スレッドを削除しました。"
    redirect_to topics_path
  end

  private

    def topic_params
      params.require(:topic).permit(:title, :name, posts_attributes: [:body, :password, {images: []}])
    end

    def embedded_default(topic)
      # topic.title = topic.title.presence || '無題'
      topic.name = topic.name.presence || '名無し'
      if topic.posts.present?
        topic.posts.first.name = topic.name
        topic.posts.first.parent_flag = true
      end
      topic
    end

    def image_analysis(post, is_updated=false)
      if post.images.present?
        texts = []
        post.images.each do |image|
          image_file_path = Rails.env.production? ? image.file.url : image.file.path
          google_cloud_vision = GoogleCloudVision.new(image_file_path, is_updated)
          text = google_cloud_vision.request
          texts << text
        end

        if texts.present?
          post.image_descriptions = texts
        end
      end

      post
    end

    def is_image_byte_error(params)
      is_magick_byte_error = false

      if params["0"].present? && params["0"][:images].present?
        params["0"][:images].each do |image|
          if !check_image(image)
            is_magick_byte_error = true
            break
          end
        end
      end

      is_magick_byte_error
    end

    def check_image(file)
      ext = File.extname(file.original_filename).downcase  # 拡張子
      data = file.read(20)  # 中身の先頭

      return ext == '.gif' && !!data.match(/\AGIF8[79]a/) \
        || ext == '.png' && !!data.match(/\A\x89PNG\r\n\x1A\n/n) \
        || ['.jpg','.jpeg'].include?(ext) && !!data.match(/\A\xFF\xD8\xFF/n)
    end
end
