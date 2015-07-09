FigletFontView = require './figlet-font-view'
figlet = require 'figlet'

module.exports =
  figletView: null
  lastFont: null

  config:
    defaultFont:
      type: 'string'
      default: 'Banner3'
    asComment:
      type: 'boolean'
      default: false
      description: 'Add /* */ around the figlet text'

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
            if atom.config.get('figlet.asComment')
                data = '/*\n\r' + data + '\n\r*/'
            editor.insertText data
  deactivate: ->
