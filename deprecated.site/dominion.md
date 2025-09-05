# Dominion

Running complex UI logic in JS on the UI thread means dropping a frame sooner or later. [Servo][]s parallelize everything approach and raising popularity of Virtual DOM libraries inspired project to push UI code into worker thread(s). Library provided familiar programming model in which view (Virtual DOM) is computed from the application state. Other attempts to accomplish that, required Virtual DOM to be serialized / deserializer across threads and lead to poor performance. Here Virtual DOM changes were represented as byte code instructions in a compact [flatbuffer][] which could be transferred across threads without memory copying (Initial Virtual DOM tree itself was represented as byte code of changes to an empty tree).

This approach still required some code on the UI thread to execute byte code, however it was significantly less code which was highly optimized and did not required memory allocations (so on GC pauses). There was also expectation that [WHATWG DOMChangeList proposal][changelist-proposal] would eventually remove the need for that bit of the code.

This architecture also enabled parallel UI logic by splitting work across multiple worker threads (each operating on separate piece of UI). However there were some challenges as well which lead to development of [Decoders][] library.

[flatbuffer]:https://google.github.io/flatbuffers/
[Decoders]:./decoders
[Servo]: https://servo.org
[changelist-proposal]:https://github.com/whatwg/dom/issues/270