class ErrorsController < ApplicationController
  def show
    if flash.empty? || flash["errors"].empty?
      redirect_to topics_path
    end
  end
end
