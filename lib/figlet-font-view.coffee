{SelectListView}  = require 'atom'

module.exports =
class FigletFontView extends SelectListView
  currentBuffer: null
  fontList: null

  initialize: (editorView) ->
    super
    @addClass('figlet-font-list overlay from-top')
    @setEditorView(editorView)

  getFilterKey: ->
    'name'

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
