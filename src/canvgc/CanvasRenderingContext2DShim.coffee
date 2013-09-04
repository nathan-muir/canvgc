_ = require('underscore')
randomId = require('./randomId')

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc



class CanvasRenderingContext2DShim
  ###
   * @param {Stenographer} stenographer
   * @param {CanvasRenderingContext2D} realContext
   * @param {Object} defaults
  ###
  constructor: (@stenographer, @context2d) ->

  get: (name)->
    return @context2d[name]

  set: (name, value)->
    #if @context2d[name] != value
    @stenographer.setContextProperty(name, value)
    @context2d[name] = value
    return

  invoke:(fn, args, assignTarget = null) ->
    # reconcile & output changed properties since last invocation
    @stenographer.invokeContext(fn, args, assignTarget)
    return @context2d[fn]?.apply(@context2d, args)

  fill:->
    return @invoke("fill", arguments)

  stroke:->
    return @invoke("stroke", arguments)

  translate:->
    return @invoke("translate", arguments)

  transform:->
    return @invoke("transform", arguments)

  rotate:->
    return @invoke("rotate", arguments)

  scale:->
    return @invoke("scale", arguments)

  save:->
    return @invoke("save", arguments)

  restore:->
    return @invoke("restore", arguments)

  beginPath:->
    return @invoke("beginPath", arguments)

  closePath:->
    return @invoke("closePath", arguments)

  moveTo:->
    return @invoke("moveTo", arguments)

  lineTo:->
    return @invoke("lineTo", arguments)

  clip:->
    return @invoke("clip", arguments)

  quadraticCurveTo:->
    return @invoke("quadraticCurveTo", arguments)

  bezierCurveTo:->
    return @invoke("bezierCurveTo", arguments)

  arc:->
    return @invoke("arc", arguments)

  createPattern:->
    targetId = randomId('p')
    pattern = @invoke("createPattern", arguments, targetId)
    pattern.targetId = targetId
    return pattern

  createLinearGradient:->
    targetId = randomId('lg')
    linearGradient = @invoke("createLinearGradient", arguments, targetId)
    linearGradient.targetId = targetId
    actualAddColorStop = linearGradient.addColorStop
    # override the colorstop function
    linearGradient.addColorStop = () =>
      @stenographer.invokeChildObject(targetId, "addColorStop", arguments)
      # execute in parent
      return actualAddColorStop.apply(linearGradient, arguments)
    return linearGradient

  createRadialGradient:->
    targetId = randomId('rg')
    radialGradient = @invoke("createRadialGradient", arguments, targetId)
    radialGradient.targetId = targetId
    actualAddColorStop = radialGradient.addColorStop
    # override the colorstop function
    radialGradient.addColorStop = () =>
      @stenographer.invokeChildObject(targetId, "addColorStop", arguments)
      # execute in parent
      return actualAddColorStop.apply(radialGradient, arguments)
    return radialGradient

  fillText:->
    return @invoke("fillText", arguments)

  strokeText:->
    return @invoke("strokeText", arguments)

  measureText:->
    return @invoke("measureText", arguments)

  drawImage:->
    return @invoke("drawImage", arguments)

  fillRect:->
    return @invoke("fillRect", arguments)

  clearRect:->
    return @invoke("clearRect", arguments)

  getImageData:->
    return @invoke("getImageData", arguments)

  putImageData:->
    return @invoke("putImageData", arguments)

  isPointPath:->
    return @invoke("isPointPath", arguments)

  @property 'canvas',
    get: ()-> @get('canvas')
    set: (canvas)-> @set('canvas', canvas)

  @property 'fillStyle',
    get: ()-> @get('fillStyle')
    set: (fillStyle)-> @set('fillStyle', fillStyle)

  @property 'font',
    get: ()-> @get('font')
    set: (font)-> @set('font', font)

  @property 'globalAlpha',
    get: ()-> @get('globalAlpha')
    set: (globalAlpha)-> @set('globalAlpha', globalAlpha)

  @property 'globalCompositeOperation',
    get: ()-> @get('globalCompositeOperation')
    set: (globalCompositeOperation)-> @set('globalCompositeOperation', globalCompositeOperation)

  @property 'lineCap',
    get: ()-> @get('lineCap')
    set: (lineCap)-> @set('lineCap', lineCap)

  @property 'lineDashOffset',
    get: ()-> @get('lineDashOffset')
    set: (lineDashOffset)-> @set('lineDashOffset', lineDashOffset)

  @property 'lineJoin',
    get: ()-> @get('lineJoin')
    set: (lineJoin)-> @set('lineJoin', lineJoin)

  @property 'lineWidth',
    get: ()-> @get('lineWidth')
    set: (lineWidth)-> @set('lineWidth', lineWidth)

  @property 'miterLimit',
    get: ()-> @get('miterLimit')
    set: (miterLimit)-> @set('miterLimit', miterLimit)

  @property 'shadowBlur',
    get: ()-> @get('shadowBlur')
    set: (shadowBlur)-> @set('shadowBlur', shadowBlur)

  @property 'shadowColor',
    get: ()-> @get('shadowColor')
    set: (shadowColor)-> @set('shadowColor', shadowColor)

  @property 'shadowOffsetX',
    get: ()-> @get('shadowOffsetX')
    set: (shadowOffsetX)-> @set('shadowOffsetX', shadowOffsetX)

  @property 'shadowOffsetY',
    get: ()-> @get('shadowOffsetY')
    set: (shadowOffsetY)-> @set('shadowOffsetY', shadowOffsetY)

  @property 'strokeStyle',
    get: ()-> @get('strokeStyle')
    set: (strokeStyle)-> @set('strokeStyle', strokeStyle)

  @property 'textAlign',
    get: ()-> @get('textAlign')
    set: (textAlign)-> @set('textAlign', textAlign)

  @property 'textBaseline',
    get: ()-> @get('textBaseline')
    set: (textBaseline)-> @set('textBaseline', textBaseline)


module.exports = CanvasRenderingContext2DShim

