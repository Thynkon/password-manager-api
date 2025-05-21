# spec/integration/secrets_spec.rb
require 'swagger_helper'

RSpec.describe 'Secrets API', type: :request do
  path '/secrets' do
    get 'List secrets of the authenticated user' do
      tags 'Secrets'
      security [ bearer_auth: [] ]
      produces 'application/json'

      response '200', 'secrets listed' do
        let(:Authorization) do
          user = User.create!(username: 'testuser', password: 'securepass')
          Secret.create!(value: 'my secret', user: user)
          token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_hmac!, 'HS256')
          "Bearer #{token}"
        end

        run_test!
      end
    end

    post 'Create a secret' do
      tags 'Secrets'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :secret, in: :body, schema: {
        type: :object,
        properties: {
          value: { type: :string },
          user_id: { type: :integer }
        },
        required: [ 'value', 'user_id' ]
      }

      response '201', 'secret created' do
        let(:Authorization) do
          user = User.create!(username: 'testuser', password: 'securepass')
          token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_hmac!, 'HS256')
          "Bearer #{token}"
        end

        let(:secret) { { value: 'new secret', user_id: User.last.id } }

        run_test!
      end
    end
  end

  path '/secrets/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Secret ID'

    get 'Get a specific secret' do
      tags 'Secrets'
      security [ bearer_auth: [] ]
      produces 'application/json'

      response '200', 'secret found' do
        let(:Authorization) do
          user = User.create!(username: 'testuser', password: 'securepass')
          secret = Secret.create!(value: 'secret', user: user)
          token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_hmac!, 'HS256')
          "Bearer #{token}"
        end

        let(:id) { Secret.last.id }

        run_test!
      end

      response '403', 'not your secret' do
        let(:Authorization) do
          user = User.create!(username: 'hacker', password: 'hack')
          token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_hmac!, 'HS256')
          "Bearer #{token}"
        end

        let(:id) do
          owner = User.create!(username: 'owner', password: 'safe')
          Secret.create!(value: 'owned', user: owner).id
        end

        run_test!
      end
    end

    patch 'Update a secret' do
      tags 'Secrets'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      parameter name: :secret, in: :body, schema: {
        type: :object,
        properties: {
          value: { type: :string }
        }
      }

      response '200', 'secret updated' do
        let(:Authorization) do
          user = User.create!(username: 'testuser', password: 'securepass')
          Secret.create!(value: 'initial', user: user)
          token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_hmac!, 'HS256')
          "Bearer #{token}"
        end

        let(:id) { Secret.last.id }
        let(:secret) { { value: 'updated secret' } }

        run_test!
      end
    end

    delete 'Delete a secret' do
      tags 'Secrets'
      security [ bearer_auth: [] ]

      response '204', 'secret deleted' do
        let(:Authorization) do
          user = User.create!(username: 'testuser', password: 'securepass')
          Secret.create!(value: 'to delete', user: user)
          token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_hmac!, 'HS256')
          "Bearer #{token}"
        end

        let(:id) { Secret.last.id }

        run_test!
      end
    end
  end
end
