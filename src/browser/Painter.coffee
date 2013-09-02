###
  An Example of how to render the output of COA
###
class Painter

  ###
   * @param {Array} renderList
   * @param {Function} setImmediate
  ###
  constructor: (@plan, @setImmediate)->
    @renderId = 0
    @ready = false
    @renderCtx =
      stack: 0
    @renderListPosition = 0
    @rendering = false

  loadImages: (cb)->
    imageNames = _.keys(@plan.i)
    if imageNames.length == 0
      @ready = true
      @setImmediate(cb)
    for name, data of @plan.i
      do (name, data) =>
        img = new Image()
        img.onload = () =>
          @renderCtx[name] = img
          if _.every(imageNames, (n)=> @renderCtx[n]?)
            @ready = true
            @setImmediate(cb)
          return
        img.src = data
    return

  cancel: (context2d)->
    @renderListPosition = 0
    @rendering = false
    while @renderCtx.stack > 0
      context2d.restore()
      @renderCtx.stack--
    return

  renderImmediately: (context2d)->
    unless @ready
      throw new Error('Painter not yet ready.')
    for f in @plan.d
      f(context2d, @renderCtx)
    return

  render: (context2d, cb)->
    unless @ready
      throw new Error('Painter not yet ready.')
    @rendering = true
    @renderId += 1
    @renderListPosition = 0

    enqueue = (renderId)=>
      if @renderListPosition < @plan.d.length
        fn = @plan.d[@renderListPosition]
        @renderListPosition += 1
        @setImmediate ()=>
          if !@rendering or renderId != @renderId
            console.log('Rendering cancelled for renderId', renderId);
            return
          fn(context2d, @renderCtx)
          enqueue(renderId)
          return
      else
        @renderId = 0
        @renderListPosition = 0
        @rendering = false
        @setImmediate(cb)

      return
    enqueue(@renderId)
    return
