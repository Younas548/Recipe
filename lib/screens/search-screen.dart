import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/app_theme.dart';
import '/search-provider.dart';
import 'meal_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Timer? _debounce;
  final TextEditingController _controller = TextEditingController();

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(queryProvider.notifier).state = value.trim();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(queryProvider);
    final resultsAsync = ref.watch(searchProvider(query));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            prefixIcon: const Icon(Icons.search, color: AppColors.inkMuted),
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: query.isEmpty
          ? const Center(
              child: Text(
                'Type to search recipes',
                style: TextStyle(color: AppColors.inkMuted),
              ),
            )
          : resultsAsync.when(
              data: (meals) {
                if (meals.isEmpty) {
                  return const Center(
                    child: Text('No recipes found', style: TextStyle(color: AppColors.inkMuted)),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: meals.length,
                  separatorBuilder: (context, index) =>
                      const Divider(indent: 20, endIndent: 20),
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
              loading: () =>
                  const Center(child: CircularProgressIndicator(color: AppColors.basil)),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
            ),
    );
  }
}