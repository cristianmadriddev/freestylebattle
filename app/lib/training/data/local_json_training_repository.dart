// training_repository_impl.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/training_repository.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  @override
  Future<List<String>> getWords(TrainingLevel level) async {
    final jsonString = await rootBundle.loadString('assets/words.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    return List<String>.from(data['level'][level.name] ?? []);
  }
}
