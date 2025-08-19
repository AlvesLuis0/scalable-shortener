class UrlsController < ApplicationController
  def create
    @url = Url.new(url_params)
    id = Url.maximum(:id) || 1
    @url.short_code = GenerateShortCodeService.new(id).call
    if @url.save
      render json: @url, status: :created, location: @url
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  private

  def url_params
    params.expect(url: [ :original_url ])
  end
end
