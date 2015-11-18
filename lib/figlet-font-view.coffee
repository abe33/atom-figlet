{$$, SelectListView, TextEditorView}  = require 'atom-space-pen-views'
figlet = require 'figlet'

module.exports =
class FigletFontView extends SelectListView
  currentBuffer: null
  fontList: null

  @content: ->
    @div class: 'select-list', =>
      @subview 'filterEditorView', new TextEditorView(mini: true)
      @div class: 'error-message', outlet: 'error'
      @div class: 'loading', outlet: 'loadingArea', =>
        @span class: 'loading-message', outlet: 'loading'
        @span class: 'badge', outlet: 'loadingBadge'
      @ol class: 'list-group', outlet: 'list'

  initialize: (editor, @figletPackage) ->
    previousElement = @element
    @element = @[0] = document.createElement('atom-panel')
    @[0].appendChild(previousElement)

    super

    @addClass('modal figlet-font-list overlay from-top')
    @setEditor(editor)

    figlet.fonts (err, data) =>
      @setItems data.map (f) -> name: f

      requestAnimationFrame =>
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
    workspaceElement.querySelector('atom-panel-container.modal').appendChild(@element)
    @focusFilterEditor()

  detach: ->
    return unless @hasParent()
    @previouslyFocusedElement?.focus()
    super

  confirmed: (item) ->
    @figletPackage.lastFont = item.name
    @figletPackage.convert(item.name)
    @detach()

  cancel: ->
    @detach()

  destroy: ->
    @cancel()
    @remove()
