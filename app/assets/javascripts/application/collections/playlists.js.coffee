class OngakuRyoho.Classes.Collections.Playlists extends Backbone.Collection

  model: OngakuRyoho.Classes.Models.Playlist,
  url: "/api/playlists/",


  get_user_playlists: () ->
    this.filter (playlist) -> not playlist.get("special")


  get_special_playlists: () ->
    this.filter (playlist) -> playlist.get("special")


  fetch: (options={}) ->
    options.reset = true

    # get source ids
    source_ids = OngakuRyoho.SourceManager.collection.where({ available: true, activated: true })
    source_ids = _.map(source_ids, (s) -> s.id)
    source_ids = source_ids.join(",")

    # check options
    options.data ?= {}

    # source_ids
    _.extend(options.data, { source_ids: source_ids })

    # super
    Backbone.Collection.prototype.fetch.call(this, options)
