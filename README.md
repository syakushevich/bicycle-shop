# Bicycle Shop Test Project

This test project demonstrates an over‑engineered solution for a bicycle shop application built with Ruby on Rails. The project is designed to showcase advanced design patterns and techniques, including:

- **Abstracted Product Catalog via STI**:
  The abstract `Product` base class is used only for the catalog. The catalog is implemented as an STI subclass called **Catalog** (instead of the former `BicycleProduct`), stored in the `products` table. This catalog holds all available parts and options and can be accessed via `Catalog.instance.parts_hash`.

- **Separation of Catalog and Concrete Products**:
  - The **Catalog** contains the global configuration for a product (e.g., frame type, wheels, etc.) and is a singleton record in the `products` table.
  - **Parts** and **PartOptions** (associated with the Catalog) represent the configurable attributes and their available choices.
  - Concrete (user‑customized) products are stored in a separate table (via the `CustomProduct` model). In this project, concrete bicycles are represented by the **Bicycle** model, which inherits from `CustomProduct` rather than from `Product`.
  - Each concrete product belongs to a catalog through a generic foreign key (`catalog_id`), and its configuration is stored in a join table (via the **CustomProductPart** model).

- **Dynamic Builder & Validator**:
  - **BicycleBuilder** dynamically defines setter methods (using metaprogramming via `method_missing`) based on the catalog’s parts. This ensures that any new part added to the catalog is automatically supported without modifying the builder code.
  - **BicycleValidator** loads the entire catalog inventory from the singleton catalog and validates that the user's selections are valid, including custom compatibility checks (for example, ensuring that "mountain wheels" require a "full-suspension" frame).

- **Testing with RSpec**:
  RSpec tests have been added for both the builder and the validator. These tests ensure that:
  - Valid configurations are accepted.
  - Invalid configurations (such as out‑of‑stock options or incompatible selections) produce appropriate error messages.

## Key Features

- **Models and Associations**:
  - **Product**: Abstract base class for STI (used only for the catalog).
  - **Catalog**: Inherits from `Product` and serves as the singleton catalog.
    - Access the catalog via `Catalog.instance` (or `Catalog.instance!` to create it if it does not exist).
    - All available parts and options are accessible via `Catalog.instance.parts_hash`.
  - **Part** and **PartOption**: Represent the configurable attributes (e.g., frame type, wheels) and their available options.
  - **CustomProduct**: Base class for all concrete (user‑customized) products, stored in its own table (`custom_products`).
  - **Bicycle**: A concrete, customized bike that inherits from `CustomProduct` (and is an STI subclass with type `"Bicycle"`).
  - **CustomProductPart**: Join model that links a concrete product to a catalog Part and the selected PartOption.

- **Seeds**:
  The seed data first creates a single catalog record (via the **Catalog** model) with its parts and part options, then builds several concrete bicycles using the **BicycleBuilder**.

- **Extensibility**:
  The architecture is designed to be flexible:
  - New product types can be added easily by creating new STI subclasses of `CustomProduct` (for example, a `Snowboard` model).
  - The catalog is abstracted so that all available options are defined in one place, accessible via `Catalog.instance.parts_hash`.

## Getting Started

1. **Setup the Environment**
   Ensure you have Docker installed. Then run:
   ```bash
   docker-compose build web
   docker-compose run web bin/rails db:drop db:create db:migrate db:seed
