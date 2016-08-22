class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect to "/users/:id"
    else
      erb :'/users/new'
    end
  end

  # Create a new user
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

  # Display a user page
  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    if logged_in?
      erb :"/users/show" # this cannot be a redirect!
    else
      redirect to '/login'
    end
  end

  # Create a new link
  post '/links/new' do
    @link = Link.create(params)
    url_field_empty = params[:url].blank?
    @link.create_short_url # no need to save, this method saves the instance
    current_user.links << @link

    redirect to "/users/#{current_user.id}"
  end

  # TODO:
    # ability to edit a link
  get '/links/:id/edit' do
    erb :'/links/edit'
  end

  patch '/links/:id/edit' do
    @link = Link.find_by(id: params[:id])
  end
    # ability to delete a link
    # ability to visit link - make sure the url looks like localhost/ueyuerW
      # there's a get action for /:random_hex_string

end
