# app/models/product.rb
class Product < ApplicationRecord
  validates :product_name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true
  validates :description, presence: true
  validates :image, presence: true
end
