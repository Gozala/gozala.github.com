# TomTom Go Live 1000

I was part of the team developing user interface for new generation TomTom Personal Navigation Device (PDA) with a new WebKit-based UI toolkit. Team was developing and testing on [iPhone 3G][] (powerhouse at time) before hardware was made available. And once we got our hands on the hardware we discovered that our work which run silky smooth on iPhone was barely useful and ofter took down the system.

This lead me to designing and implementing a high performance JS framework, employing range of techniques to make best use of available resources. GC interference had significant impart, framework addressed this via pre-allocated object pools. Surprisingly high overhead caused by native DOM event propagation was removed by use of custom event handling subsystem. Development of reactive data bindings into framework significantly reduced amount of JS code freeing CPU cycles.

After all this optimizations we have eaten our own dog food and rode from headquarters in Amsterdam to FOSDEM in Brussels.

Fun fact: _TomTom end up releasing device with much better hardware although that was after I had left the company._ 

**![](./MXYbKlE.png)**

Apart from aggressive optimizations developed framework had enabled some novel tooling. Due to reactive design and custom event system all the IO end up going through a single message channel. This gave me some interesting ideas:

### Remote Debugging

Remote debugging was not a thing back then. However since all the IO occurred through a message channel it was fairly easy to expose that channel via HTTP. By loading same UI code which used exposed HTTP channel in Safari become debuggable and inspectable.

### Record / Replay

By capturing all the messages on the IO channel in the session, it became possible to reproduce all the interactions by replying them. This lead me to develop a record/reply tool that QA team used to report bugs with a reproducible record. Replay enabled development team to reproduce bugs and fix them after which records were added to the test harness to catch possible regressions.