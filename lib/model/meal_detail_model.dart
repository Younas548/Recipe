class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    // Ingredients + measures ko combine karne ke liye khaali list banayi
    List<String> ingredientsList = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      // Khaali ya null values skip karo
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredientsList.add('$ingredient - $measure');
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredientsList,
    );
  }
}