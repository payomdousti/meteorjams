
if Meteor.isClient
  # make Jams object accessible from the browser console (for debugging)
  window.Jams = share.Jams
  window.Users = share.Users

  #
  # Dependencies
  #

  last_seen = new Deps.Dependency
  now_playing = new Deps.Dependency
  last_seen_interval = null

  # 
  # Hooking up templates
  #

  Template.sidebar.jams = ->
    Jams.find {},
      sort: [['created_at', 'desc']]

  Template.sidebar.events
    'click .jam': ->
      console.log "Clicked on #{this.name}"
      Player.spawnAndPlay(this)
      now_playing.changed()

  Template.jam.is_playing = ->
    now_playing.depend()
    'playing' if Player.current_user and
      Player.current_user.now_playing == this._id

  Template.jam.source_icon = ->
    match = this.source.match /youtube|soundcloud/
    match[0] + '.png' if match

  Template.jam.rendered = ->
    $('.jam').popover
      title:   -> $($(this).data('title'),   this).html()
      content: -> $($(this).data('content'), this).html()
      html: true

  Template.user.last_seen = ->
    last_seen.depend()
    moment(this.last_seen).fromNow()

  Template.user.now_playing = ->
    Jams.findOne(this.now_playing) || name: 'idle'

  Template.userlist.created = ->
    # refresh every minute
    last_seen_interval = Meteor.setInterval((-> last_seen.changed()), 60*1000)

  Template.userlist.destroyed = ->
    Meteor.clearInterval(last_seen_interval)

  Template.userlist.users = ->
    last_seen.depend()
    Users.find {last_seen: $gt: Date.now() - 5*60*1000},
      sort: [['last_seen', 'desc']]

  #
  # FB API setup
  #

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

