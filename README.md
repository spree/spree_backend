<a href="https://spreecommerce.org">
   <img src="https://raw.githubusercontent.com/spree/spree-dev-docs/master/.gitbook/assets/admin_panel_978-2x.jpg" alt="Spree Commerce - a headless open-source ecommerce platform for multi-store, marketplace, or B2B global brands" />
</a>

# Spree Admin Dashboard

This is the default Spree Admin Dashboard.

## Developed by

[![Vendo](https://assets-global.website-files.com/6230c485f2c32ea1b0daa438/623372f40a8c54ca9aea34e8_vendo%202.svg)](https://getvendo.com?utm_source=spree_backend_github)

> All-in-one platform for all your Marketplace and B2B eCommerce needs. [Start your 30-day free trial](https://e98esoirr8c.typeform.com/contactvendo?typeform-source=spree_backend_github)

## Key Features

* Mobile-first - works great on any device!
* Manage Product Catalog, Orders, Customers, Returns, Shipments and all other eCommerce crucial activities
* Multi-Store support out of the box
* Built-in CMS for Pages and Navigation
* Easily add 3rd party integrations such as Payments, Tax calculation services and Shipping couriers
* Easy customization to suit your needs
* Modern tech-stack based on [Hotwire](https://hotwired.dev/) (Stimulus & Turbo)

## Demo

Fire up your own instance in the cloud:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/spree/spree_starter) <a href="https://render.com/deploy?repo=https://github.com/spree/spree_starter/tree/main">
  <img src="https://render.com/images/deploy-to-render-button.svg" alt="Deploy to Render" height=32>
</a>

Default credentials:

* login: `spree@example.com`
* password: `spree123`

## Installation

Spree Admin Dashboard is bundled with [Spree Starter](https://github.com/spree/spree_starter) and we recommend following [Spree Getting Started guide](https://docs.spreecommerce.org/getting-started/installation).

You can also [add Spree and Admin Dashboard to an existing Ruby on Rails application](https://docs.spreecommerce.org/advanced/existing_app_tutorial) as well.

## Documentation

* [Developer Documentation](https://docs.spreecommerce.org/)

## Contributing

Spree Admin Dashboard is an open source project and we love contributions in any form - pull requests, issues, feature ideas!

Please review the [Spree Contributing Guide](https://docs.spreecommerce.org/developer/contributing/quickstart)

### Local setup

1. Fork it!
2. Clone the repository
3. Create test application:

    ```bash
    cd spree_backend
    bundle install
    bundle exec rake test_app
    ```

### Running tests

Entire test suite (this can take some time!)

```bash
bundle exec rspec
```

Single test file:

```bash
bundle exec rspec spec/features/admin/users_spec.rb
```

[ChromeDriver](https://chromedriver.chromium.org/) is required for feature tests. On MacOS you can install it by running:

```bash
brew install chromedriver
```


## License

Spree Admin Dashboard is released under the [New BSD License](https://github.com/spree/spree_backend/blob/main/license.md).

[spark]:https://sparksolutions.co?utm_source=github
