class Plant < ActiveRecord::Base
  belongs_to :field
  belongs_to :element_type
  belongs_to :growth_stage
end
