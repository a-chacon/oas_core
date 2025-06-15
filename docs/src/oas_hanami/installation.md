# Installation

1. Add this line to your Hanami application's Gemfile:

   ```ruby
   gem "oas_namai"`
   ```

2. Execute:

   ```bash
   bundle
   ```

3. Mount the engine in your config/routes.rb file **at the bottom of all routes** to ensure it doesn't interfere with your application's routing:

   ```ruby
    mount OasHanami::Web::View, at: "/docs"
   ```

4. **The most important step:** add the route inspector before starting the app.
   It can be do in your `config.ru` file:

    ```ruby
    require "hanami/boot"

    Hanami.app.router(inspector: OasHanami::Inspector.new) # set before run the app.

    run Hanami.app
    ```

You'll now have **basic documentation** based on your routes and automatically gathered information at `localhost:2300/docs`. To enhance it, create an initializer file and add [Yard](https://yardoc.org/) tags to your controller methods.
