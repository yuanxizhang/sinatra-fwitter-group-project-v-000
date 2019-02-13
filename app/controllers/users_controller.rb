require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController
		enable :sessions
    use Rack::Flash
  	register Sinatra::ActiveRecordExtension
  	set :session_secret, "my_application_secret"
  	set :views, Proc.new { File.join(root, "../views/") }


		get '/signup' do
	    if logged_in?
	      redirect to '/tweets'
	    else
	      erb :'/users/create_user'
	    end
	  end
	 
	  post '/signup' do 
	    @user = User.new(params)
	    if @user.save
					session[:user_id] = @user.id				
					login(@user.id)
	        redirect to '/tweets'
	    else
	        redirect to '/signup'
	    end
	  end
	 
	  get '/login' do
			if logged_in?
	      redirect to '/tweets'
	    else
	      erb :'users/login'  
	    end
	  end

		post "/login" do
	    @user = User.find_by(username: params[:username])
	    if @user && @user.authenticate(params[:password])
	      session[:user_id] = @user.id
	      redirect to '/tweets'
	    else
	      erb :'users/login'
	    end
	  end
	 
	  get '/logout' do
	    if logged_in?
	      session.clear
	      redirect to '/login'
	    else
	    	redirect to '/'
	    end
	  end
	 
	  get '/users/:slug' do
	    @user = User.find_by_slug(params[:slug])
	    erb :'/users/show'
	  end
	  

end
