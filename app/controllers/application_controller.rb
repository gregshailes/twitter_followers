class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index

    # View will display 'enter username' form; which needs a blank twitter user
    @twitter_user = User.new

  end

  def get_followers

    userName = params[:user][:name]

    # Check we've got a username
    if userName.blank?
      render html: "Username not supplied"
      return
    end

    puts userName

    # Stip the '@' off, if it's been entered - we don't need it
    if userName.slice(0, 1) == "@"
      userName = userName.slice(1, userName.length - 1)
    end

    puts userName

    user = User.find_by(name:userName)

    if user == nil
      user = User.new(name:userName)
      user.save
      puts "Not found - created new user"
    else
      puts "Found existing user"
    end

    puts user.id

    # Get the  followers of this user from Twitter
    twitFollowers = $twitter.followers(userName)

    # Remove relationships that no longer exist in Twitter
    dbUserFollowers = UserFollower.where(user_id:user.id)

    if dbUserFollowers != nil

      puts "dbUserFollowers.count: " + dbUserFollowers.count.to_s

      dbUserFollowers.each do |uf|

        # Get the follower's name
        dbFollower = Follower.find_by(id:uf.follower_id)

        puts "Checking if " + dbFollower.name + " is still in Twitter's list"

        # Does this follower still exist in Twitter?
        if twitFollowers.select{|r| r.name == dbFollower.name }.count == 0
          puts "Removing " + uf.id.to_s
          uf.destroy
        end

      end

    end

    # Insert/update new Twitter followers into the DB
    if twitFollowers != nil

      twitFollowers.each do |f|

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

#    # Quick and dirty HTML render, until we create a view for the results.
#    @ToRender = "Followers for " + @TwitterUserName + "\n"
#    @Followers.each.take(10) do |follower|
#      puts follower.name
#      @ToRender = @ToRender + follower.name + "\n"
#    end

     render html: userName

  end

end
