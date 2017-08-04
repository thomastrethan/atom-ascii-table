module.exports =
class AsciiTableView
  chars: null

  constructor: (@uri) ->
    @chars = ['NUL', 'SOH', 'STX', 'ETC', 'EOT', 'ENQ', 'ACK', 'BEL', 'BS', 'TAB',
      'LF', 'VT', 'FF', 'CR', 'SO', 'SI', 'DLE', 'DC1', 'DC2', 'DC3', 'DC4',
      'NAK', 'SYN', 'ETB', 'CAN', 'EM', 'SUB', 'ESC', 'FS', 'GS', 'RS', 'US', 'SPC'
    ]
    @chars[127] = 'DEL'
    @element = document.createElement('div')
    @element.classList.add('ascii-table')
    @render();

  render: ->
    console.log "AsciiTableRender"
    @element.removeChild(@element.firstChild) while @element.firstChild
    to = if atom.config.get('ascii-table.showExtended') then 255 else 127
    for ascii in [0..to]
      if ascii % 64 == 0
        table = document.createElement('table')
        tr = document.createElement('tr')
        tr.appendChild(@createCell('Dec', true))
        tr.appendChild(@createCell('Hex', true))
        tr.appendChild(@createCell('Char', true))
        table.appendChild(tr)
        @element.appendChild(table)
      table.appendChild(@createEntry(ascii))

  serialize: ->
    deserializer: 'ascii-table/AsciiTableView'

  destroy: ->
    @element.remove()

  getElement: ->
    @element

  getTitle: ->
    'ASCII Table'

  getURI: ->
    @uri

  getDefaultLocation: ->
    'right'

  getAllowedLocations: ->
    ['left', 'right']

  createEntry: (ascii) ->
    tr = document.createElement('tr')
    tr.appendChild(@createCell(ascii))
    tr.appendChild(@createCell((if ascii < 16 then "0" else "") + ascii.toString(16).toUpperCase()))
    tr.appendChild(@createCell(if @chars[ascii]? then @chars[ascii] else String.fromCharCode(ascii)))
    tr

  createCell: (val, header = false) ->
    td = document.createElement(if header then 'th' else 'td')
    td.textContent = val
    td
