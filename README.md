canvgc
=============

What
-------
canvgc is a server-side tool for compiling SVG to html5 CanvasRenderingContext2D commands.

Produces a JS file which can be included client side - and when combined with the painter - can reproduce the svg on any canvas rendering context.

Uses Canvg to translate the SVG to canvas commands, and a custom shim based from jsCaptureCanvas to convert into a single set of commands.

Why
-------

Current browsers have issues with SVG support on canvas.

Both IE & Firefox will only raster the SVG once (so scale/transform will be applied to the raster, not the vectors), and Webkit SVG performance has been steadily dropping.

