Jams = new Meteor.Collection("jams")

if Meteor.isClient
  Template.sidebar.jams = ->
    Jams.find {},
      sort:
        created_at: -1

  Template.sidebar.events
    'click .post': ->
      null

  window.fbAsyncInit = ->
    FB.init
      appId      : '136929479838758' # App ID
      status     : true # check login status
      cookie     : true # enable cookies to allow the server to access the session
      xfbml      : true # parse XFBML

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup

