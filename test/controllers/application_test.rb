require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

     test "should_get_home" do
          get root_url
          assert_response :success
     end

     # CAUTION; these tests require certain Twitter users to be present...
     test "should_post_followers" do
          post "/application/get_followers", params: { user: { name: "greg_shailes" } }
          assert_response :success
     end

     test "no_access_to_twitter" do
          # Should cause 500 response, as Jo Shailes' profile is private.
          post "/application/get_followers", params: { user: { name: "jo_shailes" } }
          assert_response 500
     end

     test "blank_username" do
          # Should cause 500 response.
          post "/application/get_followers", params: { user: { name: "" } }
          assert_response 500
     end

     test "test_removal_of_followers" do

          gregUser = User.find_by(name:"greg_shailes")


          # Get the Twitter followers for greg_shailes
          post "/application/get_followers", params: { user: { name: "greg_shailes" } }
          followersBefore = UserFollower.select{|uf| uf.user_id == gregUser.id}

          # Now add a follower to the DB to greg_shailes, who doesn't exist in Twitter
          follower = Follower.new(screen_name: "boris_shailes", name:"Boris Shailes", location:"Vivarium", description:"Slithery, scaly serpentine idiot")
          follower.save

          # Add user/follower relationship - get greg_shailes ID as I'm not sure if the Fixtures will always give the same ID
          userFollower = UserFollower.new(user_id:gregUser.id, follower_id:follower.id)
          userFollower.save

          # Get the Twitter followers for greg_shailes
          post "/application/get_followers", params: { user: { name: "greg_shailes" } }

          # Check that the non-existent follower no longer exists.
          assert_nil UserFollower.find_by(user_id:gregUser.id, follower_id:follower.id)

          # Check that we still have the same followers
          followersAfter = UserFollower.select{|uf| uf.user_id == gregUser.id}

          # For a production app, would do a more robust check - but for now just check the count's the same.
          assert_equal followersBefore.count, followersAfter.count

     end

end