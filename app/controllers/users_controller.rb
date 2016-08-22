class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect to "/users/:id"
    else
      erb :'/users/new'
    end
  end

  # CREATE a new user
  post '/signup' do
    params_has_empty_value = params.values.any? {|val| val.blank?}
    if params_has_empty_value
      redirect to "/signup"
    end

    @user = User.find_or_create_by(params)
    session[:user_id] = @user.id
    flash[:notice] = "Welcome to your dashboard, "
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

  # DISPLAY a user page / USERS/SHOW
  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    if logged_in?
      erb :"/users/show" # this cannot be a redirect!
    else
      redirect to '/login'
    end
  end

  # CREATE a new link
  post '/links/new' do
    @link = Link.create(params)
    url_field_empty = params[:url].blank?
    @link.create_short_url # no need to save, this method saves the instance
    current_user.links << @link

    # flash[:notice] = "Successfully created a new xsURL!"
    redirect to "/users/#{current_user.id}"
  end

  # EDIT a link
  get '/links/:id/edit' do
    @link = Link.find_by(id: params[:id])
    if logged_in?
      erb :'/links/edit'
    else
      redirect to '/login'
    end
  end

  patch '/links/:id/edit' do
    @link = Link.find_by(id: params[:id])
    redirect to "/users/#{current_user.id}"
  end

  # DELETE a link
  delete '/links/:id/delete' do
    @link = Link.find_by(id: params[:id])
    @link.destroy
    redirect to "/users/#{current_user.id}"
  end

  get '/logout' do
    flash[:notice] = "You've successfully logged out."
    redirect to '/'
    session.clear
  end

end
