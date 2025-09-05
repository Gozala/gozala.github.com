# TomTome Home (in the Cloud)

In the days when no devices were internet connected, uploading/upgrading content required additional desktop software. TomTom Home was an example of such software, which in nutshell was a marketplace for map data that I was hired to work on.

Apart from obvious usability issues, maintenance and feature development for such a cross-platform software seems absurd from todays lens. At a time me and my college had an idea to replace it with a web application for which we have developed a proof of this concept.

In order to upload / upgrade content on the device (or even tell if it was connected via USB) we have [embedded an HTTP server](https://en.wikipedia.org/wiki/Mongoose_(web_server)?wprov=sfti1) exposing a REST API that was then used by a web application recreating functionality of TomTom Home in the cloud. This improved user experience by removing software install step and greatly improved process of new feature rollouts due to web deployment.

