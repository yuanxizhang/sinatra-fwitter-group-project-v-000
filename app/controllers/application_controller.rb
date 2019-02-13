require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  set :views, proc { File.join(root, '../views/') }
 
  get '/' do
    erb :index
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def login(user_id)
      session[:user_id] = user_id
    end

		def logout
      session.clear
    end

  end

end
