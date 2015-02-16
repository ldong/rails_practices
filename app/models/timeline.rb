class Timeline < ActiveRecord::Base
  # belongs_to :timelineable, polymorphic: true
  belongs_to :timelineable, polymorphic: true
end
