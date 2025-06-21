# @request_body

**Structure**: `@request_body text [type<structure>]`

Documents the request body needed by the endpoint. The structure is optional if you provide a valid Active Record class. Use `!` to indicate a required request body.

**One line example**:

`# @request_body The user to be created [!User]`

`# @request_body The user to be created [User]`

**Multi-line example**:

```ruby
  # @request_body User to be created
  #   [
  #     !Hash{
  #       user: Hash{
  #         name: String,
  #         email: String,
  #         age: Integer,
  #         cars: Array<
  #           Hash{
  #             identifier: String
  #           }
  #         >
  #       }
  #     }
  #   ]
```

### Reference

This tag also supports a reference for its schema. The reference can be to anything you want, external or internal resources, following the definition of OAS <https://spec.openapis.org/oas/v3.1.0.html#schema-object>.

The reference should be passed like this:

```
# @request_body The user to be created [Reference:#/components/schema/userRequest]
```

Notice that the reference here **is for the schema and not for the entire request body**. If you need to reference the complete request body, consider using `@request_body_ref`.
