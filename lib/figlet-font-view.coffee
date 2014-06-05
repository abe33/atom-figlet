{$$, SelectListView}  = require 'atom'
figlet = require 'figlet'

module.exports =
class FigletFontView extends SelectListView
  currentBuffer: null
  fontList: null

  initialize: (editorView) ->
    super
    @addClass('figlet-font-list overlay from-top')
    @setEditorView(editorView)
    figlet.fonts (err, data) =>
      @setItems data.map (f) -> name: f

      @find('.selected').removeClass('selected')
      @find("li[data-font='#{atom.config.get 'figlet.defaultFont'}']").addClass('selected')

  getFilterKey: ->
    'name'

  viewForItem: (item) ->
    $$ ->
      @li 'data-font': item.name, =>
        @raw item.name

  setEditorView: (@editorView) ->
    {@editor} = @editorView
    @setCurrentBuffer(@editor.getBuffer())

  setCurrentBuffer: (@currentBuffer) ->

  attach: ->
    return if @editor.getSelection().isEmpty()

    @storeFocusedElement()
    atom.workspaceView.append(this)
    @focusFilterEditor()

  detach: ->
    return unless @hasParent()
    @previouslyFocusedElement?.focus()
    super

  cancel: ->
    @detach()

  destroy: ->
    @cancel()
    @remove()
