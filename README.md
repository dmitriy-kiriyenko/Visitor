# Visitor

[![Build
Status](https://secure.travis-ci.org/dmitriy-kiriyenko/Visitor.png)](http://travis-ci.org/dmitriy-kiriyenko/Visitor)

Sometimes in Ruby you need to attach the same method to various spectre
of classes. This is usually required for conversion methods when you
define `#to_big_decimal` or `to_lua` on `Numeric`, `String`, `Object`,
etc. While this way of doing things is the most Rubyish one, we don't
like reopening core classes. More, there is also a problem on how to
organize the code - by method or by class. Usually, as more natural, by
class is picked and logically one method gets split into classes. In the
meantime, If you add just one method in a gem, you reopen all core
classes. In each specific gem.

Double dispatch to the rescue!

Here we add a base class to define visitors. The core idea we owe to
[Aaron "Tendelove" Patterson](https://github.com/tenderlove)'s article
[The Double Dispatch
Dance](http://blog.rubybestpractices.com/posts/aaronp/001_double_dispatch_dance.html).
Read it - it'll give you the whole idea. We just added an option to
define visitors by string class name to aviod possible missing constants
and added a convenient `add_accept_method!` method.

## Installation

``` ruby # In your Gemfile gem 'visitor' ```

## Usage

``` ruby 
class ToJsVisitor < Visitor::Base
  # Add Object#to_js as an accept method for this visitor
  add_accept_method! :to_js, :to => [Object]

  visitor_for String do |string|
    if string =~ /`([^`]+)`/
      $1
    else
      "\"#{string}\""
    end
  end

  # This will capture all Numeric descendants
  # Even if Numeric was a module, being included to a class
  visitor_for Numeric do |number|
    number.to_s
  end

  visitor_for NilClass do |_|
    'undefined'
  end

  visitor_for Enumerable do |array|
    "[#{array.map {|o| visit o}.join(", ")}]"
  end

  visitor_for Hash do |hash|
    "{#{hash.to_a.map{|key, value| "#{key}: #{visit value}"}.join(', ')}}"
  end

  # This is kind of default visitor
  visitor_for Object do |o|
    o.to_s
  end

end
```

This is the real code example from [to_js
gem](https://github.com/dmitriy-kiriyenko/to_js).

## TODOs
* Add documentation. While it's missing - read the
  [tests](https://github.com/dmitriy-kiriyenko/Visitor/blob/master/spec/lib/visitor/base_spec.rb).

## Authors
* [Dmitriy Kiriyenko](https://github.com/dmitriy-kiriyenko)
* [Maxim Tsaplin](https://github.com/maxtsap)

## Contribution
* Use and give feedback
* Submit an issue
* Provide a pull request
* Bring your testimony on why visitors in Ruby suck and are totally
  unnecessary

## Licence
[MIT](https://github.com/dmitriy-kiriyenko/Visitor/blob/master/MIT-LICENCE)
([more about it](http://en.wikipedia.org/wiki/MIT_License))

## Tests
* Run with rake
* Tested in 1.8.7, 1.9.2, 1.9.3. Thank you,
  [travic-ci](http://travis-ci.org/) guys, you are awesome.

## Credits
* [Aaron "Tendelove" Patterson](https://github.com/tenderlove) with [The
  Double Dispatch
Dance](http://blog.rubybestpractices.com/posts/aaronp/001_double_dispatch_dance.html)
* [Gang of Four](http://en.wikipedia.org/wiki/Design_Patterns)
