# JR East Train Info

A program that allows AJAX requests to retrieve JR East train statuses.

### Introduction

When I was making my home noticeboard (https://github.com/Rahi374/home-noticeboard), one of the things I wanted to be displayed was which trains are late, but the JR East sites don't have an API for it and all the other sites that have such information are crowd-sourced and aren't too accurate, or are incomplete. (Also the JR East app is super-laggy and it takes one train station to load the information it's useless.) So, I decided to write this program that will reply with JSON the train statuses when requested for it! Hopefully it works.

Also JR East doesn't allow me to distribute the train status information from their page so the server will only be available in my internal network, so if you want this too, set it up in an internal network. Or feel free to publish it to the internet. It's not likely JR will find you and sue you.

It shouldn't be that hard to transform this code to cover other train organizations. I don't usually use trains of other companies so that's why I haven't covered them.

Also note that the information will be displayed in Japanese (for now, later I'll add an English option).

### Requirements

- Nokogiri
- Sinatra

### Installation

### Usage

### Future plans

### Contributors

Paul Elder

### License

The MIT License (MIT)

Copyright (c) 2016 Paul Elder

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
