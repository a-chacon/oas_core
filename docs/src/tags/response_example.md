# @response_example

**Structure**: `@response_example text(code) [Type]`

Documents response examples of the endpoint associated to a response code.

**One line example**:

`# @response_example Invalida Email(422) [JSON{"success": "false", "errors": [{"field": "email", "type": "email", "detail": ["Invalid email"]}] }]`

`# @response_example Id not exists (404) [{"success": "false", "message": "Nothing found with the provided ID." }]`

**Multi-line example**:

```ruby
  # @response_example Another 405 Error (405)
  #   [JSON{
  #     {
  #       "message": "another",
  #       "data": {
  #         "availabilities": [
  #           "three"
  #         ],
  #         "dates": []
  #       }
  #     }
  #   }]
```

**It should be valid JSON; don't forget that keys must be enclosed in quotes ("").**
