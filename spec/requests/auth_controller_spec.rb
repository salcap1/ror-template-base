# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe AuthController do
  path '/auth/check' do
    get 'Check if User is Signed In' do
      tags 'Authentication'
      produces 'application/json'

      context 'with logged in user' do
        include_context 'with authenticated user'

        response '200', 'User is Signed In' do
          run_test!
        end
      end

      context 'without logged in user' do
        it_behaves_like('unauthenticated request')
      end
    end
  end

  path '/auth/refresh' do
    get 'Refresh User Token' do
      tags 'Authentication'
      produces 'application/json'

      context 'with logged in user' do
        include_context 'with authenticated user'

        before do
          allow(Auth::Refresher)
            .to receive(:refresh!)
            .with(refresh_token:, decoded_token:, user:)
            .and_return(%w[new_access_token new_refresh_token])
        end

        response '200', 'Auth Cookies Refreshed' do
          run_test! do
            expect(cookies.signed[:access_token]).to eq('new_access_token')
            expect(cookies.signed[:refresh_token]).to eq('new_refresh_token')
          end
        end
      end

      context 'without logged in user' do
        it_behaves_like('unauthenticated request')
      end
    end
  end

  path '/auth/signin' do
    post 'Sign In User' do
      tags 'Authentication'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '201', 'User Signed In' do
        schema '$ref' => '#/components/schemas/User'

        include_context 'with cookie jar'
        include_context 'with issued tokens'

        let(:user) { create(:user).slice(:email, :password) }

        run_test! do
          expect(cookies.signed[:access_token]).to eq(new_access_token)
          expect(cookies.signed[:refresh_token]).to eq(new_refresh_token)
        end
      end

      response '400', 'Bad Params' do
        schema '$ref' => '#/components/schemas/ErrorResponse'
        examples

        let(:user) { { password: 'P@ssw0rd!234' } }

        run_test!
      end

      response '422', 'Signin Error' do
        schema '$ref' => '#/components/schemas/ErrorResponse'

        let(:user) { { email: create(:user).email, password: 'incorrect_password' } }

        run_test!
      end
    end
  end

  path '/auth/signup' do
    post 'Create a User' do
      tags 'Authentication'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          username: { type: :string },
          password: { type: :string }
        },
        required: %w[email username password]
      }

      response '201', 'User Created' do
        schema '$ref' => '#/components/schemas/User'

        include_context 'with cookie jar'
        include_context 'with issued tokens'

        let(:user) do
          {
            email: Faker::Internet.unique.email,
            username: Faker::Internet.unique.username,
            password: 'P@ssw0rd!234'
          }
        end

        run_test! do
          new_user = User.find_by(email: user[:email])

          expect(new_user).to be_present
          expect(Profile.find_by(user: new_user)).to be_present
          expect(cookies.signed[:access_token]).to eq(new_access_token)
          expect(cookies.signed[:refresh_token]).to eq(new_refresh_token)
        end
      end

      response '400', 'Bad Params' do
        schema '$ref' => '#/components/schemas/ErrorResponse'
        examples

        let(:user) do
          {
            username: Faker::Internet.unique.username,
            password: 'P@ssw0rd!234'
          }
        end

        run_test! do |res|
          expect(response_message(res)).to eq('Missing required parameters.')
        end
      end

      response '422', 'User exists' do
        schema '$ref' => '#/components/schemas/ErrorResponse'
        examples

        let(:existing_user) { create(:user) }
        let(:user) do
          {
            email: existing_user.email,
            username: Faker::Internet.unique.username,
            password: 'P@ssw0rd!234'
          }
        end

        run_test! do |res|
          expect(response_message(res)).to eq('Unable to create User.')
        end
      end

      response '422', 'Could not create User' do
        schema '$ref' => '#/components/schemas/ErrorResponse'
        examples

        let(:user_instance) { instance_double(User) }
        let(:user) do
          {
            email: Faker::Internet.unique.email,
            username: Faker::Internet.unique.username,
            password: 'P@ssw0rd!234'
          }
        end

        before do
          errors = instance_double(ActiveModel::Errors)
          allow(user_instance).to receive_messages({ save: false, errors: })
          allow(errors).to receive(:full_messages).and_return(['Error creating User.'])
          allow(User).to receive(:new).and_return(user_instance)
        end

        run_test! do |res|
          expect(response_message(res)).to eq('Unable to create User.')
        end
      end

      response '422', 'Could not create Profile' do
        schema '$ref' => '#/components/schemas/ErrorResponse'
        examples

        let(:profile_instance) { instance_double(Profile, save: false) }
        let(:user) do
          {
            email: Faker::Internet.unique.email,
            username: Faker::Internet.unique.username,
            password: 'P@ssw0rd!234'
          }
        end

        before do
          errors = instance_double(ActiveModel::Errors)
          allow(profile_instance).to receive_messages({ save: false, errors: })
          allow(errors).to receive(:full_messages).and_return(['Error creating Profile.'])
          allow(Profile).to receive(:new).and_return(profile_instance)
        end

        run_test! do |res|
          expect(response_message(res)).to eq('Unable to create Profile.')
        end
      end
    end
  end

  path '/auth/signout' do
    delete 'Sign Out User' do
      tags 'Authentication'
      produces 'application/json'

      response '204', 'User Signed Out' do
        context 'with logged in user' do
          include_context 'with authenticated user'

          before do
            allow(Auth::Revoker)
              .to receive(:revoke!)
              .with(decoded_token:, user:)
              .and_return(nil)
          end

          run_test! do
            expect(cookies.signed[:access_token]).to be_nil
            expect(cookies.signed[:refresh_token]).to be_nil
          end
        end
      end

      context 'without logged in user' do
        it_behaves_like('unauthenticated request')
      end
    end
  end
end
