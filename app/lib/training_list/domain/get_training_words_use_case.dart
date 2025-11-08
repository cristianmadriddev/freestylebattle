import 'entity/training_category.dart';
import 'repository/training_repository.dart';

abstract class GetTrainingCategoriesUseCase {
  Future<List<TrainingCategory>> call();
}

class GetTrainingCategoriesUseCaseImpl extends GetTrainingCategoriesUseCase {
  final TrainingRepository repository;
  GetTrainingCategoriesUseCaseImpl(this.repository);

  @override
  Future<List<TrainingCategory>> call() async {
    final categories = await repository.getTrainingCategories();
    return [
      TrainingCategory(
        key: "mix",
        title: "Mix",
        words: categories.expand((c) => c.words).toList(),
      ),
      ...categories,
    ];
  }
}
