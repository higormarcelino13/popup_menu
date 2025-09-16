class MenuSerializer
  include JSONAPI::Serializer
  attributes :id, :name
  has_many :menu_items, serializer: MenuItemSerializer
end
