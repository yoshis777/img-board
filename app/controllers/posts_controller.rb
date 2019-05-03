class PostsController < ApplicationController
  require "digest/trip"
  before_action :set_topic, only: [:create]

  MAX_POSTS_NUM = Settings.posts.max_post_num
  SEARCH_PAGE_NUM = Settings.posts.search_page_num

  def index
    @search = Post.ransack(params[:q])
    @posts = @search.result
  end

  def search
    @is_searched = false

    if params[:q].present?
      @is_searched = true
      item = params[:q][:item]
      _cont = params[:q][:body_cont]
      conditions = {}
      if item.present? && _cont.present?
        if item == "2"
          conditions[:name_cont] = _cont
        elsif item == "3"
          conditions[:image_descriptions_cont] = _cont
        else
          conditions[:body_cont] = _cont
        end
        @search = Post.search(conditions)
        result = @search.result
        @posts = result.page(params[:page]).per(SEARCH_PAGE_NUM)
        @posts_count = result.count
      else
        @search = Post.search("")
        @posts = Post.none.page(params[:page]).per(SEARCH_PAGE_NUM)
        @posts_count = 0
      end
    else
      @search = Post.search("")
      @posts = Post.none.page(params[:page]).per(SEARCH_PAGE_NUM)
      @posts_count = 0
    end
  end

  def show
    @post = Post.find(params[:id])
    @new_post = Post.new
  end

  def create
    posts = @topic.posts
    if posts.count > MAX_POSTS_NUM
      flash[:errors] = {title: Settings.errors.post_create_title, errors: ["1スレッドにつき投稿は" + MAX_POSTS_NUM.to_s + "件までです。"]}
      redirect_to errors_path
    else
      # マジックバイトチェック
      is_magick_byte_error = is_image_byte_error(post_params)

      if is_magick_byte_error
        flash[:errors] = {title: Settings.errors.post_create_title, errors: [Settings.errors.magick_byte]}
        logger.info("user error: マジックバイトエラー")
        redirect_to errors_path
      else
        @post = posts.build(post_params)

        @post = processing_post(@post)

        is_analysis_error = false
        if @post.valid?
          begin
            @post = image_analysis(@post)
          rescue Exceptions::GoogleVisionApiException => e
            is_analysis_error = true
          end
        end

        if @post.save
          ancher_follow(@post)

          if is_analysis_error
            flash[:success] = "投稿完了です！（画像内の文字は検索対象になりません）"
          else
            flash[:success] = "投稿完了です！"
          end

          redirect_to @topic
        else
          if is_analysis_error
            @post.errors.add(:image_descriptions, 'ができませんでした。画像内の文字は検索対象になりません。')
          end
          flash[:errors] = {title: Settings.errors.post_create_title, errors: @post.errors.full_messages}
          logger.info("error:" + @post.errors.full_messages.inspect)
          redirect_to errors_path
        end
      end
    end
  end

  def authenticated
    param_id = params[:id]
    post = Post.find_by_id(param_id)

    if !post
      flash[:errors] = {title: Settings.errors.post_update_title, errors: ["投稿が存在しません。"]}
      redirect_to errors_path
    elsif post && (! post.password_digest)
      logger.info("パスワードが設定されていない：ポストNo：" + param_id)
      flash[:errors] = {title: Settings.errors.post_update_title, errors: ["パスワードが投稿時に設定されていないため編集および削除できません。"]}
      redirect_to errors_path
    elsif post && post.authenticate(authenticate_params[:password])
      @post = post
      session.delete(:password)
      session[:password] = authenticate_params[:password]
      render 'authenticated'
    else
      logger.info("パスワードが違う：ポストNo：" + param_id)
      flash[:errors] = {title: Settings.errors.post_update_title, errors: ["パスワードが正しくありません。"]}
      redirect_to errors_path
    end
  end

  def update
    param_id = params[:id]
    post = Post.find_by_id(param_id)
    if session[:password] && post.authenticate(session[:password])
      session.delete(:password)

      # マジックバイトチェック
      is_magick_byte_error = is_image_byte_error(post_params)
      if is_magick_byte_error
        flash[:errors] = {title: Settings.errors.post_update_title, errors: [Settings.errors.magick_byte]}
        logger.info("user error: マジックバイトエラー")
        redirect_to errors_path
      else
        post.assign_attributes(update_params)

        is_analysis_error = false
        if post.valid?
          begin
            post = image_analysis(post, true)
          rescue Exceptions::GoogleVisionApiException => e
            is_analysis_error = true
          end
        end

        if post.save
          if is_analysis_error
            flash[:success] = "編集完了です！（画像内の文字は検索対象になりません）"
          else
            flash[:success] = "編集完了です！"
          end
          redirect_to post.topic
        else
          if is_analysis_error
            post.errors.add(:image_descriptions, 'ができませんでした。画像内の文字は検索対象になりません。')
          end
          flash[:errors] = {title: Settings.errors.post_update_title, errors: post.errors.full_messages}
          redirect_to errors_path
        end
      end
    else
      session.delete(:password)
      logger.warn("warning：不正なアクセス：ポストNo：" + param_id)
      redirect_to post.topic
    end
  end

  def edit
    @post = Post.select("id", "topic_id").find_by_id(params[:id])
    if !@post
      redirect_to root_path
    else
      @new_post = Post.new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @topic = @post.topic
    if @post.parent_flag
      flash[:success] = "スレッドを削除しました。"
      @topic.destroy #親スレッドなら紐づくtopic側を消す（topicに紐づくpostsも丸ごと消える）
    else
      flash[:success] = Settings.posts.messages.deleted
      @post.destroy
    end
    redirect_to @topic
  end

  private
    def post_params
      params[:post].permit(:name, :body, :password, {images: []})
    end

    def authenticate_params
      params[:post].permit(:password)
    end

    def update_params
      params[:post].permit(:name, :body, {images: []})
    end

    def search_params
      params[:post].permit(:body)
    end

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def processing_post(post)
      post = embedded_default(post)
      post.name = create_trip(post.name)
      post
    end

    def embedded_default(post)
      post.name = post.name.presence || '名無し'
      post
    end

    def create_trip(name)
      name, key = name.split("#", 2)
      if name.empty?
        name = '名無し'
      end
      if key.present?
        trip = Digest::Trip.digest(key)
        name =  [name, trip].join "◆"
      end
      name
    end

    def image_analysis(post, is_updated=false)
      if post.images.present? && Rails.env.production?
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

    def ancher_follow(post)
      anchars = view_context.extract_2ch_anchar(post.body, false)
      if anchars.present?
        anchars.each{|anchar|
          post.follow(anchar[1].to_i)
        }
      end
    end

    def is_image_byte_error(params)
      is_magick_byte_error = false

      if params[:images].present?
        params[:images].each do |image|
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
