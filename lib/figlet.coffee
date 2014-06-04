FigletFontView = require './figlet-font-view'

module.exports =
  figletView: null

  configDefaults:
    defaultTheme: 'banner'

  activate: (state) ->
    atom.workspaceView.command 'figlet:convert', =>
      editor = atom.workspaceView.getActiveView()
      return unless editor?

      @figletView ||= new FigletFontView(editor)

      if @figletView.hasParent()
        @figletView.cancel()
      else
        @figletView.attach()


  deactivate: ->
