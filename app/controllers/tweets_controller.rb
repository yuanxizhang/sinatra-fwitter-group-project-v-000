require './config/environment'
require 'rack-flash'

class TweetsController < ApplicationController
	enable :sessions
	use Rack::Flash
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/tweets' do
    if logged_in?
    	@user = User.find_by_id(session[:user_id])
      erb :"/tweets/tweets"
    else
    	redirect to "/login"
    end   
  end

  # Create Tweet
  get '/tweets/new' do
  	if logged_in?
  		erb :"/tweets/new"
  	else
      redirect to '/login'
    end
  end

  post '/tweets' do
  	if params["content"].empty?
      flash[:message] = "Please enter content for your tweet"
      redirect to '/tweets/new'
    end
    @tweet = current_user.tweets.create(:content => params[:content])
     redirect to "/tweets"
  end

  # Show Tweet
  get '/tweets/:id' do
    if logged_in?
    	@tweet = Tweet.find_by_id(params[:id])
    	erb :'/tweets/show_tweet'
    else
      redirect to '/login'
    end   
  end

  # Edit Tweet
  get '/tweets/:id/edit' do
  	if logged_in?
  		@tweet = Tweet.find_by_id(params[:id])
  		if @tweet.user.username == current_user.username
  				erb :"/tweets/edit_tweet"
  		else
  			flash[:message] = "You can only edit your own tweets!"
  			flash[:message] = "Only #{@tweet.user.username} can update this tweet."

  			erb :'/tweets/tweets'
  		end
  	else
      redirect to '/login'
    end 
  end

  patch '/tweets/:id' do 
    if params["content"].empty?
      flash[:message] = "Please enter content for your tweet!"
      redirect to "/tweets/#{params[:id]}/edit"
    end

    tweet = Tweet.find(params[:id])
    if tweet.user == current_user
      redirect to (tweet.update(content: params[:content]) ? "/tweets/#{tweet.id}" : "/tweets/#{tweet.id}/edit")
    else
      redirect to '/tweets'
    end
  end

  post '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if current_user.id != @tweet.user_id
      flash[:message] = "Sorry you can only delete your own tweets"
      redirect to '/tweets'
    end
    @tweet.delete if @tweet.user == current_user
    redirect to '/tweets'
  end


end
