

# Lunet

Project was an exploration to see how visible the goal of owning your data was within the constraints of web platform. Developed system demonstrated viability of meeting several key principals _(as per ideals for [local-first][] software)_:

#### Ultimate ownership and control of the data

Lunet loads applications into [sandboxed iframe][] with unique [origin][] _(by deriving cryptographic hash of it's source)_ and restrictive [Content Security Policies (CSP)](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-csp). This effectively disables application's networking capabilities so that no data could leave the device without your deliberate action.

#### The network is optional

Application source is saved locally on the first load. Runtime provided [service worker][], used to load it from that point on. In this setup applications do not read and modify data into the cloud, instead they read and modify your data locally in a unified library & give you a choice to share with others.

#### Security and privacy by default

Application is provided access to a space in your local library conforming [Zero Knowledge Architecture (ZKA)][ZKA]. Every piece of data gets seamlessly encrypted / decrypted when application writes / reads and is unaware of what cryptographic keys are used. This design provides security & privacy by default without application having to worry about it. It also allows leveraging existing cloud infrastructure  without surrendering data or privacy to the host.

#### The Long Now

By saving applications locally and confining them to a sandbox, that allows reading and modifying data in your library, they inherit "Old-fashioned" benefits. Continue to work as long as you keep them around and all your data remains local in your library. It also becomes possible to choose between applications that support same data format, leading to [interoperability by default](#Interoperability_by_default).

#### Interoperability by default

In order to avoid local data silos and make applications interoperable, lunet uses addressing scheme (inspired by [unix pipe notation][unix-pipe]) reflecting desired document in your library and an application operating on it. This design allows confining application sandbox to that document only and enables user to choose what application to use.

I think it is worth exploring this idea further to allow piping document through an intermediary application(s) that act as data format adapters.

#### Progressive enhancement

Web platform has no capabilities that allow devices within hands reach communicate without a cloud. That would prevent applications from offering (near) real-time collaboration off the grid. To overcome this limitation I have explored the idea of [Progressive peer-to-peer Web Applications (PPWA)](./ppwa) and integrated into lunet. Lunet runtime attempts to connect to a local native application which exposes extra capabilities (like [libdweb](./libdweb) over REST API) allowing it to establish peer-to-peer connections with nearby devices.

## Demo

Example below demonstrates [fork][peerdium-fork] of [peerdium][peerdium] loaded. And typed document saved as `Hola.quill` into local library in the `peerdium` namespace. After document is saved, address bar changes and shows that local `/peerdium/data/Hola.quill` document is being loaded by local `/peerdium/` application.

![create document](./create-document.gif)



Next we see new tab loading same document `/peerdium/data/Hola.quill`, but this time with a different, `/lunetarium/` application ([lunetarium][lunetarium] is like simple terminal app). It explores a local filesystem. Applications in lunet see own resources mapped to `/`  path and the own namespace in the library is mounted to `/data/` path. When loaded document is from different namespace it gets mapped to `/data/@` path to conceal document name and origin from the application.



![open in console](./open-in-console.gif?1)



Next we see document being modified by `/peerdium` application and modified version being then viewed    by `/lunetarium`.



![change document](./change-document.gif)



In segment below we see modifications being made by `/lunetarium` and being reflected in `/peerdium`.



![write in console](./write-in-console.gif?)





In the last segment new document is saved by `/lunetarium` and later it is loaded via `/peerdium.gozala.io` which is loaded first time from the network (although it's just a copy of the same [peerdium fork][peerdium-fork]).



![create in console](./create-in-console.gif?)



[sandboxed iframe]:https://www.html5rocks.com/en/tutorials/security/sandboxed-iframes/
[origin]:https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy
[Content Security Policies (CSP)]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-csp
[service worker]:https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers#Updating_your_service_worker
[ZKA]:https://medium.com/@vixentael/zero-knowledge-architectures-for-mobile-applications-b00a231fda75

[local-first]:https://www.inkandswitch.com/local-first.html
[unix-pipe]:https://en.wikipedia.org/wiki/Pipeline_(Unix)
[peerdium]:https://peerdium.vishnuks.com/



[peerdium-fork]:https://github.com/Gozala/peerdium/tree/lunet
[lunetarium]:https://github.com/Gozala/lunetarium