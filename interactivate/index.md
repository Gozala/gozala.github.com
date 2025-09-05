---
title: Interactivate: Live coding playground
date: 2012-11-12
---

#  Interactivate

Live-coding playground experiment was inspired by [Mathematica Notebook][] & [Bret Victor][]’s "[Inventing on Principle][]" talk.

> I write JS & HTML code every single day. I can’t imagine doing this without a Read Eval Print Loop ([REPL][]). [Firefox scratchpad][] made me realize that I hate a **loop** part of [REPL][]! 
>
> Effort it take to get a glimpse of an idea live on a screen is just too hight. Creating HTML & JS files, wiring them with one another, page refreshes, etc… I am sure we can do a lot better & I hope to convince you with this proof of concept.

Core principal of this tool is to stay out of your way, it has no UI controls, bells or whistles. Just a code editor where you type JS code (like snippet below) and signal it to print out specific expressions via special line comment  `//=>`. Tool picks those up ripples stylized evaluation results in place of comments _(For code below it will show `Out[0] = [ 0, 1, 1, 2, 3, 5, 8, 13 ]` in place of a line comment)_

```javascript
function fibs(n) {
  var result = [0, 1]
  while (result.length < n) {
    var count = result.length
    result.push(result[count - 2] + result[count - 1])
  }
  return result.slice(0, n)
}

fibs(8)

// =>
```

This allows you to navigate up and down the source code with your keyboard, just like you would in a regular code editor. Output ripples are kind of overlays for the `// =>` line comments, if you stop a caret on the comment line, ripple will disappear revealing commented line. Code changes update rippled outputs live.

This is in browser environment so you have HTML to play with as well. If print expression is an HTML element ripple will render it inline, so you can build UIs style them etc...

If you would like to get a feel for it please give this [demo][] page a try. You can also watch a my video walkthrough embedded below.



<video src="Interactivate.mp4"></video>



[Interactivate-dat]:./interactivate-dat
[Bret Victor]:http://worrydream.com/
[Inventing on Principle]:https://vimeo.com/36579366
[Mathematica Notebook]:https://en.wikipedia.org/wiki/Wolfram_Mathematica#The_Notebook_interface
[Demo]:https://gozala.io/interactivate/demo/
[REPL]:http://en.wikipedia.org/wiki/Read–eval–print_loop "Read Eval Print Loop"
[Firefox scratchpad]:https://commons.wikimedia.org/wiki/File:Firefox_10_Scratchpad.png