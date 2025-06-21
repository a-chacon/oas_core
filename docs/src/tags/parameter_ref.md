# @parameter_ref

**Structure**: `@parameter_ref text`

Document a parameter using a custom reference. This tag allows you to reference predefined parameters or external resources, making your API documentation more modular and reusable.

### Usage

- **`text`**: A reference to the parameter definition. This can be:
  - An internal reference (e.g., `#/components/parameters/user_id`).
  - An external URL (e.g., `https://example.com/parameters/user_id.json`).

### Examples

1. **Internal Reference**:

   ```markdown
   # @parameter_ref #/components/parameters/user_id
   ```

   This references a predefined user ID parameter in your OpenAPI components.

2. **External Resource**:

   ```markdown
   # @parameter_ref https://example.com/parameters/user_id.json
   ```

   This references an external resource for a user ID parameter, useful for shared documentation across services.
