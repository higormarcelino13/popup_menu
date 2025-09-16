require "test_helper"

class MenuItemTest < ActiveSupport::TestCase
  test "is invalid without name" do
    item = MenuItem.new(price: 5.0)
    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "is invalid with missing or negative price" do
    item = MenuItem.new(name: "Prato")
    assert_not item.valid?
    assert_includes item.errors[:price], "can't be blank"

    item2 = MenuItem.new(name: "Prato", price: -1)
    assert_not item2.valid?
  end

  test "associates with menus via HABTM" do
    item = MenuItem.create!(name: "P1", price: 12.5)
    r = Restaurant.create!(name: "R")
    m = Menu.create!(name: "M", restaurant: r)
    m.menu_items << item
    assert_includes item.menus, m
  end
end

