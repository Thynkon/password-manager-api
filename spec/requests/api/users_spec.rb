require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    post 'Creates a user and returns a JWT token' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string }
        },
        required: [ 'username', 'password' ]
      }

      response '201', 'user created' do
        schema type: :object,
               properties: {
                 token: { type: :string },
                 sym_key_salt: { type: :string }
               },
               required: [ 'token', 'sym_key_salt' ]

        let(:user) { { username: 'testuser', password: 'securepass' } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :array,
                   items: { type: :string }
                 }
               },
               required: [ 'errors' ]

        let(:user) { { username: '' } }

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

  path '/protected_route' do
    get 'Returns the authenticated user' do
      tags 'Users'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :Authorization,
                in: :header,
                type: :string,
                required: true,
                description: 'JWT token in the format: Bearer <token>'

      response '200', 'user info returned' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 username: { type: :string }
               },
               required: [ 'id', 'username' ]

        let(:Authorization) do
          user = User.create!(username: 'testuser', password: 'securepass')
          token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_hmac!, 'HS256')
          "Bearer #{token}"
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

      response '401', 'unauthorized' do
        schema type: :object,
               properties: {
                 message: { type: :string }
               },
               required: [ 'message' ]

        let(:Authorization) { 'Bearer invalidtoken' }

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
