PKG = require('../../package.json')
FS = require('fs')
canvgc = require('./canvgc')

#process.on("uncaughtException", ()-> console.log(arguments))

module.exports = require('coa').Cmd()
  .helpful()
  .name(PKG.name)
  .title(PKG.description)
  .opt()
    .name("input")
    .title("Input file")
    .short("i").long("input")
      .val((val) ->
        return val or @reject("Option --input must have a value.")
      )
    .end()
  .opt()
    .name("output")
    .title("Output file")
    .short("o").long("output")
    .val((val) ->
      return val or @reject("Option --output must have a value.")
    )
    .end()
  .opt()
    .name("chunk")
    .title("The number of CanvasRenderingContext2D commands to call per function")
    .long("chunk")
    .val((val) ->
      n = parseInt(val)
      if isNaN(n)
        return null
      else
        return n
    )
    .end()
  .opt()
    .name("prepend")
    .title("Javascript to prepend to the output file")
    .long("prepend")
    .end()
  .opt()
    .name("append")
    .title("Javascript to append to the output file")
    .long("append")
    .end()
  .arg()
      .name('input').title('Alias to --input')
      .end()
  .arg()
      .name('output').title('Alias to --output')
      .end()

  .act (opts, args)->
    input = args?.input ? opts.input
    output = args?.output ? opts.output
    unless input? and output?
      return @usage()

    FS.readFile input, 'utf8', (err, data)->
      if (err)
        throw err;
      canvgc data, opts.chunk, (err, jsData)->
        if (err)
          throw err;
        if opts.prepend?
          jsData = "#{opts.prepend}#{jsData}";
        if opts.append?
          jsData += opts.append
        FS.writeFile output, jsData, 'utf8', (err)->
    return