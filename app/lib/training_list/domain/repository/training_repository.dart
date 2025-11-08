import '../entity/training_category.dart';

abstract class TrainingRepository {
  Future<List<TrainingCategory>> getTrainingCategories();
}
