class RestaurantSerializer
  include JSONAPI::Serializer

  attributes :id, :name
  has_many :menus
end
