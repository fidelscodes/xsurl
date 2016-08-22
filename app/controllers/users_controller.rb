class UsersController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect to "/users/:id"
    else
      erb :'/users/new'
    end
  end

  post '/signup' do
    params_has_empty_value = params.values.any? {|val| val.blank?}
    if params_has_empty_value
      redirect to "/signup"
    end

    @user = User.create(params)
    session[:user_id] = @user.id
    redirect to "/users/#{current_user.id}"
  end

  get '/login' do
    if logged_in?
      redirect to "/users/#{current_user.id}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user
      session[:user_id] = @user.id
      redirect to "/users/#{@user.id}"
    else
      flash[:notice] = "Oops! Try again"
      redirect to '/login'
    end
  end

  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    if logged_in?
      erb :'/users/show'
    else
      redirect to '/login'
    end
  end

  post '/links/new' do
    @link = Link.create(params)
    url_field_empty = params[:url].blank?

    # binding.pry
    redirect to '/users/:id'
  end

end
