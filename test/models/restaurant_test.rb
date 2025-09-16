require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  test "is invalid without name" do
    restaurant = Restaurant.new
    assert_not restaurant.valid?
    assert_includes restaurant.errors[:name], "can't be blank"
  end

  test "has many menus and destroys dependents" do
    restaurant = Restaurant.create!(name: "R1")
    menu1 = Menu.create!(name: "M1", restaurant: restaurant)
    menu2 = Menu.create!(name: "M2", restaurant: restaurant)

    assert_equal 2, restaurant.menus.count

    restaurant.destroy
    assert_equal 0, Menu.where(restaurant_id: restaurant.id).count
  end
end

