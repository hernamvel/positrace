require 'rails_helper'

RSpec.describe "/geolocations", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Geolocation.

  let!(:geolocation) { FactoryBot.create(:geolocation, ip: '172.10.1.1') }
  let!(:url_location) { FactoryBot.create(:url_location, geolocation: geolocation, url: 'www.google.com') }

  let(:valid_attributes) {
    {
      search_key: 'ip',
      search_value: '142.30.1.4',
    }
  }

  let(:invalid_attributes) {
    {
      fake_ip_attribute: 'x.x.x.x'
    }
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # GeolocationsController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      get geolocations_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.parsed_body["data"].count).to eq(1)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get geolocation_url(geolocation), as: :json
      expect(response).to be_successful
      expect(response.parsed_body["data"]["id"]).to eq(geolocation.id)
    end

    it "renders an unsuccessful response" do
      get geolocation_url('xxx'), as: :json
      expect(response.status).to eq(404)
      expect(response.parsed_body["errors"].count).to eq(1)
    end
  end

  describe "GET /search_by" do
    context 'with an existing ip' do
      let(:params) do
        {
          search_value: '172.10.1.1',
          search_key: 'ip'
        }
      end

      it "renders a successful response" do
        get search_by_geolocations_url, params: params
        expect(response).to be_successful
        expect(response.parsed_body["data"]["id"]).to eq(geolocation.id)
      end
    end

    context 'with an existing url' do
      let(:params) do
        {
          search_key: 'url',
          search_value: 'www.google.com'
        }
      end

      it "renders a successful response" do
        get search_by_geolocations_url, params: params
        expect(response).to be_successful
        expect(response.parsed_body["data"]["id"]).to eq(geolocation.id)
      end
    end

    context 'with a non existing hostname' do
      let(:params) do
        {
          search_key: 'url',
          search_value: 'yyy.com'
        }
      end

      it "renders an unsuccessful response" do
        get search_by_geolocations_url, params: params
        expect(response.status).to eq(404)
        expect(response.parsed_body["errors"].count).to eq(1)
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Geolocation" do
        VCR.use_cassette("ipstack_record") do
          expect {
            post geolocations_url,
                 params: valid_attributes, headers: valid_headers, as: :json
          }.to change(Geolocation, :count).by(1)
        end
      end

      it "renders a JSON response with the new geolocation" do
        VCR.use_cassette("ipstack_record") do
          post geolocations_url,
               params: valid_attributes, headers: valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end

    context "with invalid parameters" do
      it "does not create a new Geolocation" do
        expect {
          post geolocations_url,
               params: { geolocation: invalid_attributes }, as: :json
        }.to change(Geolocation, :count).by(0)
      end

      it "renders a JSON response with errors for the new geolocation" do
        post geolocations_url,
             params: { geolocation: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy_by" do
    context 'with an existing ip' do
      let(:params) do
        {
          search_value: '172.10.1.1',
          search_key: 'ip'
        }
      end

      it "destroys the requested geolocation" do
        expect {
          delete destroy_by_geolocations_url, params: params, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(-1).and change(UrlLocation, :count).by(-1)
      end
    end

    context 'with an existing url' do
      let(:params) do
        {
          search_key: 'url',
          search_value: 'www.google.com'
        }
      end

      it "destroys the requested geolocation" do
        expect {
          delete destroy_by_geolocations_url, params: params, headers: valid_headers, as: :json
        }.to change(Geolocation, :count).by(-1).and change(UrlLocation, :count).by(-1)
      end
    end

    context 'with a non existing hostname' do
      let(:params) do
        {
          search_key: 'url',
          search_value: 'ttt.com'

        }
      end

      it "does not destroy any geolocation" do
        delete destroy_by_geolocations_url, params: params, headers: valid_headers, as: :json
        expect(response.status).to eq(404)
        expect(Geolocation.count).to eq(1)
      end
    end
  end
end
