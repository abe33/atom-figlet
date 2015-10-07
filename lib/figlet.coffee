FigletFontView = require './figlet-font-view'
figlet = require 'figlet'

module.exports =
  figletView: null
  lastFont: null

  config:
    defaultFont:
      type: 'string'
      default: 'Banner'

  activate: (state) ->
    atom.commands.add 'atom-text-editor',
      'figlet:convert': =>
        editor = atom.workspace.getActiveTextEditor()
        return unless editor?

        if @figletView?
          @figletView.setEditor(editor)
        else
          @figletView = new FigletFontView(editor, this)

        if @figletView.hasParent()
          @figletView.cancel()
        else
          @figletView.attach()

      'figlet:convert-last': =>
        @convert @lastFont ? atom.config.get('figlet.defaultFont')

  deactivate: ->

  convert: (font) ->
    editor = atom.workspace.getActiveTextEditor()
    selection = editor.getLastSelection()
    {start, end} = selection.getBufferRange()
    selectionText = editor.getTextInRange([start, end])
    indentInSelection = /[^\s]/.exec(selectionText).index

    if indentInSelection > 0
      start.column += indentInSelection
      selectionText = selectionText[indentInSelection..-1]

    precedingText = editor.getTextInRange([[start.row, 0], start])

    figlet.text selectionText, {font}, (err, data) =>
      text = precedingText + data.replace(/\n/g, "\n#{precedingText}")
      editor.setTextInBufferRange([[start.row, 0], end], text)
