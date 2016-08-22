class Link < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :url

  def create_short_url
    self.random_hex_string = SecureRandom.urlsafe_base64(5)
    self.short_url = 'localhost' + "/#{random_hex_string}"
    self.save
  end
end
