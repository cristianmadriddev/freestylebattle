import 'training_repository.dart';

abstract class GetTrainingWordsUseCase {
  Future<List<String>> call(TrainingLevel level);
}

class GetTrainingWordsUseCaseImpl extends GetTrainingWordsUseCase {
  final TrainingRepository _repository;
  GetTrainingWordsUseCaseImpl(this._repository);

  @override
  Future<List<String>> call(TrainingLevel level) {
    return _repository.getWords(level);
  }
}
