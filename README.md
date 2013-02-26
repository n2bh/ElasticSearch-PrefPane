ElasticSearch-PrefPane
======================

ElasticSearch Preference Pane for Mac OS X

A simple System Preferences pane for starting and stopping the ElasticSearch daemon.

![Screenshot](https://raw.github.com/entropillc/ElasticSearch-PrefPane/master/Images/ScreenShot.png)

Installation
------------

* Download the ElasticSearch-PrefPane.dmg disk image from the ./Build/Release folder
* Mount the disk image and double-click ElasticSearch.prefPane inside it to install

Configuration
-------------

By default, the settings provided will get you up and running if you installed ElasticSearch
using Homebrew. However, if necessary, you can simply change the location of the ElasticSearch
binary as well as the location for the PID file and any arguments you want passed to the
ElasticSearch daemon.

Credits
-------

[mongodb-prefpane](http://github.com/ivanvc/mongodb-prefpane)
[DaemonController](http://github.com/ivanvc/DaemonController)

Based off of the mongoDB prefpane by [Iván Valdés](http://github.com/ivanvc)

Original DaemonController and MBSliderButton based in the ones made
by [Max Howell](http://github.com/mxcl)
