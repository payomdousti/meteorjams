Jams = new Meteor.Collection("jams")

if Meteor.isClient
  # make Jams object accessible from the browser console (for debugging)
  window.Jams = Jams

  Template.sidebar.jams = ->
    Jams.find {},
      sort: [['created_at', 'desc']]

  Template.sidebar.events
    'click .jam': ->
      console.log "Clicked on #{this.name}"
      source = if this.source.match /player.soundcloud.com/ then this.link else this.source
      console.log "Attemping to play #{source}"
      Player.spawnAndPlay(source)

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

