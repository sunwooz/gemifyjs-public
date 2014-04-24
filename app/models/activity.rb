class Activity < ActiveRecord::Base
  belongs_to :jem
  belongs_to :trackable, polymorphic: true
end
