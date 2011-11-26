class Plant < ActiveRecord::Base
  belongs_to :field
  belongs_to :element
end
