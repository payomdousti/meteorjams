class Player.YouTube
  defaults:
    settings:
      enablejsapi: true

  constructor: (jam) ->
    @source = @_make_source(jam)

  _make_source: (jam) ->
    throw "Invalid source" unless jam.source.match /youtube.com/
    # parse source URL
    url = URI(jam.source)
    # add setting to enable JS API access
    source = url.addQuery(@defaults.settings)

