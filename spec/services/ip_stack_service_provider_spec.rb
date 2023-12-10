require 'rails_helper'

describe IpStackServiceProvider do
  
  let(:access_key) { 'dummy_key' }
  subject { described_class.new(access_key) }

  context 'with a correct key' do
    let(:ip) { '142.30.1.4' }

    it 'returns a valid response' do
      VCR.use_cassette("ipstack_record") do
        success, record = subject.fetch(ip)
        expect(success).to be true
        expect(record[:ip]).to eq('142.30.1.4')
        [:city, :country_code, :country_name, :hostname, :ip, :latitude, :longitude, :region_code].each do |key|
          expect(record[key]).to be_present
        end
      end
    end
  end

  context 'with a incorrect key' do
    let(:access_key) { 'bad_key' }
    let(:ip) { '142.30.1.4' }

    it 'returns a valid response' do
      VCR.use_cassette("ipstack_bad_key") do
        success, record = subject.fetch(ip)
        expect(success).to be false
        expect(record[:error]).to be_present
      end
    end
  end
end
