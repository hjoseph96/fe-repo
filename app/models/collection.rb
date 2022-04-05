class Collection < ApplicationRecord
  belongs_to :user

  has_many :asset_collections
  has_many :assets, through: :asset_collections
end
