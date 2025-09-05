---
layout: post
title: Shareable private properties
tags: commonjs library namespaces privates
---

In JavaScript it is not possible to create properties that have limited or
controlled accessibility. It is possible to create non-enumerable and
non-writable properties, but still they can be discovered and accessed.
Usually so called "closure capturing" pattern is used to encapsulate such
properties in lexical scope:

<script src="https://gist.github.com/915169.js?file=closure-capturing.js">
function Base(options) {
  var _secret = options.secret
  this.hello = function hello() {
    return 'Hello ' + _secret
  }
}

function Decedent(options) {
  var _secret = options.secret
  Base.call(this, options)
  this.bye = function bye() {
    return 'Bye ' + _secret
  }
  this.boom = function boom() {
    _secret = 'boom !'
  }
}
Decedent.prototype = Object.create(Base.prototype)
</script>

Unfortunately given approach does not works very well with OO inheritance:

1. Code readability degrades and some code duplication becomes necessary.  
   _(See firs lines of `Base` and `Decedent` constructors)_.
2. Prototypes do not contain any properties and there for each instance gets
   it's own fresh copy of them.  
   _(Not very good for performance)_.
3. Own and inherited methods access different copies of private properties and
   there for changes do not propagate.  
   _(`boom` method of `Decedent` illustrates the issue).
4. Access to a private properties can not be shared with a limited group.

I believe because of these reasons "`-`" prefix was established as a "de facto"
standard for private property names. Unfortunately it's just a coding style that
does not implies any property access restrictions.

In Jetpack we've explored [different techniques][cortex] to overcome issues
mentioned above, but property access sharing to the limited groups of consumers
remained painful and unobvious.

Recently I got an [interesting idea] inspired by [private names proposal] for
ECMAScript _(I recommend to reading [Allen Wirfs blog post] explaining details
of the proposal)_. Here is an illustration of the idea with a same example:

<script src="https://gist.github.com/915169.js?file=idea.js">
var KEY = {};   // key for accessing private properties.

function Base(options) {
  // Defining all the private properties on the local object.
  var privates = { secret: options.secret }
  // Override `Object.prototype.valueOf` to share access to the private
  // properties with a limited group of consumers who has an access to the
  // `KEY`.
  this.valueOf = function valueOf(key) {
    // If consumer has a right `key` we give access to our private properties,
    // otherwise we fall back to a default behaviour.
    return key === KEY ? privates : Object.prototype.valueOf.call(this)
  }
}
Base.prototype.hello = function hello() {
  return 'Hello ' + this.valueOf(KEY).secret
}

function Decedent(options) {
  Base.call(this, options)
}
Decedent.prototype = Object.create(Base.prototype)
Decedent.prototype.bye = function bye() {
  return 'Bye ' + this.valueOf(KEY).secret
}
Decedent.prototype.boom = function boom() {
  this.valueOf(KEY).secret = 'boom !'
}
</script>

Please note that this solves all the issues outlined. Also access to the
privates can be shared with any group, just by giving them a `KEY`. After
tinkering with this idea for some time, I'm happy to announce birth of
[namespace] micro-library. Below you can see same example, but this time coded
as a commonjs module and using mentioned library:

<script src="https://gist.github.com/915169.js?file=fiddle.js">
define('demo', function(require, exports, module, undefined) {

'use strict'

// importing library.
var Namespace = require('http://jeditoolkit.com/namespace/lib/namespace.js').Namespace
// Creating namespace for private properties.
var _ = new Namespace

function Base(options) {
  _(this).secret = options.secret
}
Base.prototype.hello = function hello() {
  return 'Hello ' + _(this).secret
}

function Decedent(options) {
  Base.call(this, options)
}
Decedent.prototype = Object.create(Base.prototype)
Decedent.prototype.bye = function bye() {
  return 'Bye ' + _(this).secret
}
Decedent.prototype.boom = function boom() {
  _(this).secret = 'boom !'
}

var base = new Base({ secret: 'Father' })

alert(base.secret)      // -> undefined
alert(base.hello())     // -> 'Hello Father'

var decedent = new Decedent({ secret: 'Yoda' })

alert(decedent.hello())   // -> 'Hello Yoda'
alert(decedent.bye())     // -> 'Bye Yoda'
decedent.boom();

alert(decedent.hello())   // -> 'Hello boom !'
alert(decedent.bye())     // -> 'Bye boom !'

})

// Loading module "demo"
require.main("demo")
</script>

Library not only wraps outlined idea into a nice API, but also allows provides
a way to use multiple namespaces with the same object.

Finally here is a [jsfiddle link] containing this example if you wan to play
with it. Of course comments / feedback / ideas is more then welcome!

[namespace]:https://github.com/Gozala/namespace
[Cortex]:https://jetpack.mozillalabs.com/sdk/1.0b4/docs/packages/api-utils/docs/cortex.html
[Allen Wirfs blog post]:http://www.wirfs-brock.com/allen/posts/32
[private names proposal]:http://wiki.ecmascript.org/doku.php?id=strawman:private_names
[interesting idea]:https://github.com/mozilla/addon-sdk/blob/fe8f35933c5f71b3fdc698e6768d9e51e6b5ad4e/packages/addon-kit/lib/context-menu.js#L342-348
[jsfiddle link]:http://jsfiddle.net/gh/gist/jquery/edge/915169/
