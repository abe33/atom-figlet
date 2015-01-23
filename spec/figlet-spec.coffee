{$} = require 'atom-space-pen-views'
Figlet = require '../lib/figlet'
figlet = require 'figlet'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Figlet", ->
  [workspaceElement, editorElement, editor, promise, fonts, list] = []

  beforeEach ->
    atom.config.set 'figlet.defaultFont', 'Banner'

    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise -> atom.workspace.open('sample.js')

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)
      editor.setText("dummy")

    waitsForPromise -> atom.packages.activatePackage('figlet')

    runs -> figlet.fonts (err, data) -> fonts = data

    waitsFor -> fonts

  describe 'when figlet:convert is triggered', ->
    describe 'with no selection', ->
      it 'does not display the font selection list', ->

        atom.commands.dispatch editorElement, 'figlet:convert'
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(list).not.toExist()

    describe 'with a selection', ->
      beforeEach ->
        editor.setSelectedBufferRange([[0,0],[0,5]])
        atom.commands.dispatch editorElement, 'figlet:convert'

        list = workspaceElement.querySelector('.figlet-font-list')

      it 'displays the font selection list', ->
        expect(list).toExist()
        expect(list.querySelectorAll('li').length).toEqual(fonts.length)
        expect(list.querySelector('li.selected')).toExist()
        expect(list.querySelector('li.selected').textContent).toEqual('Banner')

      describe 'when confirmed', ->
        it 'replaces the text with the ascii art version', (done) ->
          Figlet.figletView.confirmed name: 'Banner'
          expected = null

          waitsFor -> editor.getText() isnt 'dummy'

          runs ->
            figlet.text 'dummy', font: 'Banner', (err, data) ->
              expected = data

          waitsFor -> expected

          runs ->
            list = workspaceElement.querySelector('.figlet-font-list')

            expect(editor.getText()).toEqual(expected)
            expect(list).not.toExist()
