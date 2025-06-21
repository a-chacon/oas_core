# @request_body_example

**Structure**: `@request_body_example text [type]`

Adds examples to the provided request body.

**One line example**:

`# @request_body_example A complete User. [JSON{"user": {"name": 'Luis', "age": 30, "password": 'MyWeakPassword123'}}]`

**Multi-line example**:

```ruby
  # @request_body_example basic user
  #   [JSON{
  #       "user": {
  #         "name": "Oas",
  #         "email": "oas@test.com",
  #         "password": "Test12345"
  #       }
  #     }
  #   ]
```

**It should be valid JSON; don't forget that keys must be enclosed in quotes ("").**
