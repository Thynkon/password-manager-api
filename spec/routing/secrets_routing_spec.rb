require "rails_helper"

RSpec.describe SecretsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/secrets").to route_to("secrets#index")
    end

    it "routes to #show" do
      expect(get: "/secrets/1").to route_to("secrets#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/secrets").to route_to("secrets#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/secrets/1").to route_to("secrets#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/secrets/1").to route_to("secrets#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/secrets/1").to route_to("secrets#destroy", id: "1")
    end
  end
end
