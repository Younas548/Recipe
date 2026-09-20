# Recipe Finder 🍲

A Flutter recipe discovery app built to practice **Riverpod** for state management. Browse recipes by category, search by name, view full details, and save favorites — all backed by live data from TheMealDB API.

## Features

- 🍽️ Browse recipes organized by category (Beef, Chicken, Dessert, Seafood, etc.)
- 🔍 Debounced search — find recipes by name as you type
- 📋 Full recipe details — ingredients (with measurements) and step-by-step instructions
- ⭐ Save recipes to Favorites — persisted locally with `shared_preferences`, so they survive app restarts
- ⚡ Full async state handling: loading, error, and data states via Riverpod's `AsyncValue`
- 🛡️ Robust error handling — specific messages for no internet, timeouts, and malformed responses

## Tech Stack

- **Flutter** (Dart)
- **flutter_riverpod** — state management
- **http** — API requests
- **shared_preferences** — local persistence for favorites
- **TheMealDB API** — free, no API key required

## Architecture

- **Models** — `Category`, `Meal` (list view), and `MealDetail` (full recipe), each with a `fromJson()` factory for parsing API responses
- **Providers**
  - `FutureProvider` — fetches categories
  - `FutureProvider.family` — fetches recipes by category name, and full recipe details by ID (parameterized providers)
  - `StateProvider` — tracks the live search query
  - `AsyncNotifierProvider` — manages the favorites list, including loading from and saving to local storage
- **Screens** — Home (categories grid), Meals (recipes by category), Search, Recipe Details, and Favorites, all built with `ConsumerWidget` / `ConsumerStatefulWidget`

## Getting Started

1. Clone the repo
   ```bash
   git clone <your-repo-url>
   cd recipe_finder
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

   No API key setup needed — TheMealDB's free tier works out of the box.

## Screenshots

_Add screenshots here once available._

## What I Learned

This project was built specifically to get hands-on with Riverpod, including:
- `FutureProvider` and `AsyncValue.when()` for clean async state handling
- `FutureProvider.family` for parameterized, cached data fetching
- `StateProvider` combined with debounced search input
- `AsyncNotifier` for state that can be mutated (add/remove favorites) and persisted
- Local persistence with `shared_preferences`
- Structuring a multi-screen Flutter app with clear separation between models, providers, and UI

## License

This project is open source and available for learning purposes.
