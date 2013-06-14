class Follow < ActiveRecord::Base
  belongs_to :location
  belongs_to :user
  #attr_accessible :user_id, :body, :location_id
  
  # Validations
  validates :user_id, :presence => true
  validates :location_id, :presence => true
  #validates_uniqueness_of [:user_id, :location_id]
  #validates :user_id :uniqueness => {:scope => :location_id}
end
