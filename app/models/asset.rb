class Asset < ApplicationRecord
  belongs_to :category
  belongs_to :author, optional: true
  has_many_attached :files

  has_many :asset_collections
  has_many :collections, through: :asset_collections

  acts_as_votable
  acts_as_taggable_on :tags

  def preview_image
    file = self.files.find {|f| f.blob.content_type == 'image/gif' }
    return file unless file.nil?

    normal_imgs = %w(image/png image/jpg image/jpg)
    self.files.find {|f| normal_imgs.include? f.blob.content_type  }
  end
end
