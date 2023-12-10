require 'rails_helper'

describe GeolocatorServiceProvider do

  context '#get_insance' do
    subject { described_class.get_instance }

    it 'returns the service locator defined in test section of geolocations.yml' do
      expect(subject).to be_a IpStackServiceProvider
    end
  end

  context '#fetch' do
    let(:access_key) { 'dummy_key' }
    subject { described_class.new(access_key) }

    it 'cant be called from this class' do
      expect{ subject.fetch('x') }.to raise_error(RuntimeError)
    end
  end
end
