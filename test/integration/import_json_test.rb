require "test_helper"

class ImportJsonTest < ActionDispatch::IntegrationTest
  test "POST /restaurants/import imports and logs with deduplication" do
    payload = {
      restaurants: [
        {
          name: "Poppo's Cafe",
          menus: [
            {
              name: "lunch",
              menu_items: [
                { name: "Burger", price: 9.00 },
                { name: "Small Salad", price: 5.00 }
              ]
            },
            {
              name: "dinner",
              menu_items: [
                { name: "Burger", price: 15.00 },
                { name: "Large Salad", price: 8.00 }
              ]
            }
          ]
        },
        {
          name: "Casa del Poppo",
          menus: [
            {
              name: "lunch",
              dishes: [
                { name: "Chicken Wings", price: 9.00 },
                { name: "Burger", price: 9.00 },
                { name: "Chicken Wings", price: 9.00 }
              ]
            },
            {
              name: "dinner",
              dishes: [
                { name: "Mega \"Burger\"", price: 22.00 },
                { name: "Lobster Mac & Cheese", price: 31.00 }
              ]
            }
          ]
        }
      ]
    }

    post "/restaurants/import", params: payload
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal true, body["success"]
    assert body["logs"].is_a?(Array)

    assert Restaurant.where(name: "Poppo's Cafe").exists?
    assert Restaurant.where(name: "Casa del Poppo").exists?

    assert Menu.where(name: "lunch").exists?
    assert Menu.where(name: "dinner").exists?

    assert MenuItem.where(name: "Burger").exists?
    assert MenuItem.where(name: "Small Salad").exists?
    assert MenuItem.where(name: "Large Salad").exists?
    assert MenuItem.where(name: "Chicken Wings").exists?
    assert MenuItem.where(name: "Mega \"Burger\"").exists?
    assert MenuItem.where(name: "Lobster Mac & Cheese").exists?

    burger_items = MenuItem.where(name: "Burger").to_a
    assert_equal 1, burger_items.size
  end
end

