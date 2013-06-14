class Post < ActiveRecord::Base
  #belongs_to :location
  has_one :location
  belongs_to :user
  belongs_to :location  ##############
  attr_accessible :body, :location_id, :user_id
  validates :user_id, :presence => true
  validates :body, :presence => true
  validates :location_id, :presence => true
  def to_hash
    {
      :location_id => self.location_id,
      :body => self.text
    }
  end
end
