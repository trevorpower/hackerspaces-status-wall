Hackerspaces Status Wall
========================
A basic web page that shows the status of hackerspaces that implement the [hackerspace status API](https://hackerspaces.nl/spaceapi/).
It uses a directory API to find the available endpoints.

It is currently hosted at [hackerspaces.me](http://hackerspaces.me)

There is also an experimental [hackerspace twitter page](http://hackerspaces.me/twitter).

Client Side First
-----------------
The page will try to access all APIs on the client side using an AJAX call. Only if this fails will a server side proxy be used.

Error Reporting
---------------
A second aim of this page is to display any errors or potential problems with a particular spaces API.

Technologies Used
-----------------
* [Node.js](http://nodejs.org)
* [Express](http://expressjs.com)
* [CoffeeScript](http://coffeescript.org)
* [Jade](http://jade-lang.com)
* [Less](http://lesscss.org)
* [MongoDB](http://mongodb.org)

Playing With It
---------------
The application uses [MongoDb](http://mongodb.org) and this should be started first:

    $ mongod

There is no migration infrastructure but the `database.coffee` module exports a function `create` that will create the required collections.

To be deployable on [Heroku](http://heroku.com) a Procfile is used and the web service can be started by foreman:

    $ foreman start

Tests
-----
Tests can be run with `npm test`.
