class Image < ActiveRecord::Base
  def img=(input_data)
    self.filename = input_data.original_filename
    self.filetype = input_data.content_type.chomp
    self.img = input_data.read
  end

end
