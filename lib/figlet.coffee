FigletFontView = require './figlet-font-view'

module.exports =
  figletView: null

  configDefaults:
    defaultFont: 'Banner'

  activate: (state) ->
    atom.workspaceView.command 'figlet:convert', =>
      editor = atom.workspaceView.getActiveView()
      return unless editor?

      if @figletView?
        @figletView.setEditorView(editor)
      else
        @figletView = new FigletFontView(editor)

      if @figletView.hasParent()
        @figletView.cancel()
      else
        @figletView.attach()


  deactivate: ->
