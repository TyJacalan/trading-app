# frozen_string_literal: true

IEX::Api.configure do |config|
  config.publishable_token = Rails.application.credentials[:IEX_API_SECRET_TOKEN]
  config.secret_token = Rails.application.credentials[:IEX_API_PUBLISHABLE_TOKEN]
  config.endpoint = 'https://cloud.iexapis.com/v1'
end
