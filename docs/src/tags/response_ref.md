# @response_ref

**Structure**: `@response_ref (code) text`

Document a response using a custom reference. This tag allows you to reference predefined responses or external resources, making your API documentation more modular and reusable.

### Usage

- **`code`**: The HTTP status code for the response (e.g., `200`, `404`, `500`).
- **`text`**: A reference to the response definition. This can be:
  - An internal reference (e.g., `#/components/responses/success`).
  - An external URL (e.g., `https://example.com/responses/not_found`).

### Examples

1. **Internal Reference**:

   ```markdown
   # @response_ref (200) #/components/responses/success
   ```

   This references a predefined success response in your OpenAPI components.

2. **Error Response**:

   ```markdown
   # @response_ref (500) #/components/responses/error
   ```

   This references a predefined error response in your OpenAPI components.

3. **External Resource**:

   ```markdown
   # @response_ref (404) https://example.com/responses/not_found.json
   ```

   This references an external resource for a "Not Found" response, useful for shared documentation across services.
