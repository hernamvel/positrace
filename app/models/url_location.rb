class UrlLocation < ApplicationRecord

  belongs_to :geolocation, dependent: :destroy

  validates :url, presence: true, uniqueness: true

end
