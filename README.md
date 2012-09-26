Hackerspaces Status Wall
========================
A basic web page that shows the status of hackerspaces that implement the [hackerspace status API](https://hackerspaces.nl/spaceapi/).
It uses a directory API to find the available endpoints.
Displays recent tweets from spaces.

It is currently hosted at [hackerspaces.me](http://hackerspaces.me)

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

There is no migration infrastructure but the database can be created with the following command:

    $ coffee tasks/create_database.coffee

To be deployable on [Heroku](http://heroku.com) a Procfile is used and the web service can be started by foreman:

    $ foreman start

Tests
-----
[![Build Status](https://secure.travis-ci.org/trevorpower/hackerspaces-status-wall.png)](http://travis-ci.org/trevorpower/hackerspaces-status-wall)
Some integration tests connect to a database and so the mongo daemon should be started first:

    $ mongod

All tests can be run with:

    $ npm test

