# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.shared_examples 'unauthenticated request' do
  response '401', 'Unauthenticated' do
    schema '$ref' => '#/components/schemas/error_object'
    example 'application/json', :key, {
      message: 'Unauthorized',
      errors: ['A List of Errors'],
      context: { some: 'Error Information' }
    }

    run_test!
  end
end
