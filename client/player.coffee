window.Player =
  spawnAndPlay: (song_index) ->
    # Check for valid song index
    if song_index >= 0 && song_index < window.jams.models.length

      # Kill the current media player node
      killMediaPlayer()

      # Create a new media player node with the new song
      song = window.jams.models[song_index]
      spawnPlayer(song.attributes.source)

      # Play the song when ready
      window.player.on( 'canplaythrough', playMedia )

      # Queue up the next song
      window.player.on( 'ended', () -> spawnAndPlay( song_index + 1 ) )

    killMediaPlayer: ->
      $("#player").children().first().remove()

    spawnPlayer: (song_source) ->
      window.player = Popcorn.smart( "#player", song_source )

    playMedia: ->
      window.player.play()
