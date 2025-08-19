class UrlsController < ApplicationController
  def create
    @url = Url.new(url_params)
    id = (Url.maximum(:id) || 0) + 1
    @url.short_code = GenerateShortCodeService.new(id).call
    if @url.save
      render json: @url.to_json(except: [ :id, :original_url ]), status: :created, location: @url
    else
      render json: @url.errors, status: :unprocessable_content
    end
  end

  private

  def url_params
    params.expect(url: [ :original_url ])
  end
end
