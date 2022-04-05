class Collection < ApplicationRecord
  belongs_to :user

  has_many :asset_collections
  has_many :assets, thorugh: :asset_collections
end
