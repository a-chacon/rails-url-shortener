# RailsUrlShortener

RailsUrlShortener is a small rails engine that provide your app with short URLs functionalities. Like a Bitly on your app. By default, RailsUrlShortener save the visits to your link for future interesting things that you may want to do.

Why give your data to a third party app if you can do it by yourself?

You can see a **demo project** of what you can do with this engine [HERE](https://paso.fly.dev/).

## Key features

A few of the things you can do with RailsUrlShortener:

* Generate unique keys for links.
* Provide a method controller that find, save request information and does a 301 redirect to the original url.
* The short links can be associated with a model in your app.
* Save interesting things like browser, system and ip data of the 'un-shortened' request.
* Temporal short links using the expires_at option.
* Get IP data from third part service.

## Usage

### 1. Mount the engine

Mount the engine on your app adding the next code on your config/routes.rb:

**If you want to mount this on the root of your app, this should be on the bottom of your routes file.**

```ruby
mount RailsUrlShortener::Engine, at: "/"

```
### 2. Generate the short link

And generate the short links like you want:

 - Using the helper method, this return the ready short link.

```ruby
short_url("https://www.github.com/a-chacon/rails-url-shortener")
```

 - Or model method, this return the object built. So you can save this on a variable, extract the key and build the short link by your own:

```ruby
RailsUrlShortener::Url.generate("https://www.github.com/a-chacon/rails-url-shortener")
```
### 3. Share the short link

**Then share the short link to your users or wherever you want.**

## Deeper

Full params for the short_url helper:
```ruby
short_url(url, owner: nil, key: nil, expires_at: nil, category: nil, url_options: {})
```
Where:
* **url**: Long url for short.
* **owner**: Is a model of your app. You can relate an url whatever you want in your app.
* **key**: Is a custom key that you want to set up.
* **expires_at**: Is a datetime for expiration, after this the redirection doesn't work.
* **category**: Tag that you want for that link.
* **url_options**: Options for the url_for generator. Ex: subdomain or protocol.


And the same for the generate model method except for url_options:
```ruby
RailsUrlShortener::Url.generate(url, owner: nil, key: nil, expires_at: nil, category: nil)
```

### Data saved

By default, this engine save all request made on your short url, you can use that data for some analytics or simple IP logger. So for get the data in a controller or do wherever you want, you can use the Visit model related to an Url:

```ruby
RailsUrlShortener::Url.find_by_key("key").visits # all visits

```
Or using the model class:
```ruby
RailsUrlShortener::Visit.all # all in database
```

And a Visit is related to a Ipgeo model that contain information about the ip, so you can view this using the active record relation:
```ruby
RailsUrlShortener::Visit.first.ipgeo # Ipgeo object that contain information of the ip
```

### Ip data

When a Visit record is created, a job is enqueue for get Ip data from [this](https://ip-api.com/) service and create the Ipgeo record. It is integrated to the free endpoint, so if you think that you have more than 45 different IPS querying in a minute to your app, we need to think in a new solution.

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

And finally install & run the migrations on your project and migrate:
```bash
bin/rails rails_url_shortener:install:migrations db:migrate
```

For the configurations generate the initializer whith this:

```bash
rails generate RailsUrlShortener:initializer
```
**Here is important to configure the host at least if your are not running your app in localhost**

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
The gem is available as open source under the terms of the [GPL-3.0 License](https://www.github.com/a-chacon/rails-url-shortener/blob/main/LICENSE).

by: [a-chacon](https://a-chacon.com)
