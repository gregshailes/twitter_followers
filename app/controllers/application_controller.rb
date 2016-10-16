class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index

    # Written By : GDS
    # Date       : 14/10/2016
    # Purpose    : Create a blank twitter user for the Index view.
    @twitter_user = User.new

  end


  def get_followers

    # Written By : GDS
    # Date       : 14/10/2016
    # Purpose    : Code for 'get_followers' action.

    @userName = params[:user][:name]

    # Check we've got a username
    if @userName.blank?
      @errorProc = "Verify userName present"
      @errorMsg = "Username not supplied"
      render :error
    end

    # Stip the '@' off, if it's been entered - we don't need it
    if @userName.slice(0, 1) == "@"
      @userName = @userName.slice(1, @userName.length - 1)
    end

    user = User.find_by(name:@userName)
    if user == nil
      user = User.new(name:@userName)
      user.save
    end

    begin
      # Get the followers of this user from Twitter
      @twitFollowers = $twitter.followers(@userName).take(100)


    rescue Exception => e
      @errorProc = "Connecting to twitter"
      @errorMsg = e.message
      render :error

    end

    # Remove relationships that no longer exist in Twitter
    dbUserFollowers = UserFollower.where(user_id:user.id)

    if dbUserFollowers != nil

      dbUserFollowers.each do |uf|

        # Get the follower's name
        dbFollower = Follower.find_by(id:uf.follower_id)

        # Does this follower still exist in Twitter?
        if @twitFollowers.select{|r| r.name == dbFollower.name }.count == 0
          uf.destroy
        end

      end

    end

    # Insert/update new Twitter followers into the DB
    if @twitFollowers != nil

      @twitFollowers.each do |f|

        dbFollower = Follower.find_by(name:f.name)
        if dbFollower == nil
          # We haven't got a record of this follower yet - create one
          dbFollower = Follower.new(name:f.name)
          dbFollower.save
        end

        # Create user/follower relationship, if it doesn't already exist
        userFollower = UserFollower.find_by(user_id:user.id, follower_id:dbFollower.id)
        if userFollower == nil
          userFollower = UserFollower.new(user_id:user.id, follower_id:dbFollower.id)
          userFollower.save
        end

      end

    end

  end

end
