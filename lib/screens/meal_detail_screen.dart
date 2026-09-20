import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/app_theme.dart';
import '/meal_detail_provider.dart';
import '/favourites_provider.dart';
//import 'meal-screen.dart'; 
import '/meal-model.dart'; // Meal class

class MealDetailScreen extends ConsumerWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(mealDetailProvider(mealId));
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
        ),
        actions: [
          detailAsync.when(
            data: (meal) {
              final isFav =
                  favoritesAsync.value?.any((m) => m.id == meal.id) ?? false;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleIconButton(
                  icon: isFav ? Icons.favorite : Icons.favorite_border,
                  iconColor: isFav ? AppColors.tomato : AppColors.ink,
                  onTap: () {
                    final simpleMeal = Meal(
                      id: meal.id,
                      name: meal.name,
                      thumbnail: meal.thumbnail,
                    );
                    ref.read(favoritesProvider.notifier).toggleFavorite(simpleMeal);
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, s) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: detailAsync.when(
        data: (meal) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image with a gradient so the floating buttons stay readable
                Stack(
                  children: [
                    Image.network(
                      meal.thumbnail,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: 120,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 6),
                      Text(
                        '${meal.category} • ${meal.area}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),

                      Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: meal.ingredients.map((ingredient) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.basilTint,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ingredient,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.ink,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 28),
                      Text('Instructions', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(meal.instructions, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.basil)),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}