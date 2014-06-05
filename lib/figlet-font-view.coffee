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

      itemView = @find("li[data-font='#{atom.config.get 'figlet.defaultFont'}']")
      @selectItemView itemView
      console.log 'here'

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

  confirmed: (item) ->
    figlet.text @editor.getSelectedText(), font: item.name, (err, data) =>
      @editor.insertText data

  cancel: ->
    @detach()

  destroy: ->
    @cancel()
    @remove()
