class AssetCollection < ApplicationRecord
  belongs_to :asset
  belongs_to :collection
end
