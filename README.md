# Bicycle Shop Test Project

This test project is an over‑engineered Ruby on Rails application for a bicycle shop. It demonstrates advanced design patterns including:

- **Abstracted Product Catalog via STI**:
  The catalog is implemented as a singleton STI record (the `Catalog` model, stored in the `products` table). All available parts and options are defined in the catalog and can be accessed via `Catalog.instance.parts_hash`.

- **Separation of Catalog and Custom Products**:
  The catalog holds the global configuration (parts and options), while user‑customized products are stored in a separate table via the `CustomProduct` model. For example, concrete bicycles are created as `Bicycle < CustomProduct` and reference the catalog through a generic foreign key (`catalog_id`). Their configuration is stored in a join table (`CustomProductPart`).

- **Dynamic Builder & Validator**:
  The `BicycleBuilder` uses metaprogramming (via `method_missing`) to dynamically define setter methods based on the catalog’s parts, so new parts are supported without code changes. The `BicycleValidator` loads the catalog inventory from `Catalog.instance` and validates user selections—including custom compatibility checks (e.g. "mountain wheels" require a "full-suspension" frame).

- **Testing**:
  RSpec tests cover both the builder and validator to ensure valid configurations pass and invalid ones produce the correct error messages.

## Getting Started

1. **Setup the Environment**
   Ensure you have Docker installed, then run:
   ```bash
   docker-compose build web
   docker-compose run web bin/rails db:drop db:create db:migrate db:seed
