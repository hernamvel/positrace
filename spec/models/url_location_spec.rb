require 'rails_helper'

RSpec.describe UrlLocation, type: :model do
  context "validations" do
    before do
      FactoryBot.create(:url_location, url: 'myurl.com')
    end
    subject { FactoryBot.build(:url_location, url: url) }

    context "with a dupicated url" do
      let(:url) { 'myurl.com' }

      it 'is invalid' do
        expect(subject.valid?).to be false
        expect(subject.errors.first.attribute).to eq(:url)
        expect(subject.errors.first.type).to eq(:taken)
      end
    end

    context "with a non duplicated record" do
      let(:url) { 'myotherurl.com' }

      it 'is valid' do
        expect(subject.valid?).to be true
      end
    end
  end
end
