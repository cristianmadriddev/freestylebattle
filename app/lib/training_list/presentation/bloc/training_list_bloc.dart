import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/get_training_words_use_case.dart';
import 'training_list_event.dart';
import 'training_list_state.dart';

class TrainingListBloc extends Bloc<TrainingListEvent, TrainingListState> {
  final GetTrainingCategoriesUseCase getCategories;

  TrainingListBloc(this.getCategories) : super(TrainingListInitial()) {
    on<LoadTrainingListCategories>((event, emit) async {
      emit(TrainingListLoaded(await getCategories()));
    });
  }
}
