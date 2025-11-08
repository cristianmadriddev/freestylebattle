class TrainingCategory {
  final String key;
  final String title;
  final List<String> words;

  TrainingCategory({
    required this.key,
    required this.title,
    required this.words,
  });

  TrainingCategory copyWith({String? key, String? title, List<String>? words}) {
    return TrainingCategory(
      key: key ?? this.key,
      title: title ?? this.title,
      words: words ?? this.words,
    );
  }
}
