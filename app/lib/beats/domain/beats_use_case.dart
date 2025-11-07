import 'package:http/http.dart' as http;
import 'package:soundcloud_explode_dart/soundcloud_explode_dart.dart';

abstract class BeatsUseCase {
  Future<List<Track>> call();
}

/// Um cliente HTTP que adiciona um User-Agent customizado em cada requisição.
class HttpClientWithHeader extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['User-Agent'] =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36';
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}

final class BeatsFromSoundCloudUseCase extends BeatsUseCase {
  BeatsFromSoundCloudUseCase({required this.url});
  final String url;

  @override
  Future<List<Track>> call() async {
    final client = SoundcloudClient(httpClient: HttpClientWithHeader());
    final tracks = <Track>[];

    try {
      print("Fetching playlist from $url");
      final playlist = await client.playlists.getByUrl(url);

      await for (final batch in client.playlists.getTracks(playlist.id)) {
        tracks.addAll(batch);
      }
    } catch (e, s) {
      print("Error: $e");
      print(s);
    } finally {
      client.users; // apenas pra garantir que o client não é tree-shaken
    }

    print("Total tracks fetched: ${tracks.length}");
    return tracks;
  }
}
