# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'Your App Name V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3001'
            },
            token: {
              defaultToken: {
                default: 'Bearer xxx'
              }
            }
          }
        }
      ],
      components: {
        schemas: {
          error_object: {
            type: :object,
            properties: {
              message: { type: :string },
              errors: { type: :array },
              context: { type: :object }
            },
            required: %w[message errors]
          },
          user_object: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  uuid: { type: :string },
                  email: { type: :string },
                  username: { type: :string }
                },
                required: %w[id uuid email username]
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  # config.swagger_format = :yaml

  config.openapi_strict_schema_validation = false
end
