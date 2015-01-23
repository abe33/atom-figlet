FigletFontView = require './figlet-font-view'

module.exports =
  figletView: null

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
          @figletView = new FigletFontView(editor)

        if @figletView.hasParent()
          @figletView.cancel()
        else
          @figletView.attach()

  deactivate: ->
