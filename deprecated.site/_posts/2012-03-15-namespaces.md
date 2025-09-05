---
layout: post
title: namespaces
tags: jetpack modules library nodejs web
---

I have [previously blogged](/2011/04/11/shareable-private-properties.html#post)
about inability of haveing properties with limited, controlled accessibility
& described a hack I prototyped to overcome this limitation. Unfortunately I
have failed to explain why one would need such properties, so I plan to explain
it in this post. In addition, we already have a [WeakMaps] in spidermonkey (and
also in V8) that made it possible to implement sharable privates in a proper
way, you'll find more details about how we did it in Add-on SDK also in this
post.

## Why do we need privates

Sometimes program is written to work with third party, potentially malicious,
code which may use variety of [attack vectors] in order to escalate
privileges and do something harmful. This is exact scenario we have in
add-on SDK, where we wrap [sudo powered] browser internals into higher level
APIs with reduced capabilities, such that by looking at add-on's module graph
we're able to say what it's capable of doing. For example if add-on only
requires [notifications module] we know that at most it can spam user with
notifications. Now if we've just stored [sudo powered] components used to
implement these API under **pseudo private** (`_` prefixed) properties we
would've had no way of saying what it's capable of. There would be no guarantee
that add-on code won't use those **pseudo privates** to wipe users hard drive
(accidentally or intentionally).

This is not the only scenario where one would need to have controlled
access to the implementation details. Any JS library may be used in an
environment where it's exposed to code that wishes to override it's behavior
by monkey-patching it's **pseudo privates**, which is absolutely fine as long
as, there is no other code that tries to do the same in a conflicting way.
It's not to say that we should be paranoid about it, it's
just there may be things that are not meant to be exposed in order to guarantee
desired behavior. 

## Controlled access via namespaces

In Add-on SDK we have a [namespace] module, that may be used to create
a namespace functions. These functions are used to access any objects
namespaced sub-objects where properties, that are not part of public interface,
may be saved:

<pre>
<span class="Identifier">let</span> <span class="Braces">{</span> ns <span class="Braces">}</span> <span class="Operators">=</span> <span class="Keyword">require</span><span class="Parens">(</span><span class="String">'namespace'</span><span class="Parens">)</span>
<span class="Identifier">let</span> foo <span class="Operators">=</span> ns<span class="Parens">()</span>

foo<span class="Parens">(</span>myObject<span class="Parens">)</span><span class="Operators">.</span>secret <span class="Operators">=</span> secret
</pre>

Now only parties that have access to both `foo` and `myObject` are capable of
seeing a `secret`. This approach allows us to create groups of internal
properties that may be shared with other components of the program by giving
access to the namespace functions. Also note that not only we can use `foo`
namespace with multiple objects, but we also can use multiple namespaces with
the same object:

<pre>
<span class="Identifier">let</span> bar <span class="Operators">=</span> ns<span class="Parens">()</span>

bar<span class="Parens">(</span>myObject<span class="Parens">)</span><span class="Operators">.</span>baz <span class="Operators">=</span> secret<span class="Operators">.</span>baz

</pre>

This way we can create namespace per role that objects play in the program and
associate properties to that objects in groups based on the roles. As a side
effect we also eliminated naming conflicts with in the role object plays as
properties are defined in different namespaces. This is very powerful, as we
can define [event emitter] and many other APIs that may work with a same object
safely no matter what's their prototypes or own properties look like and no
matter how many roles they play at the same time in program.

## Under the hood

[Implementation] under the hood is very trivial. In nutshell namespace functions
are sugared wrappers around `WeakMap` instances, each holding a reference to a
`WeakMap` instance, which are used to map objects to an associated "namespaced
sub-objects", where namespaced properties are stored. Also, since objects are
used as keys associated "namespaced sub-objects" can be claimed by garbage
collector as soon as objects are collected. As an early adopters we had to
face a [platform bug] requiring an [ugly workaround], but now it's fixed and
it's just matter of time when it ships!

## Future

While this is a good enough solution that we plan to migrate all the existing
SDK code to, it still has limitations. For example properties are instance
specific, or in other words namespaced properties of ancestors (objects in the
prototype chain) are not inherited and have to be explicitly accessed, which
may feel bit awkward:

<pre>
<span class="Identifier">let</span> decedent <span class="Operators">=</span> <span class="Type">Object</span><span class="Operators">.</span>create<span class="Parens">(</span>myObject<span class="Parens">)</span><span class="Operators">;</span>
<span class="String">'secret'</span> <span class="Statement">in</span> foo<span class="Parens">(</span>decedent<span class="Parens">)</span> <span class="Comment">// =&gt; false</span>
</pre>

In a future we may have even better solution via [private names], implementation
for spidermonkey is [in progress][private names bug] so we're looking forward!

[WeakMaps]:http://wiki.ecmascript.org/doku.php?id=harmony:weak_maps
[attack vectors]:http://code.google.com/p/google-caja/wiki/AttackVectors
[namespace]:https://addons.mozilla.org/en-US/developers/docs/sdk/latest/packages/api-utils/docs/namespace.html
[sudo powered]:http://xkcd.com/149/
[notifications module]:https://addons.mozilla.org/en-US/developers/docs/sdk/latest/packages/addon-kit/docs/notifications.html
[event emitter]:https://github.com/mozilla/addon-sdk/blob/master/packages/api-utils/docs/event/core.md
[implementation]:https://github.com/mozilla/addon-sdk/blob/master/packages/api-utils/lib/namespace.js#L31-39
[platform bug]:https://bugzilla.mozilla.org/show_bug.cgi?id=673468
[ugly workaround]:https://github.com/mozilla/addon-sdk/blob/master/packages/api-utils/lib/namespace.js#L7-20
[private names]:http://wiki.ecmascript.org/doku.php?id=harmony:private_name_objects
[private names bug]:https://bugzilla.mozilla.org/show_bug.cgi?id=645416
