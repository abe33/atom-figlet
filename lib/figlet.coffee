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
        editor = atom.workspace.getActiveTextEditor()

        figlet.text editor.getSelectedText(), font: @lastFont ? atom.config.get('figlet.defaultFont'), (err, data) =>
          editor.insertText data
  deactivate: ->
