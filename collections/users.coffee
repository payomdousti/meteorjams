Users = share.Users = new Meteor.Collection("users")

_.extend Users,
  initUser: ->
    FB.api '/me', (response) ->
      if response
        user = Users.findOne(id: response.id)
        unless user
          # filter what we store
          user = _.pick(response, 'id', 'name', 'link')
          user._id = Users.insert(user)

        # update login timestamp & reset now playing
        Users.updateNowPlaying(user, null)
        # fetch the user's picture
        updateProfilePic(user)
        # save current user for updates
        Player.current_user = user if Meteor.isClient

      else
        console.log "Error fetching user info"

    updateProfilePic = (user) ->
      FB.api '/me/picture', (response) ->
        if response.data
          Users.update(user._id, $set: picture: response.data.url)
          console.log "Profile pic updated"

  dedupe: ->
    Users.find().forEach (user) ->
      while Users.find(id: user.id).count() > 1
        Users.remove(Users.findOne(id: user.id)._id)

  updateNowPlaying: (user, jam) ->
    if _.isObject(user)
      user.now_playing = _.result(jam, '_id') || jam
      Users.update(user._id,
        $set:
          now_playing: user.now_playing
          last_seen: Date.now())
