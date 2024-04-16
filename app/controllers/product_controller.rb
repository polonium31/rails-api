class ProductController < ApplicationController
  def show
    products = Product.all
    render json: products
  end

  def detail
    product = Product.find_by(id: params[:id])
    if product
      render json: product
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def add_product
    product = Product.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:product_name, :price, :category, :description, :image)
  end
end