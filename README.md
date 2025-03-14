# RailsUrlShortener

RailsUrlShortener is a small Rails engine that provides your app with short URL functionality and IP logging capabilities - like having your own Bitly service. By default, RailsUrlShortener saves all visits to your links for future analysis or other interesting uses.

Why give your data to a third-party app when you can manage it yourself?

You can see a **demo project** of what you can do with this engine [HERE](https://paso.fly.dev/).

## Key Features

Here are some of the things you can do with RailsUrlShortener:

* Generate unique keys for links
* Provide a controller method that finds, saves request information, and performs a 301 redirect to the original URL
* Associate short links with models in your app
* Save browser, system, and IP data from each request
* Create temporary short links using the expires_at option
* Get IP data from a third-party service

## Installation

Follow these steps to install and configure RailsUrlShortener:

1. Add this line to your application's Gemfile:

```ruby
gem "rails_url_shortener"
```

2. Install the gem by running:

```bash
bundle install
```

3. Install and run the migrations:

```bash
bin/rails rails_url_shortener:install:migrations db:migrate
```

4. Generate the initializer for configuration:

```bash
rails generate rails_url_shortener
```

## Usage

1. Mount the engine

Mount the engine on your app adding the next code on your config/routes.rb:

**If you want to mount this on the root of your app, this should be on the bottom of your routes file.**

```ruby
mount RailsUrlShortener::Engine, at: "/"

```

2. Generate the short link

And generate the short links like you want:

* Using the helper method, this return the ready short link.

```ruby
short_url("https://www.github.com/a-chacon/rails-url-shortener")
```

* Or model method, this return the object built. So you can save this on a variable, extract the key and build the short link by your own:

```ruby
RailsUrlShortener::Url.generate("https://www.github.com/a-chacon/rails-url-shortener")
```

3. Share the short link

**Then share the short link to your users or wherever you want.**

## Deeper

Full params for the short_url helper:

```ruby
short_url(url, owner: nil, key: nil, expires_at: nil, category: nil, url_options: {})
```

Where:

* **url**: The long URL to be shortened
* **owner**: A model from your app to associate with the URL
* **key**: A custom key for the short URL (optional)
* **expires_at**: Expiration datetime (after which the redirect won't work)
* **category**: A tag for categorizing the link
* **url_options**: Options for the URL generator (e.g., subdomain or protocol)

The `generate` model method accepts the same parameters except for `url_options`:

```ruby
RailsUrlShortener::Url.generate(url, owner: nil, key: nil, expires_at: nil, category: nil)
```

### Data Collection

By default, the engine saves all requests made to your short URLs. You can use this data for analytics or IP logging. To access the data:

1. Get visits for a specific URL:

```ruby
RailsUrlShortener::Url.find_by_key("key").visits
```

2. Get all visits:

```ruby
RailsUrlShortener::Visit.all
```

Each Visit is associated with an Ipgeo model that contains information about the IP address:

```ruby
RailsUrlShortener::Visit.first.ipgeo
```

### IP Data Collection

When a Visit record is created, a background job is enqueued to fetch IP data from the [ip-api.com](https://ip-api.com/) service and create an Ipgeo record. This uses the free endpoint, which has a limit of 45 different IPs per minute. If you expect higher traffic, you'll need to implement an alternative solution.

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
