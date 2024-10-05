# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

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
              default: 'Bearer xxx'
            }
          }
        }
      ],
      components: {
        schemas: {
          SuccessResponse: {
            type: :object,
            properties: {
              status: {
                type: :string,
                example: 'success'
              },
              message: {
                type: :string,
                example: 'Success'
              },
              data: {
                type: :object,
                description: 'Payload containing data'
              }
            },
            required: %w[status message data]
          },
          ErrorResponse: {
            type: :object,
            properties: {
              status: {
                type: :string,
                example: 'error'
              },
              message: {
                type: :string,
                example: 'Error'
              },
              errors: {
                type: :array,
                items: {
                  type: :string,
                  example: 'Transaction failed'
                }
              }
            },
            required: %w[status message errors]
          }
        },
        responses: {
          Success: {
            description: 'Generic success response',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/SuccessResponse'
                }
              }
            }
          },
          ValidationError: {
            description: 'Validation or invalid input error response',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/ErrorResponse'
                }
              }
            }
          },
          NotFoundError: {
            description: 'Resource not found error',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/ErrorResponse'
                }
              }
            }
          },
          ServerError: {
            description: 'Internal server error',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/ErrorResponse'
                }
              }
            }
          },
          UnauthorizedError: {
            description: 'Unauthorized error',
            content: {
              'application/json': {
                schema: {
                  '$ref': '#/components/schemas/ErrorResponse'
                }
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # Defaults to json. Accepts ':json' and ':yaml'.
  # config.swagger_format = :yaml

  config.openapi_strict_schema_validation = false
end
