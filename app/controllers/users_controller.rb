class UsersController < ApplicationController
		enable :sessions
  
  	register Sinatra::ActiveRecordExtension
  	set :session_secret, "my_application_secret"
  	set :views, Proc.new { File.join(root, "../views/") }


		get '/signup' do 
			erb :create_user
		end

		post "/signup" do
  			user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
 
  			if user.save
    				redirect "/login"
  			else
    				redirect "/failure"
  			end
		end

		get '/login' do 
				erb :login
		end

		post "/login" do
			  user = User.find_by(:username => params[:username])
 
			  if user && user.authenticate(params[:password])
			    session[:user_id] = user.id
			    redirect "/success"
			  else
			    redirect "/failure"
			  end
		end

end
