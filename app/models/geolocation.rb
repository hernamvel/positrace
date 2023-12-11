require 'resolv'

class Geolocation < ApplicationRecord

  validates :ip, presence: true, uniqueness: true
  validate :valid_ip
  has_many :url_locations

  private

  def valid_ip
    if !(ip =~ Resolv::IPv4::Regex)
      errors.add(:ip, "invalid format")
    end
  end

  def self.locate_by(search_key, search_value)
    chain = if search_value.blank?
      Geolocation.none
    elsif search_key == 'ip'
      Geolocation.where(ip: search_value)
    elsif search_key == 'url'
      Geolocation.joins(:url_locations).where("url_locations.url = ?", search_value)
    else
      Geolocation.none
    end
    chain.first
  end
end
