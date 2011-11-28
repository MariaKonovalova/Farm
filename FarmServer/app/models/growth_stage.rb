class GrowthStage < ActiveRecord::Base
  has_many :elements
  has_many :plants
end
