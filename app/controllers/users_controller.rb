class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/users/:id"
    else
      erb :'/users/new'
    end
  end

  # CREATE a new user
  post '/signup' do
    params_has_empty_value = params.values.any? {|val| val.blank?}

    if params_has_empty_value
      redirect "/signup"
    end

    @user = User.create(params)
    # @user.save
    session[:user_id] = @user.id
    flash[:notice] = "Welcome to your dashboard, #{current_user.username}!"
    redirect "/users/#{current_user.id}"
  end

  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Welcome back, #{@user.username}"
      redirect "/users/#{current_user.id}"
    else
      flash[:notice] = "Oops... Try again, or Signup first."
      redirect '/login'
    end
  end

  # DISPLAY a user page / USERS/SHOW
  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    if logged_in? # && @user.id == params[:id]
      erb :"/users/show" # this cannot be a redirect!
    else
      flash[:notice] = "Oops... Try that again, please."
      redirect '/login'
    end
  end

  # CREATE a new link
  post '/links/new' do
    @link = Link.create(params)
    # url_field_empty = params[:url].blank?
    @link.create_short_url # no need to save, this method saves the instance
    current_user.links << @link
    flash[:notice] = "Successfully created a new link!"
    redirect "/users/#{current_user.id}"
  end

  # EDIT a link
  get '/links/:id/edit' do
    @link = Link.find_by(id: params[:id])
    if logged_in? && current_user.links.include?(@link)
      erb :'/links/edit'
    else
      redirect '/login'
    end
  end

  patch '/links/:id/edit' do
    @link = Link.find_by(id: params[:id])
    @link.update(url: params[:url])
    if !params[:site_name].blank?
      @link.update(site_name: params[:site_name])
    end
    flash[:notice] = "Successfully updated link."
    redirect "/users/#{current_user.id}"
  end

  # DELETE a link
  delete '/links/:id/delete' do
    if logged_in?
      @link = Link.find_by(id: params[:id])
      @link.destroy
      flash[:notice] = "Successfully deleted link."
      redirect "/users/#{current_user.id}"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:notice] = "Bye, bye, bye..."
      redirect '/'
    else
      redirect '/'
    end
  end

end
