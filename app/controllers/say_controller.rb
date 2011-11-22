class SayController < ApplicationController
  # To change this template use File | Settings | File Templates.
  def hello
    @time = Time.now
    @files = Dir.glob('*')
  end

  def goodbye
  end

  #def show
    #render :text => 'Hello Mary.'
 # end
end