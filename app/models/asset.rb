class Asset < ApplicationRecord
  belongs_to :category
  belongs_to :author
  has_many_attached :files

  has_many :asset_collections
  has_many :collections, trhough: :asset_collections

  acts_as_votable
  acts_as_taggable_on :tags
end
