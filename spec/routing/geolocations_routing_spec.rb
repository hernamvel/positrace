require "rails_helper"

RSpec.describe GeolocationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/geolocations").to route_to("geolocations#index")
    end

    it "routes to #show" do
      expect(get: "/geolocations/1").to route_to("geolocations#show", id: "1")
    end

    it "routes to #search_by" do
      expect(get: "/geolocations/search_by").to route_to("geolocations#search_by")
    end

    it "routes to #create" do
      expect(post: "/geolocations").to route_to("geolocations#create")
    end

    it "routes to #delete_by" do
      expect(delete: "/geolocations/destroy_by").to route_to("geolocations#destroy_by")
    end

  end
end
