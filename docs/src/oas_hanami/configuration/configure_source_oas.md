# Configuring the Source OAS

For more complex scenarios, it is highly recommended to use a **source OAS (OpenAPI Specification)** file. This file serves as a centralized repository for reusable objects (such as schemas, request bodies, parameters, and responses) that can be referenced across your API documentation. This approach promotes consistency and reduces redundancy.

## Basic Configuration

To set up a source OAS file, configure the path in your `OasHanami` configuration block:

```ruby
OasHanami.configure do |config|
  config.source_oas_path = "lib/oas.json" # Path to your source OAS file
end
```

## Example Source OAS File

Below is an example of an `oas.json` file containing reusable components, such as a `User` schema:

```json
{
  "components": {
    "schemas": {
      "User": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "description": "The user's full name"
          },
          "email": {
            "type": "string",
            "format": "email",
            "description": "The user's email address"
          },
          "age": {
            "type": "integer",
            "description": "The user's age",
            "minimum": 0
          },
          "password": {
            "type": "string",
            "description": "The user's password",
            "minLength": 6
          }
        },
        "required": [
          "name",
          "email",
          "password"
        ],
        "example": {
          "name": "John Doe",
          "email": "john.doe@example.com",
          "age": 30,
          "password": "securepassword123"
        }
      }
    },
    "requestBodies": { ... },
    "parameters": { ... },
    ...
  }
}
```

## Referencing Reusable Components

Once your source OAS file is configured, you can reference its components in your API documentation tags. For example, to reference the `User` schema in a response:

```markdown
# @response Created User (200) [Reference:#/components/schemas/User]
```

### Key Benefits

1. **Consistency**: Ensures uniformity across your API documentation.
2. **Reusability**: Eliminates duplication by centralizing common objects.
3. **Maintainability**: Simplifies updates, as changes to the source OAS propagate automatically to all references.

### Supported References

You can reference the **schemas** of **request bodies, responses, and parameters** using the main tag. For example:

```markdown
# @request_body Required User [Reference:#/components/schemas/User]
```

Alternatively, you can **reference the entire request body, response, or parameter** using the reference tags:

```markdown
# @request_body_ref #/components/requestBodies/createUser
```
