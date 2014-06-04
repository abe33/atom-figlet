{WorkspaceView} = require 'atom'
Figlet = require '../lib/figlet'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Figlet", ->
  [editorView, editor, promise] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync('sample.js')
    atom.workspaceView.attachToDom()
    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    editorView.setText("dummy")
    editor.setSelectedBufferRange([[0,0],[0,5]])

    promise = atom.packages.activatePackage('figlet')

  describe 'with a selection in an editor', ->
    describe 'when figlet:convert is triggered', ->
      it 'displays the font selection list', ->
        editorView.trigger 'figlet:convert'

        waitsForPromise ->
          promise

        runs ->
          expect(atom.workspaceView.find('.figlet-font-list').view()).toExist()