# @response

**Structure**: `@response text(code) [type<structure>]`

Documents the responses of the endpoint and overrides the default responses found by the engine.

**One line example**:

`# @response User not found by the provided Id(404) [Hash{success: Boolean, message: String}]`

`# @response Validation errors(422) [Hash{success: Boolean, errors: Array<Hash{field: String, type: String, detail: Array<String>}>}]`

**Multi-line example**:

```ruby
  # @response A test response from an Issue(405)
  #   [
  #     Hash{
  #       message: String,
  #       data: Hash{
  #         availabilities: Array<String>,
  #         dates: Array<Date>
  #       }
  #     }
  #   ]
```

### Reference

This tag also supports a reference for its schema. The reference can be to anything you want, external or internal resources, following the definition of OAS <https://spec.openapis.org/oas/v3.1.0.html#schema-object>.

The reference should be passed like this:

```
# @response User not found by the provided Id(404) [Reference:#/components/schema/errorResponse]
```

Notice that the reference here **is for the schema and not for the entire response**. If you need to reference the complete response, consider using `@response_ref`.
