class UsersController < ApplicationController
  get '/signup' do
    erb :'/users/new'
  end

  post '/signup' do
    @user = User.create(params)
    session[:user_id] = @user.id
    erb :"/users/#{@user.id}/show" # make it redirect to /users/show
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(params[:username])
    session[:user_id] = @user.id
    erb :"/users/#{@user.id}/show"
  end
end
