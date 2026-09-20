import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_finder/model/meal-model.dart';
//import 'meal-screen.dart' hide Meal; // jahan Meal class hai

final mealsByCategoryProvider =
    FutureProvider.family<List<Meal>, String>((ref, categoryName) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['meals'] == null) {
        return []; // koi recipe na mile, khaali list (error nahi)
      }

      final List<dynamic> mealList = data['meals'];
      return mealList.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Server error (${response.statusCode})');
    }
  } on SocketException {
    throw Exception('No internet connection. Check your network and retry.');
  } on TimeoutException {
    throw Exception('Request timed out. Please try again.');
  } on FormatException {
    throw Exception('Received unexpected data from the server.');
  }
});