class ProductsController < ApplicationController
  skip_before_action :protect_pages, only: [:index, :show]

  def index
    @categories = Category.all.order(name: :asc).load_async

    @pagy, @products = pagy_countless(FindProducts.new.call(products_filter_params).load_async, items: 12)
  end

  def show
    product
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: t('.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    product
  end

  def update
    product

    if @product.update(product_params)
      redirect_to products_path, notice: t('.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    product

    @product.destroy

    redirect_to products_path, status: :see_other , notice: t('.destroyed')
  end

  private
  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id)
  end

  def products_filter_params
    params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page)
  end

  def product
    @product = Product.find_by(id: params[:id])
  end
end