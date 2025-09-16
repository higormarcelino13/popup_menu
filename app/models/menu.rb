class Menu
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_and_belongs_to_many :menu_items
  belongs_to :restaurant
  validates :name, presence: true

  field :name, type: String
end
