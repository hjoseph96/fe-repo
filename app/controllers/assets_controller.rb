class AssetsController < ApplicationController
  include ActiveStorage::SendZip

  def show
    @asset = Asset.find(params[:id])

    gif_only_categories = Category.where(name: ["Battle Animations", "Spells & Skills"])

    @gif_only = false;
    if gif_only_categories.any? {|c| @asset.category.descendant_of?(c) }
      @gif_only = true
    end
  end

  def download
    @asset = Asset.find(params[:id])

    send_zip @asset.files, filename: "#{@asset.title}.zip"
  end

end
