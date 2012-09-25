Server
======
The server process has three main responsabilities.
* serve assets
* act as a space api proxy
* broadcast events

Asset Serving
-------------
Client side assets are served via views and connect assets.

Socket.io
---------
The server listens to for socket.io connections (in events.coffee) and communicates with the client to keep them up to date.

### Messages
At the moment the only messages sent are twitter related:
* `recent tweet` sent to initialize clients with the recent tweets from the database.
* `new tweet` sent when a new tweet is detected.
