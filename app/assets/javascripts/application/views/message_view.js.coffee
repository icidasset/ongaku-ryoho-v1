class OngakuRyoho.Classes.Views.Message extends Backbone.View

  #
  #  Initialize
  #
  initialize: () =>
    @template = Handlebars.compile($("#message_template").html())



  #
  #  Render
  #
  render: () =>
    this.$el.html(@template( this.model.toJSON() ))

    # jquery object
    $message = this.$el.children(".message").last()

    # add cid
    $message.attr("rel", @model.cid)

    # loading or error?
    if @model.get("loading")
      $message.addClass("loading").append("<div></div>")

    else if this.model.get("error")
      $message.addClass("error")

    # chain
    return this