require 'resolv'

class Geolocation < ApplicationRecord

  validates :ip, presence: true, uniqueness: true
  validates :hostname, presence: true, uniqueness: true
  validate :valid_ip

  private

  def valid_ip
    if !(ip =~ Resolv::IPv4::Regex)
      errors.add(:ip, "invalid format")
    end
  end

end
