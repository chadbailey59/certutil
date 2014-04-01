# Certutil

This is a tool I developed after dealing with a lot of SSL certificates in Heroku Support.

## Installation

Just `gem install certutil` to install it.

`rbenv rehash` if you're using rbenv. You might have to do something to RVM to get it to show up there; honestly I can't remember.

## Usage

This app uses locally saved certificate files (ones that look like `---BEGIN CERTIFICATE---`), or it can fetch them from a live site directly.

Just run `certutil file.crt` for a local file, or `certutil google.com` to get the cert from the web.

By default, the app parses the cert chain and displays a decoded version of the entire chain. See `certutil --help` for more options, or `rake features` to see some example use cases.

