require "test_helper"

class MenuTest < ActiveSupport::TestCase
  test "é inválido sem nome" do
    menu = Menu.new(restaurant: Restaurant.create!(name: "R"))
    assert_not menu.valid?
    assert_includes menu.errors[:name], "can't be blank"
  end

  test "pertence a um restaurante" do
    restaurant = Restaurant.create!(name: "R")
    menu = Menu.create!(name: "Almoço", restaurant: restaurant)
    assert_equal restaurant.id, menu.restaurant.id
  end

  test "tem e associa itens de menu" do
    restaurant = Restaurant.create!(name: "R")
    menu = Menu.create!(name: "Principal", restaurant: restaurant)
    item1 = MenuItem.create!(name: "Prato 1", price: 10.0)
    item2 = MenuItem.create!(name: "Prato 2", price: 20.0)

    menu.menu_items << item1
    menu.menu_items << item2

    assert_equal 2, menu.menu_items.count
    assert_includes item1.menus, menu
  end
end

