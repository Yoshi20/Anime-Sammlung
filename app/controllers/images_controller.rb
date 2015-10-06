class ImagesController < ApplicationController
  def display_img
    @img = Image.find(params[:id])
    send_data(@img.img, :type => @img.filetype, :filename => @img.filename,
              :disposition => 'inline')
  end

end
