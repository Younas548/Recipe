import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/app_theme.dart';
import '/category_provider.dart';
import 'meal-screen.dart';
import 'search-screen.dart';
import 'favourites_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Finder'),
        actions: [
          CircleIconButton(
            icon: Icons.favorite,
            background: AppColors.basilTint,
            iconColor: AppColors.tomato,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            icon: Icons.search,
            background: AppColors.basilTint,
            iconColor: AppColors.basil,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MealScreen(categoryName: category.name),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(category.thumbnail, fit: BoxFit.cover),
                      // Gradient scrim taake text image ke upar bhi saaf padhi jaye
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontFamily: headlineFont,
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.basil)),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error: $error', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}