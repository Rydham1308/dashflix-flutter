import 'dart:io';
import 'package:dashflix/constants/api_status.dart';
import 'package:dashflix/screens/now_playing_screen_module/api/fetch_nowplaying_repository.dart';
import 'package:dashflix/screens/now_playing_screen_module/models/result_nowplaying_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_event.dart';

part 'now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  NowPlayingBloc({required IFetchNowPlayingMoviesRepository nowPlayingMovies})
      : _fetchNowPlayingMovies = nowPlayingMovies,
        super(const NowPlayingMoviesStates.isInitial()) {
    on<GetNowPlayingEvent>(getNowPlayingMovies);
  }

  final IFetchNowPlayingMoviesRepository _fetchNowPlayingMovies;
  List<NowPlayingResultModel> nowPlayingResultList = [];
  int page = 1;
  int totalPages = 0;

  Future<void> getNowPlayingMovies(NowPlayingEvent event, Emitter<NowPlayingState> emit) async {
    try {
      if (nowPlayingResultList.isEmpty) {
        emit(const NowPlayingMoviesStates.isLoading());
        final data = await _fetchNowPlayingMovies.getNowPlayingMovies(page, 'movie/now_playing');
        totalPages = data.totalPages ?? 0;
        nowPlayingResultList = data.results ?? [];
      } else {
        page++;
        // print("page ===  >  $page");
        final data = await _fetchNowPlayingMovies.getNowPlayingMovies(page, 'movie/now_playing');
        nowPlayingResultList.addAll(data.results ?? []);
      }

      if (nowPlayingResultList.isNotEmpty) {
        emit(NowPlayingMoviesStates.isLoaded(
            message: 'Movies Loaded.',
            totalPages: totalPages,
            nowPlayingResultModel: nowPlayingResultList));
      } else {
        emit(const NowPlayingMoviesStates.isError(errorMessage: 'No Data Found.'));
      }
    } on SocketException catch (e) {
      emit(NowPlayingMoviesStates.isError(errorMessage: e.message));
    }
  }
}
