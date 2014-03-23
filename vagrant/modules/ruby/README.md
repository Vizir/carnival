Puppet Ruby Module
==================

Module to install Ruby from source. Allows versions of Ruby to be installed for which a package may not exist.

Tested on Ubuntu 12.10 with Puppet 2.7. Patches for other operating systems welcome.

Installation
------------

Clone this repo into your Puppet `modules` directory:

    git clone git://github.com/lucaspiller/puppet-ruby.git modules/ruby

Usage
-----

To install and configure Ruby, include the module:

    include ruby

You can override defaults in the Ruby config by including
the module with this special syntax:

    class { ruby: version => '2.0.0-p0' }

This module uses [ruby-build][ruby-build] to install Ruby and any related tools (e.g. Rubygems), as such it supports any of the [definitions ruby-build supports](https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build). For example to instal Ruby Enterprise Edition:

    class { ruby: version => 'ree-1.8.7-2011.12' }

It doesn't deal with other dependencies though, so if you want to use JRuby you'll need to install a JRE first.

Updating Ruby
-------------

To update Ruby, just change the version in the class (see above), and on the next run it will install the new version and setup links. It will also update [ruby-build][ruby-build] if needs be so that latest manifest files will be there. Be careful with any apps that you have depending on gems installed to this ruby. Web servers (as long as they are not restarted) should be fine, but cron jobs may be an issue. Make sure to test it on staging first :)

Footnotes
-----------

This will also install [Bundler](http://gembundler.com/), and setup alternatives so that `/usr/bin/ruby` points to this version. If you don't like that feel free to fork it and make it optional, I'll happily accept a pull request for this. [ruby-build][ruby-build] will be installed into `/opt/ruby-build`.

License
-------

Released under the *MIT License*, see [LICENSE.md](LICENSE.md) for details.


[ruby-build]: https://github.com/sstephenson/ruby-build "sstephenson/ruby-build"
