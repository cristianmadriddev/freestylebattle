import '../../domain/entity/training_category.dart';

abstract class TrainingListState {}

class TrainingListInitial extends TrainingListState {}

class TrainingListLoaded extends TrainingListState {
  final List<TrainingCategory> categories;
  TrainingListLoaded(this.categories);
}

class TrainingListError extends TrainingListState {
  final String message;
  TrainingListError(this.message);
}
