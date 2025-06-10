require 'swagger_helper'

RSpec.describe 'Authentication', type: :request do
  path '/login' do
    post 'Logs in a user and returns a JWT token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string }
        },
        required: [ 'username', 'password' ]
      }

      response '202', 'successful login' do
        schema type: :object,
               properties: {
                 token: { type: :string },
                 sym_key_salt: { type: :string }
               },
               required: [ 'token', 'sym_key_salt' ]

        let(:credentials) do
          User.create!(username: 'testuser', password: 'securepass')
          { username: 'testuser', password: 'securepass' }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '401', 'unauthorized (invalid credentials or unknown user)' do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: [ 'message' ]

        let(:credentials) { { username: 'testuser', password: 'wrongpass' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end
  end
end
