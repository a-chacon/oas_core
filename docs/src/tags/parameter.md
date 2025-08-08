# @parameter

**Structure**: `@parameter name(position) [type] text [keyword: (value)]`

Represents a parameter for the endpoint. The position can be one of the following: `header`, `path`, `cookie`, or `query`. The type should be a valid Ruby class, such as `String`, `Integer`, or `Array<String>`. Prefix the class with a `!` to indicate a required parameter.

### Supported Keywords in Descriptions

You can include additional schema keywords in the description using the format `keyword: (value)`. The following keywords are supported:

- **`default`**: The default value for the parameter.  
  Example: `default: (1)`
- **`minimum`**: The minimum value for numeric parameters.  
  Example: `minimum: (0)`
- **`maximum`**: The maximum value for numeric parameters.  
  Example: `maximum: (100)`
- **`enum`**: A comma-separated list of allowed values.  
  Example: `enum: (red,green,blue)`
- **`format`**: The format of the parameter (e.g., `date`, `uuid`).  
  Example: `format: (uuid)`
- **`pattern`**: A regex pattern for string validation.  
  Example: `pattern: (^[A-Za-z]+$)`
- **`nullable`**: Whether the parameter can be `null` (`true` or `false`).  
  Example: `nullable: (true)`
- **`exclusiveMinimum`**: Whether the `minimum` is exclusive (`true` or `false`).  
  Example: `exclusiveMinimum: (true)`
- **`exclusiveMaximum`**: Whether the `maximum` is exclusive (`true` or `false`).  
  Example: `exclusiveMaximum: (false)`
- **`minLength`**: The minimum length for string parameters.  
  Example: `minLength: (3)`
- **`maxLength`**: The maximum length for string parameters.  
  Example: `maxLength: (50)`

**Examples**:

```ruby
# Basic usage
# @parameter page(query) [!Integer] The page number. default: (1) minimum: (0)

# Enum and nullable
# @parameter color(query) [String] The color of the item. enum: (red,green,blue) nullable: (true)

# String validation
# @parameter username(path) [String] The username. pattern: (^[A-Za-z0-9_]+$), minLength: (3), maxLength: (20)

```

## From Swagger docs: Common Mistakes

There are two common mistakes when using the default keyword:

- Using default with required parameters or properties, for example, with path parameters. This does not make sense – if a value is required, the client must always send it, and the default value is never used.
- Using default to specify a sample value. This is not intended use of default and can lead to unexpected behavior in some Swagger tools. Use the example or examples keyword for this purpose instead. See Adding Examples.
