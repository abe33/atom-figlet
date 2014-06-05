{WorkspaceView} = require 'atom'
Figlet = require '../lib/figlet'
figlet = require 'figlet'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Figlet", ->
  [editorView, editor, promise, fonts] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync('sample.js')
    atom.workspaceView.attachToDom()
    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    editorView.setText("dummy")
    atom.config.set 'figlet.defaultFont', 'Banner'

    promise = atom.packages.activatePackage('figlet')

    waitsForPromise -> promise

    runs -> figlet.fonts (err, data) -> fonts = data

    waitsFor -> fonts

  describe 'when figlet:convert is triggered', ->
    describe 'with no selection', ->
      it 'does not display the font selection list', ->
        editorView.trigger 'figlet:convert'

        runs ->
          expect(atom.workspaceView.find('.figlet-font-list').view()).not.toExist()

    describe 'with a selection', ->
      beforeEach ->
        editor.setSelectedBufferRange([[0,0],[0,5]])
        editorView.trigger 'figlet:convert'

      it 'displays the font selection list', ->
        runs ->
          list = atom.workspaceView.find('.figlet-font-list')

          expect(list.view()).toExist()
          expect(list.find('li').length).toEqual(fonts.length)
          expect(list.find('li.selected').length).toEqual(1)
          expect(list.find('li.selected').text()).toEqual('Banner')

      describe 'when confirmed', ->
        it 'replaces the text with the ascii art version', ->
          Figlet.figletView.confirmed name: 'Banner'

          waitsFor -> editor.getText() isnt 'dummy'

          runs ->
            figlet.text font: 'Banner', (err, data) ->
              expect(editor.getText()).toEqual(data)
