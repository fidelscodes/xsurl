require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :'index'
  end

  # GET a link and REDIRECT to original url
  get '/:random_hex_string' do
    @link = Link.find_by(random_hex_string: params[:random_hex_string])
    if @link
      redirect to @link.url
    else
      # notify there is no such link
      redirect to '/'
    end
  end

  ## Helpers ##
  helpers do
   def current_user
     User.find_by(id: session["user_id"])
   end

   def logged_in?
     !!session["user_id"]
   end
 end

end
