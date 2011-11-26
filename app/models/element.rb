class Element < ActiveRecord::Base
  belongs_to :element_type
  belongs_to :growth
  has_many :plant
end
