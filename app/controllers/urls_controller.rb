class UrlsController < ApplicationController
  def create
    url = Url.new(url_params)
    id = (Url.maximum(:id) || 0) + 1
    url.short_code = GenerateShortCodeService.new(id).call
    if url.save
      render json: url.to_json(except: [ :id, :original_url ], methods: :shorted_url), status: :created, location: url
    else
      render json: url.errors, status: :unprocessable_content
    end
  end

  def redirect_to_original_url
    short_code = params.expect!(:short_code)
    original_url = Rails.cache.fetch("#{Url.table_name}/#{short_code}/original_url") do
      Url
        .select(:original_url)
        .find_by!(short_code: short_code)
        .original_url
    end
    redirect_to original_url, allow_other_host: true
  end

  private

  def url_params
    params.expect(url: [ :original_url ])
  end
end
