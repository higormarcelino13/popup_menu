# Popup Menu API

An API built with Rails 7 + Mongoid to manage Restaurants, Menus and Menu Items.

## Tech Stack
- Ruby on Rails 7.2
- MongoDB (via Mongoid)
- JSON:API serialization (`jsonapi-serializer`)
- Puma
- RSpec-like assertions using Rails Minitest (default)

## Requirements
- Ruby 3.1.x
- Bundler
- MongoDB 7.x running locally (or Docker)
- macOS/Linux/WSL2

## Setup
1) Install gems
```bash
bundle install
```

2) Start MongoDB
- Homebrew (recommended on macOS):
```bash
brew tap mongodb/brew
brew install mongodb-community@7.0
brew services start mongodb-community@7.0
```

- Docker (alternative):
```bash
docker run -d --name popup_mongo -p 27017:27017 mongo:7
```

3) Environment config
Mongoid is configured in `config/mongoid.yml` for development/test.

## Run Tests
```bash
bin/rails test
```

Run a specific file or test name:
```bash
bin/rails test test/controllers/restaurant_controller_test.rb
bin/rails test test/controllers/restaurant_controller_test.rb -n "/bulk_create/"
```

## Run Server
```bash
bin/rails s
```

## API Endpoints

Restaurants
- GET `/restaurants/show` — list restaurants (JSON:API)
- POST `/restaurants/create` — create restaurant
- DELETE `/restaurants/:id` — delete restaurant
- POST `/restaurants/bulk_create` — accept raw payload and echo (for test harness)
- POST `/restaurants/import` — import JSON payload into the domain, with logs

Menus
- GET `/menus` — list menus
- GET `/menus/:id` — show one menu
- POST `/menus` — create menu (`{ menu: { name, restaurant_id, menu_item_ids: [] } }`)
- DELETE `/menus/:id` — delete menu

Menu Items
- GET `/menu_items` — list menu items
- GET `/menu_items/:id` — show one menu item
- POST `/menu_items` — create menu item (`{ menu_item: { name, price } }`)
- DELETE `/menu_items/:id` — delete menu item

## JSON Import
- Endpoint: `POST /restaurants/import`
- Body: a JSON with `restaurants` containing `menus` with either `menu_items` or `dishes` arrays. Example:
```json
{
  "restaurants": [
    {
      "name": "Poppo's Cafe",
      "menus": [
        {
          "name": "lunch",
          "menu_items": [
            { "name": "Burger", "price": 9.0 },
            { "name": "Small Salad", "price": 5.0 }
          ]
        }
      ]
    }
  ]
}
```

### Behavior
- Normalizes `dishes` → `menu_items`.
- Deduplicates `MenuItem` by global `name` (unique index + validation).
- Associates items to menus without duplications.
- Returns: `{ success: boolean, logs: [] }` where logs include per-item info and any errors.

### How it works
- Implemented by `JsonImportService` (`app/services/json_import_service.rb`).
- Controller: `RestaurantController#import`.

## Domain Model
- `Restaurant` has many `Menu` (dependent destroy)
- `Menu` belongs to `Restaurant` and has-and-belongs-to-many `MenuItem`
- `MenuItem` has-and-belongs-to-many `Menu`

### Validations
- `Restaurant`: `name` presence
- `Menu`: `name` presence
- `MenuItem`: `name` presence + uniqueness, `price` presence (>= 0)

## Project Structure
```
app/
  controllers/
    restaurant_controller.rb
    menu_controller.rb
    menu_item_controller.rb
  models/
    restaurant.rb
    menu.rb
    menu_item.rb
  serializers/
    restaurant_serializer.rb
    menu_serializer.rb
    menu_item_serializer.rb
  services/
    json_import_service.rb
config/
  routes.rb
  mongoid.yml
test/
  controllers/
    restaurant_controller_test.rb
  models/
    restaurant_test.rb
    menu_test.rb
    menu_item_test.rb
  integration/
    import_json_test.rb
```

## Development Notes
- Built iteratively by levels (Basics → Multiple Menus → Import).
- JSON:API responses via serializers.
- Uses Rails Minitest for concise test coverage.

## Troubleshooting
- If `sprockets` complains about manifest, ensure `app/assets/config/manifest.js` exists.
- If MongoDB connection fails, verify service is running on `localhost:27017` or start Docker container.
