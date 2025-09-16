class MenuController < ActionController::API
  def index
    render json: MenuSerializer.new(Menu.all).serializable_hash
  end

  def show
    menu = Menu.find(params[:id])
    render json: MenuSerializer.new(menu).serializable_hash
  end

  def create
    menu = Menu.new(menu_params)
    if menu.save
      render json: MenuSerializer.new(menu).serializable_hash, status: :created
    else
      render json: menu.errors, status: :unprocessable_entity
    end
  end

  def destroy
    menu = Menu.find(params[:id])
    menu.destroy
    head :no_content
  end

  private
  def menu_params
    params.require(:menu).permit(:name, :restaurant_id, menu_item_ids: [])
  end
end
