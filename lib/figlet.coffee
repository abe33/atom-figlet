figlet = require 'figlet'
{Point, Range} = require 'atom'

FigletFontView = require './figlet-font-view'

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
    [prefix, textToConvert, start, end] = @getTextToConvert(editor)
    figlet.text textToConvert, {font}, (err, data) =>
      text = data
      .split('\n')
      .map((l) -> (prefix + l).replace(/\s+$/, ''))
      .filter((l) -> l.length > 0)
      .join('\n')

      editor.setTextInBufferRange([[start.row, 0], end], text)

  getTextToConvert: (editor) ->
    escapeRegExp = (str) ->
      str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&'

    selection = editor.getLastSelection()
    {start, end} = selection.getBufferRange()

    start = Point.fromObject([start.row, 0])

    # First we'll catch all the leading space characters in the selection line
    selectionText = editor.getTextInRange([start, end])
    indentInSelection = /[^\s]/.exec(selectionText).index

    if indentInSelection > 0
      start.column += indentInSelection
      selectionText = selectionText[indentInSelection..-1]

    # Then, for the remaining string, we'll check whether there's a comment
    # or not
    scope = editor.scopeDescriptorForBufferPosition([start.row, 0])
    {commentStartString, commentEndString} = editor.languageMode.commentStartAndEndStringsForScope(scope)

    if commentStartString?
      commentStartRegexString = escapeRegExp(commentStartString).replace(/(\s+)$/, '')
      commentStartRegex = new RegExp("^(\\s*)(#{commentStartRegexString})*\\s+")

      match = commentStartRegex.exec(selectionText)

      if match?
        {length} = match[0]
        start.column += length
        selectionText = selectionText[length..-1]

    precedingText = editor.getTextInRange([[start.row, 0], start])

    [precedingText, selectionText, start, end]
