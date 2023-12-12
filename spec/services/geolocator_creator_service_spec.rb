require 'rails_helper'

describe GeolocatorCreatorService do

  subject { described_class.new(search_key, search_value) }

  context 'with invalid parameters' do
    let(:search_key) { 'bad_key' }
    let(:search_value) { '' }

    it 'returns nil' do
      expect(subject.store).to be_nil
      expect(subject.errors.first).to eq("invalid parameters")
    end
  end

  context 'with an existing record' do
    let(:search_value) { 'www.positrace.com' }
    let(:search_key) { 'url' }

    before do
      geolocation = FactoryBot.create(:geolocation, ip: '172.10.1.1')
      FactoryBot.create(:url_location, geolocation: geolocation, url: 'www.positrace.com')
    end

    it 'returns nil' do
      expect(subject.store).to be_nil
      expect(subject.errors.first).to eq("record already exists")
    end
  end

  context 'simulating service locator error' do
    let(:search_value) { '142.30.1.4' }
    let(:search_key) { 'ip' }

    before do
      allow_any_instance_of(IpStackServiceProvider)
        .to receive(:fetch).with("142.30.1.4")
        .and_return([false, {"errors": ["my error"]}])
    end

    it 'returns a nil object' do
      record = subject.store
      expect(record).to be_nil
    end
  end

  context 'with valid parameters and a new ip to create' do
    let(:search_value) { '142.30.1.4' }
    let(:search_key) { 'ip' }

    it 'creates a new record' do
      VCR.use_cassette("ipstack_record") do
        record = subject.store
        expect(record).to be_persisted
        expect(record.ip).to eq('142.30.1.4')
      end
    end
  end

  context 'simulating a persistence error' do
    let(:search_value) { '142.30.1.4' }
    let(:search_key) { 'ip' }

    before do
      allow_any_instance_of(Geolocation)
        .to receive(:save).and_return(false)
    end

    it 'record is not created' do
      VCR.use_cassette("ipstack_record") do
        record = subject.store
        expect(record).to be_nil
      end
    end
  end

  context 'with valid parameters and a new url to create' do
    let(:search_value) { 'www.positrace.com' }
    let(:search_key) { 'url' }

    it 'creates a new record' do
      VCR.use_cassette("ipstack_positrace_record") do
        record = subject.store
        expect(record).to be_persisted
        expect(record.url_locations.first.url).to eq('www.positrace.com')
      end
    end
  end
end
