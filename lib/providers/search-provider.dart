import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import '../model/meal-model.dart';

final queryProvider = StateProvider<String> ((ref)=> '');
final searchProvider = FutureProvider.family<List<Meal>, String>((ref , query)async {
 if(query.trim().isEmpty){
  return [];
 }
 final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));
 if(response.statusCode==200){
  final data = jsonDecode(response.body);
  if(data['meals']==null){
    return [];
  }
  final List<Map<String, dynamic>> mealList =
      List<Map<String, dynamic>>.from(data['meals']);
  return mealList.map((json)=> Meal.fromJson(json)).toList();
 }else{
  throw Exception("failed to search meals");
 }
}
);