class Field < ActiveRecord::Base
  belongs_to :user
  has_many :plant
end
