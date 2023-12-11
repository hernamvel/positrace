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


    context "with a non duplicated record" do
      let(:ip) { '170.0.31.11' }

      it 'is valid' do
        expect(subject.valid?).to be true
      end
    end
  end
end
