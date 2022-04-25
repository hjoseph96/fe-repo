class Category < ApplicationRecord
  has_ancestry

  def self.top_level_categories
    where(ancestry: nil)
  end
  
  def top_level_category
    return self if ancestry.nil?

    ancestors.find_by(ancestry: nil)
  end

  def assets
    category_ids = [self.id] + self.descendant_ids
    Asset.where(category_id: category_ids)
  end
end
