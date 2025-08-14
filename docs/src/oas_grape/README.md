# OasGrape

**Please note that this implementation is not yet thoroughly tested and is in an early stage. If you encounter any issues or have suggestions, feel free to open a GitHub issue, pull request (PR), or discussion [here](https://github.com/a-chacon/oas_grape).**

The usage can be a bit tricky. Unlike other frameworks, this cannot be implemented as a simple method comment because Grape does not use methods—only lambdas that are called and loaded once. As a result, live reloading of documentation does not work here.

## Usage

As mentioned earlier, the implementation in Grape differs from other frameworks. The tag comments must be placed inside the `detail` key of a `desc` block. Everything inside this key is parsed as a comment, and this is where the OAS YARD tags should be included.

Example:

```ruby
  desc "Returns a list of Users." do
    detail <<~OAS_GRAPE
      # @summary Returns a list of Users.
      # @parameter offset(query) [Integer] Used for pagination of response data. default: (0) minimum: (0)
      # @parameter limit(query) [Integer] Maximum number of items per page. default: (25) minimum: (1) maximum: (100)
      # @parameter status(query) [Array<String>] Filter by status. enum: (active,inactive,deleted)
      # @parameter X-front(header) [String] Header for identifying the front. minLength: (1) maxLength: (50)
      # @response Success response(200) [Array<Hash{ id: Integer}>]
      # @response_example Success(200)
      #   [ JSON
      #     [
      #       { "id": 1, "name": "John", "email": "john@example.com" },
      #       { "id": 2, "name": "Jane", "email": "jane@example.com" }
      #     ]
      #   ]
      # @tags Users, Public
    OAS_GRAPE
  end
  get do
    { users: @@users }
  end
```
