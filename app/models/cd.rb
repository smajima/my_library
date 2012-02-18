class Cd < ActiveRecord::Base 
  validates :ganre, :presence => true
  validates :artist, :presence => true, :length => {:maximum => 255}
  validates :title, :presence => true, :length => {:maximum => 255}
end
