class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index

    # View will display 'enter username' form; which needs a blank twitter user
    @twitter_user = TwitterUser.new

  end

  def get_followers

    @TwitterUserName = params[:twitter_user][:UserName]

    # Check we've got a username
    if @TwitterUserName.blank?
      render html: "Username not supplied"
      return
    end

    # Stip the '@' off, if it's been entered - we don't need it
    if @TwitterUserName.

    # Search for followers of this user
    @Followers = $twitter.followers("greg_shailes")

    # Quick and dirty HTML render, until we create a view for the results.
    @ToRender = ""
    @Followers.each do |follower|
      @ToRender = @ToRender + follower.name + "<br>"
    end
    render html: @ToRender

  end

end
