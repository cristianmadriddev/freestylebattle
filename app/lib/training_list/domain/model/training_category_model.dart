import 'training_category.dart';

class TrainingCategoryModel extends TrainingCategory {
  TrainingCategoryModel({
    required super.key,
    required super.title,
    required super.words,
  });

  factory TrainingCategoryModel.fromJson(Map<String, dynamic> json) {
    return TrainingCategoryModel(
      key: json['key'],
      title: json['title'],
      words: List<String>.from(json['words']),
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'title': title, 'words': words};
}
