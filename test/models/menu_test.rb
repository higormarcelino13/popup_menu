require "test_helper"

class MenuTest < ActiveSupport::TestCase
  test "is invalid without name" do
    menu = Menu.new(restaurant: Restaurant.create!(name: "R"))
    assert_not menu.valid?
    assert_includes menu.errors[:name], "can't be blank"
  end

  test "belongs to a restaurant" do
    restaurant = Restaurant.create!(name: "R")
    menu = Menu.create!(name: "Lunch", restaurant: restaurant)
    assert_equal restaurant.id, menu.restaurant.id
  end

  test "has and associates menu items" do
    restaurant = Restaurant.create!(name: "R")
    menu = Menu.create!(name: "Main", restaurant: restaurant)
    item1 = MenuItem.create!(name: "Dish 1", price: 10.0)
    item2 = MenuItem.create!(name: "Dish 2", price: 20.0)

    menu.menu_items << item1
    menu.menu_items << item2

    assert_equal 2, menu.menu_items.count
    assert_includes item1.menus, menu
  end
end

