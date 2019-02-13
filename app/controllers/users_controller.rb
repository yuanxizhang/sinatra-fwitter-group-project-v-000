class UsersController < ApplicationController
		enable :sessions
  
  	register Sinatra::ActiveRecordExtension
  	set :session_secret, "my_application_secret"
  	set :views, Proc.new { File.join(root, "../views/") }


		get '/signup' do 
			erb :"users/create_user"
		end

		post "/signup" do
  			user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
 
  			if user.save
    				redirect "/users/show"
  			else
    				redirect "/users/signup"
  			end
		end

		get '/login' do 
				erb :"users/login"
		end

		post "/login" do
			  user = User.find_by(:username => params[:username])
 
			  if user && user.authenticate(params[:password])
			    session[:user_id] = user.id
			    redirect "/users/show"
			  else
			    redirect "/users/login"
			  end
		end

		get '/users/:slug' do
	    @user = User.find_by_slug(params[:slug])
	    erb :'/users/show'
	  end

	  get '/logout' do
	    if logged_in?
	      session.clear
	      
	      redirect to '/login'
	    else
	      redirect to '/'
	    end
  	end

end
