import 'package:dashflix/screens/now_playing_screen_module/models/nowplaying_model.dart';

import '../../../helper/dio_client.dart';
import '../../../helper/injections.dart';

abstract class IFetchNowPlayingMoviesRepository {
  Future<NowPlayingModel> getNowPlayingMovies(int page, String path);
}

class FetchNowPlayingMovies implements IFetchNowPlayingMoviesRepository {
  DioClient dioClient = getIt<DioClient>();

  @override
  Future<NowPlayingModel> getNowPlayingMovies(int page, String path) async {
    final response = await dioClient.getDio().get(path, queryParameters: {
      'page': page,
    });

    try {
      if (response.statusCode == 200) {
        final result = response.data;
        final getData = NowPlayingModel.fromJson(result);
        return getData;
      } else {
        return NowPlayingModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
