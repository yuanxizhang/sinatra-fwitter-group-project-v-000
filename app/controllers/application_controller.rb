require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  set :views, proc { File.join(root, '../views/') }
 
  get '/' do
    erb :"application/index"
  end

end
