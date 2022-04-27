# Create Top Level Categories
bg_and_ui = Category.where(name: 'Backgrounds & UI', asset_depth: 2).first_or_create

battle_anims = Category.where(name: 'Battle Animations', asset_depth: 2).first_or_create


item_icons = Category.where(name: 'Item Icons').first_or_create


item_icons = Category.where(name: 'Maps').first_or_create


portraits = Category.where(name: 'Portraits').first_or_create

spells_n_skills = Category.where(name: 'Spells & Skills', asset_depth: 2).first_or_create

tilesets = Category.where(name: 'Tilesets').first_or_create
