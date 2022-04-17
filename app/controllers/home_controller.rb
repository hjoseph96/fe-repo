class HomeController < ApplicationController
  def index
    @categories = Category.where(ancestry: nil).order(:name)

    @assets = []

    @categories.each do |c|
      @assets << Asset.where(category_id: c.id).sample
    end

    if params[:category_id].present?
      @current_category = Category.find(params[:category_id])

      return if @current_category.nil?

      @assets = Asset.where(category_id: @current_category.id).sort
    end
  end
end
