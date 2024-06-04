import '../../../helper/dio_client.dart';
import '../../../helper/injections.dart';
import '../models/popular_movie_model.dart';

abstract class IFetchPopularMoviesRepository {
  Future<MainMovieModel> getPopularMovies(int page, String path);
}

class FetchPopularMovies implements IFetchPopularMoviesRepository {
  DioClient dioClient = getIt<DioClient>();

  @override
  Future<MainMovieModel> getPopularMovies(int page, String path) async {
    final response = await dioClient.getDio().get(path, queryParameters: {
      'page': page,
    });

    try {
      if (response.statusCode == 200) {
        final result = response.data;
        final getData = MainMovieModel.fromJson(result);
        return getData;
      } else {
        return MainMovieModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
