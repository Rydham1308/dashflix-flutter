import 'dart:async';
import 'dart:io';

import 'package:dashflix/screens/popular_movies_screen_module/api/fetch_movies_data.dart';
import 'package:dashflix/screens/popular_movies_screen_module/models/result_popular_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/api_status.dart';

part 'popular_movies_event.dart';

part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  PopularMoviesBloc({required IFetchPopularMoviesRepository popularMovies})
      : _fetchPopularMovies = popularMovies,
        super(const PopularMoviesStates.isInitial()) {
    on<GetPopularMoviesEvent>(getPopularMovies);
  }

  final IFetchPopularMoviesRepository _fetchPopularMovies;
  List<ResultModel> resultList = [];
  int page = 1;
  int totalPages = 0;

  Future<void> getPopularMovies(GetPopularMoviesEvent event,
      Emitter<PopularMoviesState> emit) async {
    try {
      if (resultList.isEmpty) {
        emit(const PopularMoviesStates.isLoading());
        final data = await _fetchPopularMovies.getPopularMovies(page, 'movie/popular');
        totalPages = data.totalPages ?? 0;
        resultList = data.results ?? [];
      } else {
        page++;
        // print("page === >  $page");
        final data = await _fetchPopularMovies.getPopularMovies(page, 'movie/popular');
        resultList.addAll(data.results ?? []);
      }

      if (resultList.isNotEmpty) {
        emit(PopularMoviesStates.isLoaded(
            resultModel: resultList, message: 'Movies Loaded.', totalPages: totalPages));
      } else {
        emit(const PopularMoviesStates.isError(errorMessage: 'No Data Found.'));
      }
    } on SocketException catch (e) {
      emit(PopularMoviesStates.isError(errorMessage: e.message));
    }
  }
}
