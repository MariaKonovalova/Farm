class Element < ActiveRecord::Base
  belongs_to :element_type
  belongs_to :growth_stage
end
