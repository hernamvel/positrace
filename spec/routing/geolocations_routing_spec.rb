require "rails_helper"

RSpec.describe GeolocationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/geolocations").to route_to("geolocations#index")
    end

    it "routes to #show" do
      expect(get: "/geolocations/1").to route_to("geolocations#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/geolocations").to route_to("geolocations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/geolocations/1").to route_to("geolocations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/geolocations/1").to route_to("geolocations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/geolocations/1").to route_to("geolocations#destroy", id: "1")
    end
  end
end
