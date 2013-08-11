class Project < ActiveRecord::Base
  belongs_to :estimate
  
  attr_accessible :description, :estimate_id, :estimation_time_in_days
end
