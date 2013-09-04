chai = require('chai')
assert = require('assert')


Stenographer = require('../lib/canvgc/stenographer')

chai.should()

describe 'Stenographer', ()->

  stenographer = new Stenographer()

  describe '#serialize()', ()->
    it 'should serialize boolean, strings and numbers', ()->
      stenographer.serialize(true).should.equal("true")
      stenographer.serialize(false).should.equal("false")
      stenographer.serialize(null).should.equal("null")
      stenographer.serialize("testString").should.equal('"testString"')
      stenographer.serialize("55.00").should.equal('"55.00"')
      stenographer.serialize(55.00).should.equal("55")
      return

    it 'should respond to objects with a "targetId"', ()->
      stenographer.serialize({"targetId":"test"}).should.equal("p.test")
      return
    ###
    it 'should serialize IMG tags', ()->
      # TODO - test for serialzing IMG tags
      true.should.be.false
      return

    it 'should serialize CANVAS tags', ()->
      # TODO - test for serializing CANVAS tags
      true.should.be.false
      return
    ###
    it 'should throw an error for unsupported types', ()->
      fn = ()->
        stenographer.serialize(["potato"])
      fn.should.throw(Error)
      return

    return

  describe '#serializeArgs()', ()->
    it 'should return "" when array is empty', ()->
      stenographer.serializeArgs([]).should.equal("")
      return

    it 'should serialize an array of values', ()->
      stenographer.serializeArgs([true]).should.equal("true")
      stenographer.serializeArgs([false]).should.equal("false")
      stenographer.serializeArgs([true, false]).should.equal("true,false")
      return

    return


  describe '#setContextProperty()', ()->
    it 'should append property to @output', ()->
      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.setContextProperty('test',true)
      stenographer.output.should.equal("$.test = true;\n")
      stenographer.output = ''
      stenographer.setContextProperty('abcDef',55)
      stenographer.output.should.equal("$.abcDef = 55;\n")
      stenographer.output = tmpOutput
      return

    return

  describe '#invokeContext()', ()->
    it 'should append invocation to @output', ()->
      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('someFunc',[true, false, 55, "abc"])
      stenographer.output.should.equal('$.someFunc(true,false,55,"abc");\n')
      stenographer.output = tmpOutput
      return
    it 'invoking "save" should increment the stack', ()->
      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('save',[])
      stenographer.output.should.equal('$.save();\np.stack++;\n')
      stenographer.output = tmpOutput
      return
    it 'invoking "restore" should decrement the stack', ()->
      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('restore',[])
      stenographer.output.should.equal('$.restore();\np.stack--;\n')
      stenographer.output = tmpOutput
      return
    it 'should round numbers for moveTo, lineTo, bezierCurveTo, quadraticCurveTo', ()->
      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('moveTo',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.moveTo(55.123457,55.987654);\n')
      stenographer.output = tmpOutput

      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('lineTo',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.lineTo(55.123457,55.987654);\n')
      stenographer.output = tmpOutput

      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('bezierCurveTo',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.bezierCurveTo(55.123457,55.987654);\n')
      stenographer.output = tmpOutput


      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('quadraticCurveTo',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.quadraticCurveTo(55.123457,55.987654);\n')
      stenographer.output = tmpOutput

      return

    it 'should not round numbers for transform, rotate, scale, skew', ()->
      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('transform',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.transform(55.123456789,55.987654321);\n')
      stenographer.output = tmpOutput

      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('rotate',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.rotate(55.123456789,55.987654321);\n')
      stenographer.output = tmpOutput

      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('scale',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.scale(55.123456789,55.987654321);\n')
      stenographer.output = tmpOutput

      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeContext('skew',[55.123456789, 55.987654321])
      stenographer.output.should.equal('$.skew(55.123456789,55.987654321);\n')
      stenographer.output = tmpOutput
      return

  describe '#invokeChildObject()', ()->
    it 'should append invocation to @output', ()->
      tmpOutput = stenographer.output
      stenographer.output = ''
      stenographer.invokeChildObject('obj','someFunc',[true, false, 55, "abc"])
      stenographer.output.should.equal('p.obj.someFunc(true,false,55,"abc");\n')
      stenographer.output = tmpOutput
      return
  return