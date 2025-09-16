class JsonImportService
  Result = Struct.new(:success, :logs)

  def initialize(payload)
    @payload = payload
    @logs = []
  end

  def call
    restaurants = @payload[:restaurants] || []
    restaurants.each do |restaurant_hash|
      process_restaurant(restaurant_hash)
    end
    Result.new(true, @logs)
  rescue => e
    @logs << { level: "error", message: e.message }
    Result.new(false, @logs)
  end

  private

  def process_restaurant(rh)
    restaurant = Restaurant.find_or_create_by(name: rh[:name] || rh["name"])
    menus = rh[:menus] || rh["menus"] || []
    menus.each do |menu_hash|
      process_menu(restaurant, menu_hash)
    end
  end

  def process_menu(restaurant, mh)
    menu = restaurant.menus.where(name: mh[:name] || mh["name"]).first || restaurant.menus.create!(name: mh[:name] || mh["name"])
    items = mh[:menu_items] || mh["menu_items"] || mh[:dishes] || mh["dishes"] || []
    items.each do |item_hash|
      name = item_hash[:name] || item_hash["name"]
      price = (item_hash[:price] || item_hash["price"]).to_f
      menu_item = MenuItem.where(name: name).first || MenuItem.create!(name: name, price: price)
      menu.menu_items << menu_item unless menu.menu_items.where(id: menu_item.id).exists?
      @logs << { level: "info", restaurant: restaurant.name, menu: menu.name, item: name, price: price }
    end
  rescue => e
    @logs << { level: "error", menu: mh[:name] || mh["name"], message: e.message }
  end
end

