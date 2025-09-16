class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :menus, dependent: :destroy
  validates :name, presence: true

  field :name, type: String
end
