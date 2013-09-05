canvgc
=====

`canvgc` is a nodejs tool for compiling SVG to html5 CanvasRenderingContext2D commands.

## Version
0.1.3

## Installation
```sh
npm install canvgc
```
## Usage (Server Side)
```bash
canvgc file.svg file.js # basic conversion

canvgc file.svg file.js --prepend 'window.canvgc={"file":' --append '};' # assign to some variable

canvgc file.svg file.js --prepend 'callback(' --append ');' # call a function with result

canvgc file.svg file.js --chunk 500 # break in to blocks of code (prevent event loop starvation when rendering large files)
```
    

## Usage (Client Side)
```js
  // basic render at original width & height, without transforms
  function render(canvas, plan){
    var painter = new Painter(plan,function(cb){window.setTimeout(cb,0);}); // can use setImmediate poly-fill
    
    canvas.width = plan.w;
    canvas.height = plan.h;
    
    // need to wait on load images - even for dataURL images.
    painter.loadImages(function(){
      // renders the whole file (even if chunked) in one go
      painter.renderImmediately(canvas.getContext('2d'))
      // if large file & is chunked
      //painter.renderDeferred(canvas.getContext('2d'), function(){ console.log('done');})
    })
  }
  
  render(document.getElementById('canvas'), window.canvgc.file);
```

## Credits

Gabe Lerner (gabelerner@gmail.com) - http://code.google.com/p/canvg/

Michael Thomas - https://code.google.com/p/jscapturecanvas/

## Thank You

To the authors of all of the projects on which this depends & is built upon.
