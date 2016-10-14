class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    # Display 'enter username' form.
    @twitter_user = TwitterUser.new

    #render html: "Enter Twitter Username"
  end

  def get_followers

    @TwitterUserName = params[:twitter_user][:UserName]

    if @TwitterUserName.blank?
      render html: "Username not supplied"
      return
    end

    render html: @TwitterUserName

  end

end
