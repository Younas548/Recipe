import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/meal-model.dart';

const _favoritesKey = 'favorite_meals';

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<Meal>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends AsyncNotifier<List<Meal>> {
  @override
  Future<List<Meal>> build() async {
    return _loadFavorites();
  }

  Future<List<Meal>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_favoritesKey) ?? [];
    return savedList
        .map((jsonString) => Meal.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  Future<void> _saveFavorites(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = meals.map((meal) => jsonEncode(meal.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  Future<void> toggleFavorite(Meal meal) async {
    final currentList = state.value ?? [];
    final isAlreadyFavorite = currentList.any((m) => m.id == meal.id);

    List<Meal> updatedList;
    if (isAlreadyFavorite) {
      updatedList = currentList.where((m) => m.id != meal.id).toList();
    } else {
      updatedList = [...currentList, meal];
    }

    // AsyncValue.guard() — agar save fail ho (storage full, permission issue),
    // state khud 'error' ban jayega, crash nahi hoga
    state = await AsyncValue.guard(() async {
      await _saveFavorites(updatedList);
      return updatedList;
    });
  }

  bool isFavorite(String mealId) {
    return state.value?.any((m) => m.id == mealId) ?? false;
  }
}