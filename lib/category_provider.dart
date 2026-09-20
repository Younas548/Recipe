import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/model.dart';

final recipeProvider = FutureProvider<List<Category>>((ref) async {
  try {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['categories'] == null) {
        throw Exception('No categories found');
      }

      final List<dynamic> categoryList = data['categories'];
      return categoryList.map((json) => Category.fromJson(json)).toList();
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