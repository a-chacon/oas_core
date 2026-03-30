# @deprecated

**Structure**: `@deprecated text`

Marks an endpoint as deprecated in the generated OpenAPI Operation Object by emitting `deprecated: true`.

The optional text is preserved by YARD and can be used by adapters or downstream generators to explain the replacement endpoint or migration path.

**Example**:

```ruby
# @deprecated Use POST /machine-file instead.
```
