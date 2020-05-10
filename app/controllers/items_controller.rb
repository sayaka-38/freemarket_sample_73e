class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:buy]
  before_action :set_item, only: [:show, :edit, :update, :buy, :destroy]
  before_action :set_parent, only: [:new, :create,:edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.on_sell.includes([:images]).order(created_at: :desc)
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @user = User.find_by(id: @item.seller_id)
    @category = Category.find_by(id: @item.category_id)
    @brand = Brand.find_by(id: @item.brand_id)
  end

  # GET /items/new
  def new
    @item = Item.new
    @item.images.build
    @item.build_brand
  end

  #format json
  def get_delivery_method
  end

  def set_parents
  end

  def set_children
    @children = Category.where(ancestry: params[:parent_id])
  end

  def set_grandchildren
    @grandchildren = Category.where(ancestry: params[:ancestry])
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])

  end

  def buy
    @address = Address.find(current_user.id)
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    if @item.save
      # redirect_to root_path, notice: 'Event was successfully created.'
    else
      @item.images.build
      render :new
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    imageLength = @item.images.length
    deleteImage = 0

    for num in 0..9
      if params[:item][:images_attributes][num.to_s] != nil
        if params[:item][:images_attributes][num.to_s][:_destroy] == "1"
          deleteImage += 1
        end
      end
    end
    if @item.valid? && !@item.images.empty? && imageLength != deleteImage
      @item.update(item_params)
      redirect_to item_path
    else
      redirect_to edit_item_path(@item)
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy  if user_signed_in? && current_user.id == @item.seller_id
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_parent
      @parents = Category.where(ancestry: nil)
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :price, :text, :status, :size, :condition, :shipping_cost, :delivery_method, :delivery_area, :delivery_date, :category_id, brand_attributes: [:id, :name], images_attributes: [:url, :_destroy, :id]).merge(seller_id: current_user.id, status: 0)
    end
end