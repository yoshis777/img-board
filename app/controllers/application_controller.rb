class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  unless Rails.env.development?
    rescue_from Exception, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def render_404(e = nil)
    Rails.logger.error "error: #{e}" if e
    render template: "exceptions/exception_404.html.erb", layout: true, status: 404
  end

  def render_400(e = nil)
    Rails.logger.error "error: #{e}" if e
    render template: "exceptions/exception_400.html.erb", layout: true, status: 400
  end

  def render_500(e = nil)
    Rails.logger.error "error: #{e}" if e
    render template: "exceptions/exception_500.html.erb", layout: true, status: 500
  end
end
