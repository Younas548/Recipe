import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../model/meal_detail_model.dart';

final mealDetailProvider =
    FutureProvider.family<MealDetail, String>((ref, mealId) async {
  try {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['meals'] == null) {
        throw Exception('Recipe not found');
      }

      final mealJson = data['meals'][0];
      return MealDetail.fromJson(mealJson);
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