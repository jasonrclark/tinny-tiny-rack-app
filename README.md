# tinny-tiny-rack-app
One of my favorite pieces of the Ruby ecosystem is Rack. Coming from .Net and
Java, the idea of a web application in so few lines of code was a revelation
when I first saw it.

But the frameworks layered on top of Rack often obscure this simple beauty.
This repository is an experiment in peeling back to the most basic layer, then
building up by very small increments to see where we get.

Come along, and see how simple web development with Ruby can be!

## How to Use This Repository
The [commits in this repository](https://github.com/jasonrclark/tinny-tiny-rack-app/commits/master)
tell the story of how a web app is built atop Rack. Follow them in order to see
how things grow, or jump around to see what's interesting to you.

## Installation
Before you get going, execute each of these commands in a terminal:

```
$ git clone git@github.com:jasonrclark/tinny-tiny-rack-app.git
$ cd tinny-tiny-rack-app
$ gem install rack
```

To run the application at each point, run this command:

```
rackup
```

Then you can visit [http://localhost:9292](http://localhost:9292) in your
browser to see the app running. You'll have to shut down the server with Ctrl+C
any time you make a change to the code or move to another commit.

Enjoy!
