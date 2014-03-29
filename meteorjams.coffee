Jams = new Meteor.Collection("jams")

if Meteor.isClient
  Template.sidebar.jams = ->
    Jams.find {},
      sort:
        created_at: -1

  Template.sidebar.events
    'click .post': ->
      null

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup

