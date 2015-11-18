{$} = require 'atom-space-pen-views'
Figlet = require '../lib/figlet'
figlet = require 'figlet'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Figlet", ->
  [workspaceElement, editorElement, editor, promise, fonts, list, figletModule] = []

  strip = (s) ->
    s.split('\n').map((l) -> l.replace(/\s+$/, '')).filter((l) -> l.length > 0).join('\n')

  beforeEach ->
    atom.config.set 'figlet.defaultFont', 'Banner'

    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise -> atom.packages.activatePackage('language-javascript')
    waitsForPromise -> atom.packages.activatePackage('language-html')

    waitsForPromise -> atom.workspace.open('sample.js').then (e) ->
      editor = e
      editorElement = atom.views.getView(editor)
      editor.setText("dummy")

    waitsForPromise -> atom.packages.activatePackage('figlet').then (pkg) ->
      figletModule = pkg.mainModule

    runs -> figlet.fonts (err, data) -> fonts = data

    waitsFor -> fonts

  describe 'when figlet:last-convert is triggered', ->
    it 'converts the selection using the default font', ->
      expected = null
      editor.setSelectedBufferRange([[0,0],[0,5]])
      atom.commands.dispatch editorElement, 'figlet:convert-last'

      waitsFor -> editor.getText() isnt 'dummy'

      runs ->
        figlet.text 'dummy', font: 'Banner', (err, data) ->
          expected = data

      waitsFor -> expected

      runs ->
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(editor.getText()).toEqual(strip(expected))
        expect(list).not.toExist()

    it 'converts the selection using the module last font', ->
      expected = null
      figletModule.lastFont = 'Banner3'

      editor.setSelectedBufferRange([[0,0],[0,5]])
      atom.commands.dispatch editorElement, 'figlet:convert-last'

      waitsFor -> editor.getText() isnt 'dummy'

      runs ->
        figlet.text 'dummy', font: 'Banner3', (err, data) ->
          expected = data

      waitsFor -> expected

      runs ->
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(editor.getText()).toEqual(strip(expected))
        expect(list).not.toExist()

    it 'preserves the indentation when the selection does not contains it', ->
      editor.setText("  dummy")

      expected = null
      figletModule.lastFont = 'Banner3'

      editor.setSelectedBufferRange([[0,2],[0,7]])
      atom.commands.dispatch editorElement, 'figlet:convert-last'

      waitsFor -> editor.getText() isnt 'dummy'

      runs ->
        figlet.text 'dummy', font: 'Banner3', (err, data) ->
          expected = "  " + data.replace(/\n/g, '\n  ')

      waitsFor -> expected

      runs ->
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(editor.getText()).toEqual(strip(expected))
        expect(list).not.toExist()

    it 'preserves the indentation when the selection contains it', ->
      editor.setText("  dummy")

      expected = null
      figletModule.lastFont = 'Banner3'

      editor.setSelectedBufferRange([[0,0],[0,7]])
      atom.commands.dispatch editorElement, 'figlet:convert-last'

      waitsFor -> editor.getText() isnt 'dummy'

      runs ->
        figlet.text 'dummy', font: 'Banner3', (err, data) ->
          expected = "  " + data.replace(/\n/g, '\n  ')

      waitsFor -> expected

      runs ->
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(editor.getText()).toEqual(strip(expected))
        expect(list).not.toExist()

    it 'preserves the comments when the selection does not contains it', ->
      editor.setText("  // dummy")

      expected = null
      figletModule.lastFont = 'Banner3'

      editor.setSelectedBufferRange([[0,5],[0,10]])
      atom.commands.dispatch editorElement, 'figlet:convert-last'

      waitsFor -> editor.getText() isnt 'dummy'

      runs ->
        figlet.text 'dummy', font: 'Banner3', (err, data) ->
          expected = "  // " + data.replace(/\n/g, '\n  // ')

      waitsFor -> expected

      runs ->
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(editor.getText()).toEqual(strip(expected))
        expect(list).not.toExist()

    it 'preserves the comments when the selection contains it', ->
      editor.setText("  // dummy")

      expected = null
      figletModule.lastFont = 'Banner3'

      editor.setSelectedBufferRange([[0,0],[0,10]])
      atom.commands.dispatch editorElement, 'figlet:convert-last'

      waitsFor -> editor.getText() isnt 'dummy'

      runs ->
        figlet.text 'dummy', font: 'Banner3', (err, data) ->
          expected = "  // " + data.replace(/\n/g, '\n  // ')

      waitsFor -> expected

      runs ->
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(editor.getText()).toEqual(strip(expected))
        expect(list).not.toExist()

    it 'preserves every additional comment character and spaces before a word', ->
      editor.setText("  //    dummy")

      expected = null
      figletModule.lastFont = 'Banner3'

      editor.setSelectedBufferRange([[0,0],[0,15]])
      atom.commands.dispatch editorElement, 'figlet:convert-last'

      waitsFor -> editor.getText() isnt 'dummy'

      runs ->
        figlet.text 'dummy', font: 'Banner3', (err, data) ->
          expected = "  //    " + data.replace(/\n/g, '\n  //    ')

      waitsFor -> expected

      runs ->
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(editor.getText()).toEqual(strip(expected))
        expect(list).not.toExist()

  describe 'when figlet:convert is triggered', ->
    describe 'with no selection', ->
      it 'does not display the font selection list', ->

        atom.commands.dispatch editorElement, 'figlet:convert'
        list = workspaceElement.querySelector('.figlet-font-list')

        expect(list).not.toExist()

    describe 'with a selection', ->
      beforeEach ->
        figletModule.lastFont = null
        editor.setSelectedBufferRange([[0,0],[0,5]])
        atom.commands.dispatch editorElement, 'figlet:convert'

        list = workspaceElement.querySelector('.figlet-font-list')

      it 'displays the font selection list', ->
        expect(list).toExist()
        expect(list.querySelectorAll('li').length).toEqual(fonts.length)
        expect(list.querySelector('li.selected')).toExist()

      describe 'when confirmed', ->
        it 'replaces the text with the ascii art version', (done) ->
          Figlet.figletView.confirmed name: 'Banner3'
          expected = null

          waitsFor -> editor.getText() isnt 'dummy'

          runs ->
            figlet.text 'dummy', font: 'Banner3', (err, data) ->
              expected = data

          waitsFor -> expected

          runs ->
            list = workspaceElement.querySelector('.figlet-font-list')

            expect(editor.getText()).toEqual(strip(expected))
            expect(list).not.toExist()

            expect(figletModule.lastFont).toEqual('Banner3')
