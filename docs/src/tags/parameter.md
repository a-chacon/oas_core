# @parameter

**Structure**: `@parameter name(position) [type] text`

Represents a parameter for the endpoint. The position can be one of the following: `header`, `path`, `cookie`, or `query`. The type should be a valid Ruby class, such as `String`, `Integer`, or `Array<String>`. Prefix the class with a `!` to indicate a required parameter.

**Examples**:

`# @parameter page(query) [Integer] The page number.`

`# @parameter slug(path) [!String] The slug of the project.`

### Reference

This tag also supports a reference for its schema. The reference can point to any external or internal resource, following the OpenAPI Specification (OAS) definition: <https://spec.openapis.org/oas/v3.1.0.html#schema-object>.

The reference should be formatted as follows:

```
# @parameter page(query) [Reference:#/components/schema/pageQueryParam]
```

Note that the reference applies to the schema, not the entire parameter. To reference the complete parameter, use the `@parameter_ref` tag.
