require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  test "é inválido sem nome" do
    restaurant = Restaurant.new
    assert_not restaurant.valid?
    assert_includes restaurant.errors[:name], "can't be blank"
  end

  test "tem muitos menus e apaga dependentes" do
    restaurant = Restaurant.create!(name: "R1")
    menu1 = Menu.create!(name: "M1", restaurant: restaurant)
    menu2 = Menu.create!(name: "M2", restaurant: restaurant)

    assert_equal 2, restaurant.menus.count

    restaurant.destroy
    assert_equal 0, Menu.where(restaurant_id: restaurant.id).count
  end
end

