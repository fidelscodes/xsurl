class Link < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :url, :short_url
end
