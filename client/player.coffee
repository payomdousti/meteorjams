window.Player =
  element: "#player"

  spawnAndPlay: (jam) ->
    # Kill the current player
    @kill()

    # Create a new media player node with the new song
    @spawn(jam)

    # Play the song when ready
    @player.on('canplaythrough', => @play)

    # Queue up the next song
    @player.on('ended', => spawnAndPlay(song_index + 1))

  kill: ->
    $(@element).children().first().remove()
    Users.updateNowPlaying(@current_user, null)

  spawn: (jam) ->
    source = if jam.source.match /player.soundcloud.com/ then jam.link else jam.source
    console.log "Attemping to play #{source}"
    @player = Popcorn.smart(@element, source)
    Users.updateNowPlaying(@current_user, jam)

  play: ->
    @player.play()
