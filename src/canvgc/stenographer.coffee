Canvas = require("canvas")
randomId = require('./randomId')

class Stenographer

  constructor: (@callsPerFunc=null)->

    @output = ''
    @images = {}
    @contextName = '$'
    @propertiesName = 'p'
    @calls = 0

    @startFunc = "function(#{@contextName},#{@propertiesName}){\n"
    @endFunc = "}"
    @splitFunc = "#{@endFunc},#{@startFunc}"

  toJS: (width, height)->
    "{\"w\":#{JSON.stringify(width)},\"h\":#{JSON.stringify(height)},\"d\":[#{@startFunc}#{@output}#{@endFunc}],\"i\":#{JSON.stringify(@images)}}"

  serialize: (value, roundNumbers=false)->
    t = typeof value;

    if t == 'number' and roundNumbers
      return (+value.toFixed(6)).toString()
    else if t in ["boolean", "number", "string"] or value == null
      return JSON.stringify(value)
    else if value?.targetId?
      return "#{@propertiesName}.#{value.targetId}"
    else if value?.tagName == "IMG" || value?.src?
      imageId = randomId('img')
      @images[imageId]  = @getBase64Image(value)
      return "#{@propertiesName}.#{imageId}"
    else if value?.tagName == "CANVAS"
      imageId = randomId('img')
      @images[imageId] = value.toDataUrl('image/png')
      return "#{@propertiesName}.#{imageId}"
    else
      console.log("Could not serialize value: " + JSON.stringify(value))
      throw new Error("Could not serialize value: "  + JSON.stringify(value))

  getBase64Image:(img) ->
    # Create an empty canvas element
    canvas = new Canvas()
    canvas.width = img.width
    canvas.height = img.height
    # Copy the image contents to the canvas
    ctx = canvas.getContext("2d")
    ctx.drawImage(img, 0, 0)
    return canvas.toDataURL("image/png")

  serializeArgs: (args, roundNumbers=false)->
    out = []
    for arg in args
      out.push(@serialize(arg, roundNumbers))
    return out.join(',')

  setContextProperty: (propertyName, value)->
    @output += "#{@contextName}.#{propertyName} = #{@serialize(value)};\n"
    return
  invokeChildObject: (name, fn, args)->
    @output += "#{name}.#{fn}(#{@serializeArgs(args)});\n"
    return

  shouldRoundNumbers: (fn)->
    return fn in ["moveTo","lineTo","bezierCurveTo","quadraticCurveTo"]

  invokeContext: (fn, args, assignTarget = null)->
    if assignTarget?
      @output += "#{@propertiesName}.#{assignTarget} = ";

    @output += "#{@contextName}.#{fn}(#{@serializeArgs(args, @shouldRoundNumbers(fn))});\n"

    if fn == "save"
      @output += "#{@propertiesName}.stack++;\n"
    if fn == "restore"
      @output += "#{@propertiesName}.stack--;\n"

    @calls += 1
    if @callsPerFunc? and @calls % @callsPerFunc == 0
      @output += @splitFunc
    return


module.exports = Stenographer