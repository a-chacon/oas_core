# Tags

In addition to the information provided in the initializer file and the data that can be extracted from the routes and methods automatically, it is essential to document your API in the following way. The documentation is created **with the help of YARD**, so the methods are documented with **comment tags**.

## Documenting Your Endpoints

Almost every tag description in an OAS file supports **markdown formatting** (e.g., bold, italics, lists, links) for better readability in the generated documentation. Additionally, **multi-line descriptions** are supported. When using multi-line descriptions, ensure the content is indented at least one space more than the tag itself to maintain proper formatting.

For example:

```ruby
  # @request_body_example Simple User [Hash]
  #   {
  #     user: {
  #       name: "Oas",
  #       email: "oas@test.com",
  #       password: "Test12345"
  #     }
  #   }
```

You can use these tags in your controller methods to enhance the automatically generated documentation. Remember to use markdown formatting in your descriptions for better readability in the generated OAS document.

## Summary

Below is a summary of all available tags for documenting your API endpoints:

### Authentication Tags

- **`@auth`**: Specifies security mechanisms for the endpoint (e.g., `# @auth [bearer, basic]`).
- **`@no_auth`**: Removes security requirements for the endpoint (e.g., `# @no_auth`).

### Inclusion Tags

- **`@oas_include`**: Explicitly includes the endpoint in the OAS file when `include_mode` is `:explicit` (e.g., `# @oas_include`).

### Parameter Tags

- **`@parameter`**: Documents a parameter for the endpoint (e.g., `# @parameter page(query) [Integer] The page number.`).
- **`@parameter_ref`**: References a predefined parameter (e.g., `# @parameter_ref #/components/parameters/user_id`).

### Request Body Tags

- **`@request_body`**: Describes the request body (e.g., `# @request_body The user to be created [!User]`).
- **`@request_body_example`**: Provides examples for the request body (e.g., `# @request_body_example basic user [Hash] {user: {name: "Oas"}}`).
- **`@request_body_ref`**: References a predefined request body (e.g., `# @request_body_ref #/components/requestBodies/user`).

### Response Tags

- **`@response`**: Documents the endpoint's responses (e.g., `# @response User not found by the provided Id(404) [Hash]`).
- **`@response_example`**: Provides examples for responses (e.g., `# @response_example Invalid Email(422) [{success: "false"}]`).
- **`@response_ref`**: References a predefined response (e.g., `# @response_ref (200) #/components/responses/success`).

### Metadata Tags

- **`@summary`**: Adds a custom summary for the endpoint (e.g., `# @summary This endpoint creates a User`).
- **`@tags`**: Tags the endpoint for categorization (e.g., `# @tags Users, Admin`).

For detailed usage and examples, refer to the individual tag documentation files.
