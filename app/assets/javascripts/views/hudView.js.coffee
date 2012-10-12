class App.HudView extends Backbone.View
  el: ".hud",
  events: {
    "click .save": "saveContext"
    "click .share": "openSharePopup"
  }
  initialize: ->
    @model.on("afterSave", @afterSave, this)
    @cartCollection     = @options.cartCollection
    @catalogCollection  = @options.catalogCollection
    @mapProvider        = @options.mapProvider
    @router             = @options.router
    @form               = new Backbone.Form({ model: @model, idPrefix: "context_" })
    @render()
  render: ->
    @mapView = new App.MapView({mapProvider: @mapProvider, parentView: this})
    @catalog = new App.CatalogView({ el: this.$("#catalog"), collection: @catalogCollection, parentView: this })
    @cart = new App.CartView({ el: this.$("#layers"), collection: @cartCollection, parentView: this })
    @infos = new App.InfosView({ el: this.$("#infos"), parentView: this })
    @toolbar = new App.MapToolbarView({ parentView: this })
  open: ->
    @$el.css("left", "0")
    $("#map").css("left", @$el.width())
  close: ->
    @$el.css("left", -@$el.width())
    $("#map").css("left", 0)
  saveContext: (e) ->
    e.preventDefault()
    errors = @form.commit()
    unless errors
      layer_ids = _.map(@cartCollection.models, (layer) ->
        layer.get("id")
      )
      @model.save {layer_ids: layer_ids},
        success: (model, response) ->
          if model.isNew()
            model.set({slug: response.slug})
          model.trigger("afterSave")
  afterSave: ->
    @switchControls(false)
    @router.navigate @model.get("slug")
  switchControls: (unsaved) ->
    if unsaved
      @$el.find(".save").removeAttr("disabled").removeClass("disabled")
      @$el.find(".share").attr("disabled", "disabled").addClass("disabled")   
    else
      @$el.find(".share").removeAttr("disabled").removeClass("disabled")
      @$el.find(".save").attr("disabled", "disabled").addClass("disabled")
  openSharePopup: (e) ->
    $("#share-modal").modal()