class Player.SoundCloud
  defaults:
    host: 'w.soundcloud.com'
    path: 'player/'
    settings:
      visual: true
      auto_play: true
      show_artwork: true

  constructor: (jam) ->
    @source = @_make_source(jam)

  _make_source: (jam) ->
    throw "Invalid source" unless jam.source.match /soundcloud.com/
    # parse source URL
    url = URI(jam.source)
    # extract track URL
    query = _.extend(url: url.query(true).url, @defaults.settings)
    source = url.host(@defaults.host)
                .path(@defaults.path)
                .query(query)

