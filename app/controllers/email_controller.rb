class EmailController < ApplicationController
  # Action for handling sharing via email
  post '/email' do
    Pony.mail ({
                :to => params[:send_to],
                # :from => params[:send_from],
                :subject => params[:subject],
                :body => "#{params[:link]}\n\n#{params[:email_body]}",
                :via => :smtp,
                :via_options => {
                  :address              => 'smtp.gmail.com',
                  :port                 => '587',
                  :enable_starttls_auto => true,
                  :user_name            => 'gmail-username',
                  :password             => 'gmail-password-here',
                  :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                  :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
                }
              })
    redirect '/'
  end
end
