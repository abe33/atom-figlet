{SelectListView}  = require 'atom'

module.exports =
class FigletFontView extends SelectListView
  currentBuffer: null
  fontList: null

  initialize: (@editorView) ->
    super
    @addClass('figlet-font-list overlay from-top')
    {@editor} = @editorView
    @setCurrentBuffer(@editor.getBuffer())

  setCurrentBuffer: (@currentBuffer) ->

  attach: ->
    atom.workspaceView.append(this)

  cancel: ->
    @remove()
