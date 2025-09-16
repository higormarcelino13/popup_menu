class MenuItem
  include Mongoid::Document
  include Mongoid::Timestamps
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_and_belongs_to_many :menus

  field :name, type: String
  field :price, type: Float
end
