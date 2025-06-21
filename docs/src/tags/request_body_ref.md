# @request_body_ref

**Structure**: `@request_body_ref text`

Document a request body using a custom reference. This tag allows you to reference predefined request bodies or external resources, making your API documentation more modular and reusable.

### Usage

- **`text`**: A reference to the request body definition. This can be:
  - An internal reference (e.g., `#/components/requestBodies/user`).
  - An external URL (e.g., `https://example.com/request_bodies/user.json`).

### Examples

1. **Internal Reference**:

   ```markdown
   # @request_body_ref #/components/requestBodies/user
   ```

   This references a predefined user request body in your OpenAPI components.

2. **External Resource**:

   ```markdown
   # @request_body_ref https://example.com/request_bodies/user.json
   ```

   This references an external resource for a user request body, useful for shared documentation across services.
