# Bicycle Shop Test Project

This test project demonstrates an over-engineered solution for a bicycle shop application built with Ruby on Rails. It showcases advanced design patterns and techniques such as:

- **Abstracted STI**: The `Product` model is abstracted to make it easier to add new types of products (e.g. a new catalog like `SnowboardCatalog`) in the future.
- **Catalog & Concrete Products**:
  - The **Catalog** (formerly `BicycleProduct`) is a singleton STI record stored in the `products` table that holds all available parts and options.
  - All catalog parts and options are accessible via `Catalog.instance.parts_hash`.
  - Concrete bicycles (customized by the user) are created as separate records (in the `bicycles` table) that reference the catalog via a generic foreign key (`catalog_id`).
- **Dynamic Builder & Validator**:
  - **BicycleBuilder**: Dynamically defines setter methods (using metaprogramming) based on the catalog parts so that any new part added to the catalog is automatically supported. It then builds a concrete bicycle with associated join records (`BicyclePart`) to store the user’s selections.
  - **BicycleValidator**: Loads the entire catalog inventory from the singleton catalog and validates that the user’s selections are valid (including custom compatibility checks such as ensuring that "mountain wheels" require a "full-suspension" frame).

## Key Features

- **Models and Associations**:
  - `Product`: Abstract base class for STI.
  - `Catalog`: Inherits from `Product` and serves as the singleton catalog.
    - Accessible via `Catalog.instance` (or `Catalog.instance!` to create it if not present).
    - Its parts and options can be retrieved using `Catalog.instance.parts_hash`.
  - `Part` and `PartOption`: Represent the configurable parts (e.g. frame type, wheels) and their available options.
  - `Bicycle`: Concrete, customized bike (stored in a separate table) that belongs to a catalog.
  - `BicyclePart`: Join model that links a concrete bike to a catalog Part and the selected PartOption.

- **Seeds**:
  The seed data creates one catalog record with its parts and options, then builds several concrete bicycles using the builder.

- **Extensibility**:
  The architecture is designed to easily add new product types. For example, in the future, you could create a new catalog such as `SnowboardCatalog` with its own parts and options without altering the core architecture.

- **Testing**:
  RSpec tests are provided for both the builder and validator to ensure that:
  - Valid configurations are accepted.
  - Invalid configurations (such as out-of-stock options or incompatible selections) produce appropriate error messages.

## Getting Started

1. **Setup the Environment**
   Make sure you have Docker installed. Then run:

   ```bash
   docker-compose build web
   docker-compose run web bin/rails db:drop db:create db:migrate db:seed
