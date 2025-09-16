require "test_helper"

class RestaurantControllerTest < ActionDispatch::IntegrationTest
  test "GET /restaurants/show retorna lista de restaurantes" do
    Restaurant.create!(name: "R1")
    Restaurant.create!(name: "R2")

    get "/restaurants/show"
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal 2, body["data"].length
  end

  test "POST /restaurants/create cria restaurante válido" do
    post "/restaurants/create", params: { restaurant: { name: "Novo" } }
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal "Received params", body["message"]
  end

  test "DELETE /restaurants/:id deleta restaurante" do
    r = Restaurant.create!(name: "R3")
    delete "/restaurants/#{r.id}"
    assert_response :success
    body = JSON.parse(@response.body)
    assert_equal "Restaurant was successfully destroyed.", body["message"]
    assert_nil Restaurant.where(id: r.id).first
  end

  test "POST /restaurants/bulk_create cria dados conforme payload do teste" do
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

    post "/restaurants/bulk_create", params: payload
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal "Processed restaurants", body["message"]
  end
end


