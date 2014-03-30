Users = share.Users = new Meteor.Collection("users")

Users.initUser = ->
  FB.api '/me', (response) ->
    if response
      user = Users.findOne(id: response.id)
      unless user
        # filter what we store
        user = _.pick(response, 'id', 'name', 'link')
        user._id = Users.insert(user)

      # update login timestamp
      Users.update(user._id, $set: last_seen: Date.now())
      # fetch the user's picture
      updateProfilePic(user)
    else
      console.log "Error fetching user info"

  updateProfilePic = (user) ->
    FB.api '/me/picture', (response) ->
      if response.data
        Users.update(user._id, $set: picture: response.data.url)
        console.log "Profile pic updated"
