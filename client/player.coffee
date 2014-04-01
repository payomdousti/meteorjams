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
    console.log "Attemping to play #{jam.source}"
    @player = $('<iframe>').attr(
      frameborder: 'no'
      scrolling: 'no'
      width: '100%'
      height: '400'
      src: jam.source
    ).appendTo($(@element))
    @now_playing(jam)

  play: ->
    @player.play()

  now_playing: (jam_or_string) ->
    Users.updateNowPlaying(@current_user, jam_or_string)

