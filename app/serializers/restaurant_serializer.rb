class RestaurantSerializer
  include JSONAPI::Serializer

  attributes :id, :name
  has_many :menus, serializer: MenuSerializer
end
