
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/app_theme.dart';
import '../providers/favourites_provider.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favoritesAsync.when(
        data: (meals) {
          if (meals.isEmpty) {
            return const Center(
              child: Text('No favorites yet', style: TextStyle(color: AppColors.inkMuted)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: meals.length,
            separatorBuilder: (context, index) => const Divider(indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              final meal = meals[index];
              return RecipeRow(
                name: meal.name,
                thumbnail: meal.thumbnail,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailScreen(mealId: meal.id),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: AppColors.tomato),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(meal);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.basil)),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}