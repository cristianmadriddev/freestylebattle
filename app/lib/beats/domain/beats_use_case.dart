import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

abstract class BeatsUseCase {
  Future<List<AssetSource>> call();
}

final class BeatsFromLocalAssetsUseCase extends BeatsUseCase {
  BeatsFromLocalAssetsUseCase({this.shuffle = true});

  /// Define se a lista deve ser embaralhada
  final bool shuffle;

  @override
  Future<List<AssetSource>> call() async {
    final beats = List.generate(
      10,
      (i) => AssetSource('beats/beat${i + 1}.mp3'),
    );

    if (shuffle) {
      beats.shuffle(Random());
    }

    return beats;
  }
}
