Canvas = require("canvas")
canvg = require('../canvg/canvg')
CanvasRenderingContext2DShim = require('./CanvasRenderingContext2DShim')
Stenographer = require('./stenographer')

canvgc = (svgAsText, callsPerFunc = null, onComplete)->
  canvas = new Canvas()
  context2d = canvas.getContext('2d')
  stenographer = new Stenographer(callsPerFunc)
  shim = new CanvasRenderingContext2DShim(stenographer, context2d)
  canvas.getContext = (type)->
    if type == '2d'
      return shim
    else
      return null

  canvg canvas, svgAsText,
    ignoreDimensions: true
    ignoreClear: true
    ignoreMouse: true
    renderCallback: ()->
      onComplete.call(null, null, stenographer.toJS(canvas.width, canvas.height))
      return
  return

module.exports = canvgc