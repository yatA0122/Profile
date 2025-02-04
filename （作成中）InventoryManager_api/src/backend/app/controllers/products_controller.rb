class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy update_stock]
  #protect_from_forgery with: :null_session # 本番では無効化

  def index
    products = Product.all
    logger.info products.to_json
    render json: products
  end

  def show
    render json: @product
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: { message: "Product created successfully", product: product }, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      Rails.logger.error "Failed to create product. Workplace ID: #{params[:workplace_id]}"
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  def update_stock
    new_stock = @product.stock + params[:quantity].to_i

    if new_stock >= 0
      @product.update(stock: new_stock)
      render json: { message: 'Stock updated', product: @product }, status: :ok
    else
      render json: { error: 'Insufficient stock' }, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :product_code, :jan_code, :stock_quantity, :standard_stock_quantity, :order_location, :image_url, :workplace_id, :price)
  end
end