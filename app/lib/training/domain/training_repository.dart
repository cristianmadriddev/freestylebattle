enum TrainingLevel { facil, medio, dificil }

abstract class TrainingRepository {
  Future<List<String>> getWords(TrainingLevel level);
}
