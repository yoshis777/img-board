class GoogleCloudVisionController < ApplicationController

  def analysis
    file_path = "https://attrip.jp/wp-content/uploads/2018/12/tumblr_ksotvjTN0c1qzq3zxo1_400.jpg"
    google_cloud_vision = GoogleCloudVision.new(file_path)

    begin
      @text = google_cloud_vision.request
    rescue Exceptions::GoogleVisionApiException => e
      flash[:errors] = {title: Settings.errors.post_create_title, errors: ["画像の解析ができませんでした"]}
      redirect_to errors_path
    end
  end
end
