Jams = new Meteor.Collection("jams")

if Meteor.isClient
  Template.sidebar.jams = ->
    Jams.find {},
      sort:
        created_at: -1

  Template.sidebar.events
    'click .post': ->
      null

  fetchJams = (token) ->
    FB.api '/232990736786590/', 'get', { access_token: token }, (response) ->
      Jams.insert(response.data)

  window.fbAsyncInit = ->
    FB.init
      appId:  '1571904639700879' # App ID
      status: true # check login status
      xfbml:  true # parse XFBML

    fetchJams('CAACEdEose0cBAGUsXRr7JhtNy9OZBh25FP7YzJtJByFeEevZCdxiOOXZCsEV69ZBiZA4nZAWw3mP2j2kzn4jZA29ZC7TkfDbUYnp254fcN9gUSMBvsUiQQeFpEmRD08wMUTCQWs0JC1aT4BK9pNLpwWWcWNzHvlAgtnsHNJjGTmCmeih2yyb6vQuD9Lo1ZBtkFerYiiIQZBM1wKAZDZD')
    #FB.getLoginStatus (response) ->
    FB.Event.subscribe 'auth.authResponseChange', (response) ->
      if response.status == 'connected'
        # user is logged in and has authorized the app
        accessToken = response.authResponse.accessToken
        fetchJams(accessToken)

      else if response.status == 'not_authorized'
        # the user is logged in to Facebook, 
        # but has not authenticated the app
        console.log('not authorized')
      else
        # the user isn't logged in to Facebook.
        console.log('not logged in')

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup

