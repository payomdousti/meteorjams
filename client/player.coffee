window.Player =
  element: "#player"

  spawnAndPlay: (jam) ->
    # Kill the current player
    @kill()

    # Create a new media player node with the new song
    @spawn(jam)

    @player.on('loadstart', => @now_playing('buffering'))
    @player.on('playing', => @now_playing(jam))
    @player.on('pause',   => @now_playing('paused'))
    @player.on('ended',   => @now_playing(null))

    # Play the song when ready
    @player.on('canplaythrough', => @play)

  kill: ->
    $(@element).children().first().remove()
    @now_playing(null)

  spawn: (jam) ->
    source = if jam.source.match /player.soundcloud.com/ then jam.link else jam.source
    console.log "Attemping to play #{source}"
    @player = Popcorn.smart(@element, source)
    @now_playing(jam)

  play: ->
    @player.play()

  now_playing: (jam_or_string) ->
    Users.updateNowPlaying(@current_user, jam_or_string)
