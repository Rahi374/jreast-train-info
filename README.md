# JR East Train Info

A program that allows AJAX (or HTTP) requests to retrieve JR East train statuses.

### Introduction

When I was making my home noticeboard (https://github.com/Rahi374/home-noticeboard), one of the things I wanted to be displayed was which trains are late, but the JR East sites don't have an API for it and all the other sites that have such information are crowd-sourced and aren't too accurate, or are incomplete. (Also the JR East app is very slow and it takes one train station to load the information.) So, I decided to write this program that will reply with JSON the train statuses when requested for it!

Also JR East doesn't allow me to distribute the train status information from their page so the server will only be available in my internal network, so if you want this too, set it up in an internal network. Or feel free to publish it to the internet. It's not likely JR will find you and sue you.

It shouldn't be that hard to transform this code to cover other train organizations. I don't usually use trains of other companies so that's why I haven't covered them.

Also note that at the moment, half of the information is in Japanese and the other half is in English. I'll add strict single-language support when I do refactor this code later.

### Requirements

- ruby (I used 2.1.5, but I think any version should be fine.)
- nokogiri
- sinatra
- sinatra-contrib (This is needed for sinatra/json)
- sinatra-cross_origin

`bundle install` from this repo should do the trick, now that I've added a Gemfile (2017-05-14).

### Installation

~~Get all the above dependencies, git clone this repo, then `ruby server.rb`.~~

git clone this repo, `bundle install`, then `ruby server.rb`

### Usage

Make an AJAX (or HTTP) request to ~~`localhost:4567/status/train_name`.~~ `localhost:4567/train_name` (please note the API change as of 2017-05-14).

Obviously substitute `train_name` with an actual train name. The name may either be in all-lowercase romaji or full Japanese. Check out ~~`server.rb`~~ `train_list` for the list of all the train names that can be used, and for the exact romaji spelling or exact kanji usage (at the moment it's kind of picky.).

So far I only support Kanto area JR trains.

The response will be in JSON. (I don't have any plans to support XML, but if anybody wants that, it could be arranged.)

The refactoring plans involve separating out one ruby file/module/gem to specialize in the fetching and presenting of Ruby Hashes, then a web wrapper to expose a web-based API.

### Future plans

Check out all the TODOs in `server.rb`.

The main issue right now is that in order to use this program you have to be bilingual, so that's the first thing to fix. The other major thing to fix is that the names of the trains are rather specific.

But, I think this is a good start. I managed to get the program to dispense information.

### Contributors

Paul Elder

### License

The MIT License (MIT)

Copyright (c) 2016-2017 Paul Elder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
