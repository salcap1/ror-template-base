# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe ApplicationController, type: :request do # rubocop:disable RSpec/EmptyExampleGroup,RSpec/Rails/InferredSpecType
  path '/' do
    get 'Root Path' do
      tags 'Application'
      produces 'application/json'

      response '200', 'Root' do
        schema '$ref' => '#/components/schemas/SuccessResponse'

        run_test!
      end
    end
  end

  path '/heartbeat' do
    get 'Heartbeat Path' do
      tags 'Application'
      produces 'application/json'

      response '200', 'Heartbeat' do
        schema '$ref' => '#/components/schemas/SuccessResponse'

        run_test!
      end
    end
  end

  path '/error' do
    get 'Error Path' do
      tags 'Application'
      produces 'application/json'

      response '422', 'Error' do
        schema '$ref' => '#/components/schemas/ErrorResponse'

        run_test!
      end
    end
  end
end
