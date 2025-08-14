# Installation

This guide will walk you through the steps to install and integrate the `oas_grape` gem into your Grape API project.

## Prerequisites

- A Ruby on Rails or Grape API project.
- Basic familiarity with Grape and OpenAPI Specification (OAS).

## Steps

### 1. Add the Gem to Your Project

Include the `oas_grape` gem in your `Gemfile`:

```ruby
gem 'oas_grape'
```

Run `bundle install` to install the gem.

### 2. Integrate with Your Grape API

In your main API file (e.g., `api.rb`), require the gem and mount the OAS documentation viewer:

```ruby
require "oas_grape"

module Dummy
  class API < Grape::API
    format :json

    # Mount your API endpoints
    mount Dummy::UsersAPI
    mount Dummy::NotesAPI
    # ... add other endpoints as needed

    # Mount the OAS documentation viewer
    mount OasGrape::Web::View, at: "/docs"
  end
end
```

### 3. Access the Documentation

After starting your server, navigate to `/docs` in your browser to view the interactive API documentation.
