Jams = share.Jams = new Meteor.Collection("jams")

Jams.fetchJams = ->
  FB.api '/232990736786590/feed', (response) ->
    if response.data
      response.data.forEach (post) ->
        # only support Facebook and Youtube for now
        if post.source and post.source.match /youtube.com|soundcloud.com/
          # don't insert duplicates
          Jams.insert(post) unless Jams.findOne(id: post.id)

      console.log "Got #{Jams.find().count()} jams"
    else
      console.log "Error reading from Facebook API"
