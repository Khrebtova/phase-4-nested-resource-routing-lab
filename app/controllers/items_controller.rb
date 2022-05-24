class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :item_not_found

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
    else
      item = Item.create(item_params)
    end
    render json: item, status: :created
  end  

  private

  def item_not_found
    render json: {error: "Item not found"}, status: 404
  end

  def item_params
    params.permit(:name, :description, :price)
  end
end
