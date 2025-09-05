# Starling

Concurrent JS Runtime aiming to achieve high-performance through modularity, parallelism & Rust interop. Runtime was formed by the components represented by `async` functions, which communicated with other components through read/write stream pairs, forming a system resembling an Erlang [Actor Model][].
Components of this system could also be represented via Async Rust primitives which meant critical components could be written in Rust to achieve even higher performance. This system was designed to complement [servo][] rendering engine that was taking parallelism to the next level.



[Actor Model]:https://en.wikipedia.org/wiki/Actor_model

[servo]:https://servo.org/