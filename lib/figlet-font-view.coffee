{$$, SelectListView}  = require 'atom-space-pen-views'
figlet = require 'figlet'

module.exports =
class FigletFontView extends SelectListView
  currentBuffer: null
  fontList: null

  initialize: (editor) ->
    super
    @addClass('figlet-font-list overlay from-top')
    @setEditor(editor)
    figlet.fonts (err, data) =>
      @setItems data.map (f) -> name: f

      itemView = @find("li[data-font='#{atom.config.get 'figlet.defaultFont'}']")
      @selectItemView itemView

  getFilterKey: -> 'name'

  viewForItem: (item) ->
    $$ ->
      @li 'data-font': item.name, =>
        @raw item.name

  setEditor: (@editor) ->
    @setCurrentBuffer(@editor.getBuffer())

  setCurrentBuffer: (@currentBuffer) ->

  attach: ->
    return if @editor.getLastSelection().isEmpty()

    @storeFocusedElement()
    workspaceElement = atom.views.getView(atom.workspace)
    workspaceElement.appendChild(@element)
    @focusFilterEditor()

  detach: ->
    return unless @hasParent()
    @previouslyFocusedElement?.focus()
    super

  confirmed: (item) ->
    figlet.text @editor.getSelectedText(), font: item.name, (err, data) =>
      @editor.insertText data

    @detach()

  cancel: ->
    @detach()

  destroy: ->
    @cancel()
    @remove()
