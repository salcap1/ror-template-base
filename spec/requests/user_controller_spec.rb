# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe UserController do
  path '/user' do
    delete('delete current user') do
      tags 'User'
      produces 'application/json'

      response(204, 'no content') do
        context 'with logged in user' do
          include_context 'with authenticated user'

          run_test! do
            expect(User.count).to eq 0
          end
        end
      end

      response(422, 'unprocessable entity') do
        schema '$ref' => '#/components/schemas/error_object'
        examples

        context 'with logged in user' do
          include_context 'with authenticated user'

          before do
            allow(user).to receive(:destroy).and_raise(StandardError, 'Unable to delete User.')
          end

          run_test! do |res|
            expect(response_errors(res)).to include('Unable to delete User.')
          end
        end
      end

      context 'without logged in user' do
        it_behaves_like('unauthenticated request')
      end
    end
  end
end
