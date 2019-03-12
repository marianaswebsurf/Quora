class ApplicationController < Sinatra::Base
  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  get '/' do
    erb :index
  end
end
