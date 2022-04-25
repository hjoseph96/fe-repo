require 'pry'
require 'git'
require 'pathname'
require 'fileutils'

class FireEmblemRepoService
  IGNORED_DIRS = [
    '.git', '.husky', 'repo-tools', 'ZZZ_FE13 (Awakening) Save Files +Spotpass',
    'ZZ_Backup and Archival ONLY', 'Z_Unsorted Content', 'Music Repository'
  ]

  IGNORED_SUBDIR_FILES = %w(.md .txt)

  FE_REPO_PATH = "#{Rails.root}/db/repos/FE-Repo"

  FE_REPO_GIT_URL = 'git@github.com:Klokinator/FE-Repo.git'

  CATEGORY_OVERRIDES = {
    'BGs, Interface Elements' => 'Backgrounds & UI',
    'Portrait Repository' => 'Portraits',
    'Spells n Skills' => 'Spells & Skills'
  }


  def self.create_repo_locally
      unless Dir.exist? FE_REPO_PATH
        target_dir = "#{Rails.root}/db/repos"

        g = Git.clone(FE_REPO_GIT_URL, 'FE-Repo', path: target_dir)
      end
  end


  def self.parse
    create_repo_locally

    new.parse
  end


  def parse
    Dir.chdir(FE_REPO_PATH)

    folders = Dir.glob('*').select {|f| File.directory? f} - IGNORED_DIRS

    folders.sort.each do |folder_name|
      top_level_category = get_top_level_category(folder_name)


      Dir.chdir("#{FE_REPO_PATH}/#{folder_name}")
      folders = Dir.glob('*').select {|f| File.directory? f} - IGNORED_DIRS

      parse_category(top_level_category)
    end
  end


  def parse_category(category)
    parent_path = "#{FE_REPO_PATH}#{get_category_path(category)}"
    Dir.chdir(parent_path)

    folders = Dir.glob('*').select {|f| File.directory? f} - IGNORED_DIRS

    puts "***** Parsing Category: #{category.name} *****"

    folders.each {|f| parse_subfolder(f, parent: category)}
  end

  def parse_subfolder(folder_name, parent:)
    puts "***** Parsing Folder: #{folder_name} for Category: #{parent.name} *****"


    parent_path = Pathname.new("#{FE_REPO_PATH}#{get_category_path(parent.top_level_category)}")
    child_path = Pathname.new("#{FE_REPO_PATH}#{get_category_path(parent)}/#{folder_name}")

    depth = child_path.relative_path_from(parent_path).to_s.split(File::SEPARATOR).length

    existing_category = Category.find_by(name: folder_name)

    if depth == parent.top_level_category.asset_depth && existing_category.nil?
      create_asset(name: folder_name, category: parent)
    else

      subcategory = Category.where(name: folder_name).first_or_create
      subcategory.parent = parent
      subcategory.save!

      Dir.chdir(child_path)

      folders = Dir.glob('*').select {|f| File.directory? f} - IGNORED_DIRS

      folders.each {|f| parse_subfolder(f, parent: subcategory) }
    end
  end


  def create_asset(name: , category:)

    path = "#{FE_REPO_PATH}#{get_category_path(category)}/#{name}"
    if category.name == name
      path = "#{FE_REPO_PATH}#{get_category_path(category)}"
    end

    Dir.chdir(path)

    records = Dir.glob("**/**/*").reject { |f| File.directory?(f) }


    @asset = Asset.where(title: name, category_id: category.id).first_or_initialize

    if (@asset.id.present?)
      puts "~~~!~~~ Asset: #{name} already exists! ~~~!~~~"
      return
    end

    records.each do |f|
      puts "========== ATTACHING FILE: #{f} =========="

      file = File.open("#{path}/#{f}")
      @asset.files.attach(io: file, filename: f)
    end

    @asset.save!

    puts "***** Created Asset: #{name} in Category: #{category.name} *****"
  end


  def get_category_path(category)
    category_name = category.name

    if CATEGORY_OVERRIDES.values.include? category.name
      category_name = CATEGORY_OVERRIDES.key(category.name)
    end


    path = "/#{category_name}"

    path.prepend(get_category_path(category.parent)) if category.parent.present?

    return path
  end


  def get_top_level_category(folder_name)
    category_name = folder_name

    if CATEGORY_OVERRIDES.keys.include? folder_name
      category_name = CATEGORY_OVERRIDES[folder_name]
    end

    top_level_category = Category.find_by(name: category_name)

    if top_level_category.nil?
      throw StandardError.new("[FE-REPO-SERVICE] unable to find Top Level Category named : #{category_name}")
    end

    return top_level_category
  end


  def friendly_filename(filename)
      filename.gsub(/[^\w\s_-]+/, '')
              .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
              .gsub(/\s+/, '_')
  end
end
