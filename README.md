# RailsUrlShortener

A small rails engine for short urls.
It could be used like a url shortener or a ip logger, it is your choice.
The app generate a short url for you and then (if you want) receive the requests and redirect to the long url.

Why give your data to a third party app if you can do it?

## Usage

Mount the controller on your app adding the next code on your config/routes.rb:

```ruby
mount RailsUrlShortener::Engine, at: "/rus"

```

And generate the short links wherever you want using the method model provided for this engine:

```ruby
RailsUrlShortener::Url.generate("https://www.someurl.com")
```

So the thing is, this last method return to you something like `http://localhost:8080/rus/Abs2nd` and that address point to the original url

### Deeper

By default this engine save all request made on your short url, you can use that data for some analitics or simple ip logger. So for get the data in a controller or do wherever you want you can use the Visit model related to a Url:
```ruby
RailsUrlShortener::Url.find_by_key("key").visits # all visits
RailsUrlShortener::Url.find_by_key("key").visits.browser(:firefox) # only where user_agent indicate a firefox browser

```
Or using the model class:
```ruby
RailsUrlShortener::Visit.all # all in database
```

Also the Url model has a polymorphic relation with an owner that is optional. So you can relate an url whatever you want in your app adding the next relation in a model:
```ruby
has_many :urls, as: :owner
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "rails_url_shortener"
```

Or install it yourself as:
```bash
$ gem install rails_url_shortener
```

Then execute:
```bash
$ bundle
```

And finally copy the migrations and migrate:
```bash
$ bin/rails rails_url_shortener:install:migrations db:migrate
```

If you want the initializer for configurations do:

```bash
$ rails generate RailsUrlShortener:initializer
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
