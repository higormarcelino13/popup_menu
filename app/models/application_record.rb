class ApplicationRecord 
  include Mongoid::Document
  include Mongoid::Timestamps

  self.abstract_class = true
end
