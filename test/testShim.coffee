chai = require('chai')

CanvasRenderingContext2DShim = require('../lib/canvgc/CanvasRenderingContext2DShim')

chai.should()

describe 'CanvasRenderingContext2DShim', ()->
  mockStenographer =
    'invokeContext': (fn, args, assignTarget)-> return
    'setContextProperty': (propertyName, value)-> return
    'invokeChildObject': (name, fn, args)-> return

  mockContext =
    createPattern: ()->
      return {}
    createLinearGradient: ()->
      return {
        addColorStop: ()-> return
      }
    createRadialGradient: ()->
      return {
        addColorStop: ()-> return
      }

  shim = new CanvasRenderingContext2DShim(mockStenographer, mockContext)

  describe '#set()', ()->
    it 'setting a property should call stenographer.setContextProperty', ()->
      mock = mockStenographer.setContextProperty

      properties = [
        'canvas',
        'fillStyle',
        'font',
        'globalAlpha',
        'globalCompositeOperation',
        'lineCap',
        'lineDashOffset',
        'lineJoin',
        'lineWidth',
        'miterLimit',
        'shadowBlur',
        'shadowColor',
        'shadowOffsetX',
        'shadowOffsetY',
        'strokeStyle',
        'textAlign',
        'textBaseline'
      ]
      for property in properties
        called = false
        mockStenographer.setContextProperty = (propertyName, value)->
          called = true
          propertyName.should.be.a('string')
          propertyName.should.equal(property)
          value.should.equal("")
          return
        shim[property] = ""
        called.should.be.true
      mockStenographer.setContextProperty = mock
      return
  describe '#call()', ()->
    it 'invoking a valid CanvasRenderingContext2D function, should call stenographer.invokeContext', ()->
      mock = mockStenographer.invokeContext

      context2dFunctionNames = [
        'fill',
        'stroke',
        'translate',
        'transform',
        'rotate',
        'scale',
        'save',
        'restore',
        'beginPath',
        'closePath',
        'moveTo',
        'lineTo',
        'clip',
        'quadraticCurveTo',
        'bezierCurveTo',
        'arc',
        'createPattern',
        'createLinearGradient',
        'createRadialGradient',
        'fillText',
        'strokeText',
        'measureText',
        'drawImage',
        'fillRect',
        'clearRect',
        'getImageData',
        'putImageData',
        'isPointPath'
      ]
      for context2dFunctionName in context2dFunctionNames
        called = false
        mockStenographer.invokeContext = (invokedFn, invokedArgs, invokedAssignTarget)->
          called = true
          invokedFn.should.be.a('string')
          invokedFn.should.equal(context2dFunctionName)
          invokedArgs.length.should.equal(2)
          return
        shim[context2dFunctionName].call(shim, 'testing', 'abc')
        called.should.be.true
      mockStenographer.invokeContext = mock
      return

    it '#createPattern() should return an object with targetId', ()->
      mock = mockStenographer.invokeContext
      called = false
      valueOfInvokedAssignTarget = null
      mockStenographer.invokeContext = (invokedFn, invokedArgs, invokedAssignTarget)->
        called = true
        invokedFn.should.be.a('string')
        invokedFn.should.equal('createPattern')
        invokedArgs.length.should.equal(0)
        invokedAssignTarget.should.be.a('string')
        valueOfInvokedAssignTarget = invokedAssignTarget;
        return
      pattern = shim.createPattern()
      called.should.be.true
      pattern.targetId.should.equal(valueOfInvokedAssignTarget)
      mockStenographer.invokeContext = mock
      return

    it '#createLinearGradient() should return an object with targetId, and mocked addColorStop', ()->
      mockInvokeContext = mockStenographer.invokeContext
      mockInvokeChildObject = mockStenographer.invokeChildObject
      called = false
      valueOfInvokedAssignTarget = null
      mockStenographer.invokeContext = (invokedFn, invokedArgs, invokedAssignTarget)->
        called = true
        invokedFn.should.be.a('string')
        invokedFn.should.equal('createLinearGradient')
        invokedArgs.length.should.equal(0)
        invokedAssignTarget.should.be.a('string')
        valueOfInvokedAssignTarget = invokedAssignTarget;
        return
      linearGradient = shim.createLinearGradient()
      called.should.be.true
      linearGradient.targetId.should.equal(valueOfInvokedAssignTarget)

      called = false
      mockStenographer.invokeChildObject = (invokedTargetName, invokedFn, invokedArgs)->
        called = true
        invokedTargetName.should.equal(linearGradient.targetId)
        invokedFn.should.equal('addColorStop')
        invokedArgs.length.should.equal(0)
        return
      linearGradient.addColorStop()
      called.should.be.true

      mockStenographer.invokeContext = mockInvokeContext
      mockStenographer.invokeChildObject = mockInvokeChildObject
      return

    it '#createRadialGradient() should return an object with targetId, and mocked addColorStop', ()->
      mockInvokeContext = mockStenographer.invokeContext
      mockInvokeChildObject = mockStenographer.invokeChildObject
      called = false
      valueOfInvokedAssignTarget = null
      mockStenographer.invokeContext = (invokedFn, invokedArgs, invokedAssignTarget)->
        called = true
        invokedFn.should.be.a('string')
        invokedFn.should.equal('createRadialGradient')
        invokedArgs.length.should.equal(0)
        invokedAssignTarget.should.be.a('string')
        valueOfInvokedAssignTarget = invokedAssignTarget;
        return
      linearGradient = shim.createRadialGradient()
      called.should.be.true
      linearGradient.targetId.should.equal(valueOfInvokedAssignTarget)

      called = false
      mockStenographer.invokeChildObject = (invokedTargetName, invokedFn, invokedArgs)->
        called = true
        invokedTargetName.should.equal(linearGradient.targetId)
        invokedFn.should.equal('addColorStop')
        invokedArgs.length.should.equal(0)
        return
      linearGradient.addColorStop()
      called.should.be.true

      mockStenographer.invokeContext = mockInvokeContext
      mockStenographer.invokeChildObject = mockInvokeChildObject
      return
    return
  return