Jams = new Meteor.Collection("jams")
Users = new Meteor.Collection("users")

if Meteor.isClient
  # make Jams object accessible from the browser console (for debugging)
  window.Jams = Jams
  window.Users = Users

  Template.sidebar.jams = ->
    Jams.find {},
      sort: [['created_at', 'desc']]

  Template.sidebar.events
    'click .jam': ->
      console.log "Clicked on #{this.name}"
      source = if this.source.match /player.soundcloud.com/ then this.link else this.source
      console.log "Attemping to play #{source}"
      Player.spawnAndPlay(source)

  Template.userlist.users = ->
    Users.find {}

  fetchJams = ->
    FB.api '/232990736786590/feed', (response) ->
      if response.data
        response.data.forEach (post) ->
          # only support Facebook and Youtube for now
          if post.source and post.source.match /youtube.com|soundcloud.com/
            # don't insert duplicates
            Jams.insert(post) unless Jams.findOne(id: post.id)

        console.log "Got #{Jams.find().count()} jams"
      else
        console.log "Error reading from Facebook API"

  initUser = ->
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

  window.fbAsyncInit = ->
    FB.init
      appId:  '1571904639700879' # App ID
      status: true # check login status
      xfbml:  true # parse XFBML

    # subscribe to changes in authentication status to get 
    # notified when user authenticates with Facebook
    FB.Event.subscribe 'auth.authResponseChange', (response) ->
      if response.status == 'connected'
        # user is logged in and has authorized the app
        accessToken = response.authResponse.accessToken
        console.log "Got FB access token"
        initUser()
        fetchJams()

      else if response.status == 'not_authorized'
        # the user is logged in to Facebook, 
        # but has not authenticated the app
        console.log "not authorized"

      else
        # the user isn't logged in to Facebook.
        console.log "not logged in"

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup

