class AssetsController < ApplicationController
  def show
    @asset = Asset.find(params[:id])

    gif_only_categories = Category.where(name: ["Battle Animations", "Spells & Skills"])

    @gif_only = false;
    if gif_only_categories.any? {|c| @asset.category.descendant_of?(c) }
      @gif_only = true
    end
  end

  def download
    @asset = Asset.all.sample

    zipname = "#{@asset.title}.zip"
    temp_file = Tempfile.new(zipname)

    Zip::OutputStream.open(temp_file) { |zos| }

    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|

      @asset.files.each do |f|
        file = File.open(ActiveStorage::Blob.service.send(:path_for, f.blob.key))

        filename = "#{f.blob.filename}.#{MimeMagic.by_magic(file).subtype}"
        tempfile = Tempfile.new(filename)
        File.open(tempfile.path, 'w', encoding: 'ASCII-8BIT') do |file|
          f.download do |chunk|
            tempfile.write(chunk)
          end
        end

        zip.add("#{filename}.png", tempfile.path)
      end
    end

    zip_data = File.read(temp_file.path)
    send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: zipname)
    # begin
    # ensure # important steps below
    #   temp_file.close
    #   temp_file.unlink
    # end
  end
end
