window.Player =
  element: "#player"

  spawnAndPlay: (source) ->
    # Kill the current player
    @kill()

    # Create a new media player node with the new song
    @spawn(source)

    # Play the song when ready
    @player.on('canplaythrough', @play)

    # Queue up the next song
    @player.on('ended', () -> spawnAndPlay(song_index + 1))

  kill: ->
    $(@element).children().first().remove()

  spawn: (source) ->
    @player = Popcorn.smart(@element, source)

  play: ->
    @player.play()
