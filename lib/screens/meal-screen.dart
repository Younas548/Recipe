import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/app_theme.dart';
import '../providers/meal-provider.dart';
//import 'meal-model.dart';   // <-- asal Meal class yahan se import karo
import 'meal_detail_screen.dart';


class MealScreen extends ConsumerWidget {
  final String categoryName;
  const MealScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(mealsByCategoryProvider(categoryName));
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: mealsAsync.when(
        data: (meals) {
          if (meals.isEmpty) {
            return const Center(child: Text('No recipes found'));
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
                trailing: const Icon(Icons.chevron_right, color: AppColors.inkMuted),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.basil)),
      ),
    );
  }
}

