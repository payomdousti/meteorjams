
if Meteor.isClient
  # make Jams object accessible from the browser console (for debugging)
  window.Jams = share.Jams
  window.Users = share.Users

  Template.sidebar.jams = ->
    Jams.find {},
      sort: [['created_at', 'desc']]

  Template.sidebar.events
    'click .jam': ->
      console.log "Clicked on #{this.name}"
      Player.spawnAndPlay(this)

  Template.userlist.users = ->
    Users.find {},
      sort: [['last_seen', 'desc']]

  Template.user.now_playing = ->
    Jams.findOne(this.now_playing) || name: 'idle'

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
        Users.initUser()
        Jams.fetchJams()

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

