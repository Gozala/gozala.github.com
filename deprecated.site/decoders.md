# Decoders

_Handling user input off the UI thread_

Even though [dominion](./dominion) moved most of the JS logic off the main thread event handling still had to be performed in the UI thread creating a challenging programing model. In an attempt to resolve this inspiration was taken from [parser combinator][] libraries popular in function languages. Combination of built-in basic parsers and several combinators formed a declarative interface for defining event serializers off the main thread that was encoded as byte array of instructions executed at the event site and encoded relevant information into [flatbuffer][] and transferred it back to worker thread.



[parser combinator]:https://en.wikipedia.org/wiki/Parser_combinator
[flatbuffer]:https://google.github.io/flatbuffers/

