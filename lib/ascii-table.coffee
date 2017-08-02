AsciiTableView = require './ascii-table-view'
{CompositeDisposable, Disposable} = require 'atom'

module.exports = AsciiTable =
  config:
    showExtended:
      description: 'Show extended ASCII table (codes 128 - 255).'
      type: 'boolean'
      default: false

  URI: 'atom://ascii-table'

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'ascii-table:toggle': => @toggle()
    @subscriptions.add atom.workspace.addOpener (uri) =>
      if uri == @URI
        new AsciiTableView(uri)

    @subscriptions.add atom.config.onDidChange 'ascii-table.showExtended', ({newValue, oldValue}) =>
      atom.workspace.getPaneItems().forEach (item) ->
        if item instanceof AsciiTableView
          console.log item
          item.render()

    @subscriptions.add new Disposable( () =>
      atom.workspace.getPaneItems().forEach (item) ->
        if item instanceof AsciiTableView
          item.destroy()
    )

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    atom.workspace.toggle @URI

  deserializeAsciiTableView: (serialized) ->
    new AsciiTableView(@URI)
