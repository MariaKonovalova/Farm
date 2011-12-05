class PictureController < ApplicationController
  def download
    begin
      send_file "#{Rails.root}/data/plants/" + params[:url], :type => 'image/png'
    rescue
    end
  end
end
