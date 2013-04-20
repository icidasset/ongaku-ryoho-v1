class OngakuRyoho.Classes.Models.Playlist extends Backbone.Model

  urlRoot:
    "/data/playlists/"

  defaults:
    name: ""
    tracks: []
    special: false


  tracks_attributes: ->
    _.map(@tracks, (track_id) ->
      track_id: track_id
    )


  toJSON: ->
    json = { playlist: _.clone(@attributes) }
    _.extend(json.playlist, { tracks_attributes: @tracks_attributes() })


  validate: (attrs, options) ->
    unique_name = true

    # check name length
    unless attrs.name.length > 1
      return "The name for your playlist should be at least two characters long"

    # check if name is unique
    unique_name = !_.any(_.map(OngakuRyoho.RecordBox.Playlists.collection.models, (playlist) ->
      return playlist.attributes.name.toLowerCase() is attrs.name.toLowerCase()
    ))

    unless unique_name
      return "A playlist with the same name already exists"
