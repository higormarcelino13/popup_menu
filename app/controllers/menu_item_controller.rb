class MenuItemController < ActionController::API
  def index
    render json: MenuItemSerializer.new(MenuItem.all).serializable_hash
  end

  def show
    menu_item = MenuItem.find(params[:id])
    render json: MenuItemSerializer.new(menu_item).serializable_hash
  end

  def create
    menu_item = MenuItem.new(menu_item_params)
    if menu_item.save
      render json: MenuItemSerializer.new(menu_item).serializable_hash, status: :created
    else
      render json: menu_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    menu_item = MenuItem.find(params[:id])
    menu_item.destroy
    head :no_content
  end

  private
  def menu_item_params
    params.require(:menu_item).permit(:name, :price)
  end
end
