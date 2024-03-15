import 'package:dashflix/screens/home_screen_module/models/result_popular_model.dart';

class MainMovieModel {
  final int? page;
  final int? totalPages;
  final int? totalResults;
  final List<ResultModel>? results;

  MainMovieModel({
     this.page,
     this.totalPages,
     this.totalResults,
     this.results,
  });

  MainMovieModel.fromJson(Map<String, dynamic> json):
        page = json['page'],
        totalPages = json['total_pages'],
        totalResults = json['total_results'],
        results = List<ResultModel>.from(json["results"].map((x) => ResultModel.fromJson(x)));
}

