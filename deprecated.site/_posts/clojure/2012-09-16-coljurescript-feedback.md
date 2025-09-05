---
layout: post
title: (feedback :clojurescript)
tags: clojure clojurescript cljs feedback
published: true
---

Lately I have being very entusiastic about [clojurescript][], but I keep running
into small annoyances that I just can not get over with. I think it may be useful
to provide a feedback form a user who's primary language for the past decade was
JS, which brings me to a folloing point:


## 1. Enable github issues

At the moment [clojure discussion group][] is the only place for providing feedback.
Group is very active and it's **clojure** (not **clojurescript**) discussion group
so most of the discussions are not really relevant to me. I find keeping up with all
the noise there hard, and would personally have created bunch of issues reports 
already if I could have submitted them on github.


## 2. Accessing properties with computed names

I find API for accessing properties with computed names awkward:

    #!env/scheme
    (aget js/require.extensions ".cljs")

At least because documentation of [get][] function, matches better
my intent then [aget][]'s. Also I find use case common enough, that I
think a syntax sugar would be more appropriate.


## 3. Setting properties with computed names

API for setting properties with computed names is even clunkier:


    #!env/scheme
    (set! (aget js/require.extensions ".cljs") compile)
    

I think extending [set!][] special form would make a lot more sense:


    #!env/scheme
    (set! js/require.extensions ".cljs" compile)
        


## 4. Regural expressions

I really enjoy how simple regular expressions translate to JS:


    #!env/scheme
    #"[^a-z\s]" ;; => /[^a-z\s]/


Although I could not find any way to create regular expressions with
[advance search flags][regexp search flags], other then by using `RegExp`
constructor:


    #!env/scheme
    (js/RegExp. "\\w+\\s" "g")        ;; => /\w+\s/g
    (js/RegExp. "^\\-\\-\\w*$" "m")   ;; => /^\-\-\w*$/m
    (js/RegExp. "foo" "i")            ;; => /foo/i


I wish literal syntax had support for search flags, maybe even via [clojure tags][].


## 5. Try / catch

In clojure and inherently clojurscript `catch` clause of the `try` special form
takes error type, error name and expressions:

    #!env/scheme
    ;; for Clojurescript use js/Object as type
    (try
       (/ 1 0)
       (catch js/Object e
           (.log js/console e)))

I do understad that it makes sence on JVM, but it definitely does not on JS.
I really wish that error type was either optional or was removed entirely in
clojurescript.


## 7. Less dependency on JVM

While I fully understand rational behind dependency on [JVM][], it's still
painful for someone coming from JS who's not comfortable with configuring
class paths. Tools like [leiningen] also spend more time on booting JVM then on
performing actual tasks. I think clojurscript could be significally
more successful among JS developers if they could strat witout any dependencies
(even if they will have to deal with them later once they're more comfortable).



Overall I'm pretty happy with clojurscript, it's pretty young project and I hope
it will only get better and more accessible over time!

[clojurescript]:https://github.com/clojure/clojurescript/ "Clojure for JS"
[clojure discussion group]:https://groups.google.com/forum/?fromgroups#!forum/clojure
[get]:http://clojure.github.com/clojure/clojure.core-api.html#clojure.core/get "Returns the value mapped to key, not-found or nil if key not present."
[aget]:http://clojure.github.com/clojure/clojure.core-api.html#clojure.core/aget "Returns the value at the index/indices."
[set!]:http://clojure.org/special_forms#set "set! special form"
[Regular_Expressions]:https://developer.mozilla.org/en-US/docs/JavaScript/Guide/Regular_Expressions?redirectlocale=en-US&redirectslug=Core_JavaScript_1.5_Guide%2FRegular_Expressions
[regexp search flags]:https://developer.mozilla.org/en-US/docs/JavaScript/Guide/Regular_Expressions?redirectlocale=en-US&redirectslug=Core_JavaScript_1.5_Guide%2FRegular_Expressions#Advanced_Searching_With_Flags
[clojure tags]:https://github.com/edn-format/edn#tagged-elements
[JVM]:http://en.wikipedia.org/wiki/Java_virtual_machine "Java virtual machine"
[leiningen]:https://github.com/technomancy/leiningen "Clojure package manager"