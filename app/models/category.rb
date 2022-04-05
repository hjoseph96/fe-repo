class Category < ApplicationRecord
  belongs_to :parent, foreign_key: :parent_id, class_name: 'Category', optional: true
end
