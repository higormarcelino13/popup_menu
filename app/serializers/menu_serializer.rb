class MenuItemSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :price
end
