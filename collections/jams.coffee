Jams = share.Jams = new Meteor.Collection("jams")

_.extend Jams,
  fetchJams: ->
    FB.api "/232990736786590/feed", limit: 50, (response) ->
      if response.data
        response.data.forEach (post) ->
          # don't insert duplicates
          unless Jams.findOne(id: post.id)
            # only support Facebook and Youtube for now
            if post.source and post.source.match /youtube.com|soundcloud.com/
              Jams.insert(post)

        console.log "Got #{Jams.find().count()} jams"
      else
        console.log "Error reading from Facebook API"

  dedupe: ->
    Jams.find().forEach (jam) ->
      while Jams.find(id: jam.id).count() > 1
        Jams.remove(Jams.findOne(id: jam.id)._id)

  fetchComments: (jam, callback) ->
    if 'id' of jam
      FB.api "/#{jam.id}/comments", (response) ->
        if response.data
          callback.call response, response.data
