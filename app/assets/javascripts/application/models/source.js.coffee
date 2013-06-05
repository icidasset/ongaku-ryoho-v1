class OngakuRyoho.Classes.Models.Source extends Backbone.Model

  poll_for_busy_state: () =>
    promise = new RSVP.Promise()
    tries = 0
    max_tries = 60 # 5 minutes

    # success
    success = () =>
      if this.get("busy") and tries < max_tries
        exec()
      else
        promise.resolve()

      tries++

    # fetch
    fetch = () =>
      this.fetch({ success: success })

    # exec
    exec = () ->
      _.delay(fetch, 5000)

    # go
    exec()

    # promise
    return promise



  get_file_list: () ->
    promise = new RSVP.Promise()
    url = "#{this.url()}/file_list"

    # get
    if this.get("processed")
      $.getJSON(url, (r) -> promise.resolve(r))
    else
      promise.resolve([])

    # return
    promise



  #
  #  Processing
  #
  process: () ->
    promise = new RSVP.Promise()

    # each type has another method
    type = @attributes.type.toLowerCase()
    this["process_#{type}_type"](promise)

    # return
    promise



  #
  #  Processing / Server
  #
  process_server_type: (promise) ->
    this.get_file_list()
      .then(this.ps_get_data)
      .then(this.ps_process_data)
      .then(() -> promise.resolve())



  ps_get_data: (file_list) =>
    promise = new RSVP.Promise()
    url = this.get("configuration")["location"]

    if file_list.length is 0
      $.ajax(
        type: "GET"
        url: url
        dataType: "text"
        success: (response) -> promise.resolve(response)
        error: () -> promise.resolve(false)
      )

    else
      $.ajax(
        type: "POST"
        url: "#{url}check"
        data: { file_list: JSON.stringify(file_list) }
        dataType: "text"
        success: (response) -> promise.resolve(response)
        error: () -> promise.resolve(false)
      )

    # return
    promise



  ps_process_data: (data) =>
    promise = new RSVP.Promise()
    url = "#{this.url()}/process"

    if false #### data
      $.ajax(
        type: "POST"
        url: url
        data: { data: data }
        success: (response) -> promise.resolve(response)
        error: () -> promise.resolve(false)
      )

    else
      promise.resolve(false)

    # return
    promise
