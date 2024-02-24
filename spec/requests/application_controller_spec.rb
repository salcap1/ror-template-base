# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe ApplicationController do
  describe 'routes' do
    it '#root' do
      get '/'

      expect(response).to have_http_status(:ok)
    end

    it '#heartbeat' do
      get '/heartbeat'

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq({ 'message' => 'healthy' })
    end

    it '#error' do
      get '/error'

      expect(response).to have_http_status(:not_found)
      expect(response.parsed_body).to eq({ 'message' => 'error' })
    end
  end
end
