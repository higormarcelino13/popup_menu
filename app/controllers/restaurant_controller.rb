class RestaurantController < ActionController::API
  def index
    restaurants = Restaurant.all
    render json: RestaurantSerializer.new(restaurants).serializable_hash
  end

  def show
    restaurant = Restaurant.find(params[:id])
    render json: RestaurantSerializer.new(restaurant).serializable_hash
  end

  def create
    puts "Received params:"
    p restaurant_params
    render json: { message: "Received params", params: params }, status: :ok and return

    restaurant = Restaurant.new(restaurant_params)
    if restaurant.save
      render json: restaurant, status: :created, serializer: RestaurantSerializer
    else
      render json: restaurant.errors, status: :unprocessable_entity
    end
  end

  def bulk_create
    puts "Received bulk create params:"
    p params.inspect
    restaurants = params[:restaurants]&.map do |restaurant_param|
      restaurant_param
    end
    render json: { message: "Processed restaurants", restaurants: restaurants }, status: :ok and return
    if restaurants.all?(&:valid?)
      restaurants.each(&:save)
      render json: restaurants, status: :created, each_serializer: RestaurantSerializer
    else
      errors = restaurants.map.with_index do |restaurant, index|
        { index: index, errors: restaurant.errors.full_messages } unless restaurant.valid?
      end.compact
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def import
    service = JsonImportService.new(params.permit!.to_h.deep_symbolize_keys)
    result = service.call
    status_code = result.success ? :ok : :unprocessable_entity
    render json: { success: result.success, logs: result.logs }, status: status_code
  end

  def destroy
    restaurant = Restaurant.find(params[:id])
    restaurant.destroy
    render json: { message: "Restaurant was successfully destroyed." }
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, menus_attributes: [:name, menu_items_attributes: []], menu_items_attributes: [:name, :price])
  end
end
