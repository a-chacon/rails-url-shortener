# RailsUrlShortener

A small rails engine for short urls.
It could be used like a url shortener or a ip logger, it is your choice.
The app generate a short url for you and then (if you want) receive the requests and redirect to the original url.

Why give your data to a third party app if you can do it by yourself?

## Usage

Mount the controller on your app adding the next code on your config/routes.rb:

```ruby
mount RailsUrlShortener::Engine, at: "/"

```

And generate the short links wherever you want using the helper method:

```ruby
short_url("https://www.github.com/a-chacon/rails_url_shortener")
```

or model method:

```ruby
RailsUrlShortener::Url.generate("https://www.github.com/a-chacon/rails_url_shortener")
```

**Then share the short link.**

### Deeper

By default this engine save all request made on your short url, you can use that data for some analitics or simple ip logger. So for get the data in a controller or do wherever you want you can use the Visit model related to a Url:
```ruby
RailsUrlShortener::Url.find_by_key("key").visits # all visits

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
gem install rails_url_shortener
```

Then execute:
```bash
bundle
```

And finally install the migrations on your project and migrate:
```bash
bin/rails rails_url_shortener:install:migrations db:migrate
```

If you want the initializer for configurations do:

```bash
rails generate RailsUrlShortener:initializer
```

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
