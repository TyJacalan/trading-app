# frozen_string_literal: true

require 'httparty'

class IEXApi # rubocop:disable Style/Documentation
  include HTTParty
  base_uri 'https://api.iex.cloud/v1/data/core'

  def initialize
    @options = { query: { token: Rails.application.credentials[:IEX_API_SECRET_TOKEN] } }
  end

  def all_stocks
    self.class.get('/REF_DATA', @options)
  end
end
