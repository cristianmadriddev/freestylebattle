import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/entity/training_category.dart';
import '../domain/repository/training_repository.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  @override
  Future<List<TrainingCategory>> getTrainingCategories() async {
    try {
      final jsonString = await rootBundle.loadString('assets/training.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      final List<dynamic> categoriesList = data['categories'] ?? [];

      final List<TrainingCategory> categories = categoriesList.map((item) {
        return TrainingCategory(
          key: item['key'] as String,
          title: item['title'] as String,
          words: List<String>.from(item['words'] ?? []),
        );
      }).toList();

      return categories;
    } catch (e) {
      throw Exception('Erro ao carregar categorias de treino: $e');
    }
  }
}
