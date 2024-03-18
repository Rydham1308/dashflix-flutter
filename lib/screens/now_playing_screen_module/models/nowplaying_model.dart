
import 'package:dashflix/screens/now_playing_screen_module/models/result_nowplaying_model.dart';

class NowPlayingModel {
  int? page;
  int? totalPages;
  int? totalResults;
  List<NowPlayingResultModel>? results;

  NowPlayingModel({
    this.page,
    this.totalPages,
    this.totalResults,
    this.results,
  });

  NowPlayingModel.fromJson(Map<String, dynamic> json):
        page = json['page'],
        totalPages = json['total_pages'],
        totalResults = json['total_results'],
        results = List<NowPlayingResultModel>.from(json["results"].map((x) => NowPlayingResultModel.fromJson(x)));
}

