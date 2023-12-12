require 'rails_helper'

RSpec.describe Geolocation, type: :model do

  context "validations" do
    before do
      FactoryBot.create(:geolocation, ip: '172.10.1.1')
    end
    subject { FactoryBot.build(:geolocation, ip: ip) }

    context "with a dupicated ip" do
      let(:ip) { '172.10.1.1' }

      it 'is invalid' do
        expect(subject.valid?).to be false
        expect(subject.errors.first.attribute).to eq(:ip)
        expect(subject.errors.first.type).to eq(:taken)
      end
    end

    context "with an invalid ip" do
      let(:ip) { 'x.a,y' }

      it 'is not valid' do
        expect(subject.valid?).to be false
      end
    end

    context "with a non duplicated record" do
      let(:ip) { '170.0.31.11' }

      it 'is valid' do
        expect(subject.valid?).to be true
      end
    end
  end

  context "#locate_by" do
    before do
      geolocation = FactoryBot.create(:geolocation, ip: '172.10.1.1')
      FactoryBot.create(:url_location, geolocation: geolocation, url: 'www.positrace.com')
    end

    subject { Geolocation.locate_by(search_key, search_value) }

    context "existing url" do
      let(:search_value) { 'www.positrace.com' }
      let(:search_key) { 'url' }

      it { expect(subject).to be_present }
    end

    context "inexisting url" do
      let(:search_value) { 'www.gogle.com' }
      let(:search_key) { 'url' }

      it { expect(subject).to be_nil }
    end

    context "existing ip" do
      let(:search_value) { '172.10.1.1' }
      let(:search_key) { 'ip' }

      it { expect(subject).to be_present }
    end

    context "inexisting ip" do
      let(:search_value) { '1.1.1.1' }
      let(:search_key) { 'ip' }

      it { expect(subject).to be_nil }
    end

    context "invalid search_value" do
      let(:search_value) { '' }
      let(:search_key) { 'ip' }

      it { expect(subject).to be_nil }
    end

    context "invalid search_key" do
      let(:search_value) { 'www.cnn.com' }
      let(:search_key) { 'badkey' }

      it { expect(subject).to be_nil }
    end

  end
end
