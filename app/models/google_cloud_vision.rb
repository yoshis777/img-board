class GoogleCloudVision
  require "google/cloud/vision"
  attr_accessor :file_path

  def initialize(file_path, is_updated=false)
    @file_path = file_path
    @is_updated = is_updated
  end

  # raise Exceptions::GoogleVisionApiException
  def request
    api_count = ApiHistory.select(:id).where(name: 'google vision api', updated_at: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month).count
    puts api_count.to_s
    if api_count > Settings.api.max_num_of_use
      Rails.logger.error("google vision api warn: 回数制限超過（" + api_count.to_s + "回）")
      raise Exceptions::GoogleVisionApiException, "回数制限超過"
    end

    begin
      image_annotator = Google::Cloud::Vision::ImageAnnotator.new
    rescue RuntimeError => e
      Rails.logger.error("google vision api error: " + e.message)
      raise Exceptions::GoogleVisionApiException, "認証時のRuntimeError"
    end
    text = ""

    response = image_annotator.document_text_detection image: @file_path
    ApiHistory.new(name: "google vision api", file_name: File.basename(@file_path), is_updated: @is_updated).save

    if response.blank? || response.responses.blank?
      Rails.logger.error("google vision api error: 返却値が存在しない")
      raise Exceptions::GoogleVisionApiException, "返却値が存在しない"
    end

    if response.responses.first.error.present?
      Rails.logger.error("google vision api error: レンポンスは存在するが、何らかのエラー")
      Rails.logger.error("error: " + response.responses.first.error.message)
      raise Exceptions::GoogleVisionApiException, response.responses.first.error.message
    end

    # 正常系
    if response.responses.present? && response.responses.first.text_annotations.present?
      res = response.responses.first
      annotation = res.text_annotations.first
      text = annotation.description
    end

    # text = ""
    # response.responses.each do |res|
    #   res.text_annotations.each do |annotation|
    #     text << annotation.description
    #   end
    # end

    text
  end
end
