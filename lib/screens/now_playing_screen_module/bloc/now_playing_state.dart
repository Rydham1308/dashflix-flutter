part of 'now_playing_bloc.dart';

@immutable
abstract class NowPlayingState {
  const NowPlayingState();
}

final class NowPlayingInitial extends NowPlayingState {}

class NowPlayingMoviesStates extends NowPlayingState {
  final ApiStatus status;
  final List<NowPlayingResultModel>? resultModel;
  final String? errorMessage;
  final String? message;
  final int? totalPages;

  const NowPlayingMoviesStates._(
      {required this.status, this.resultModel, this.errorMessage, this.message, this.totalPages});

  const NowPlayingMoviesStates.isInitial() : this._(status: ApiStatus.isInitial);

  const NowPlayingMoviesStates.isAdding() : this._(status: ApiStatus.isAdding);

  const NowPlayingMoviesStates.isLast() : this._(status: ApiStatus.isLast);

  const NowPlayingMoviesStates.isLoaded({
    required List<NowPlayingResultModel>? nowPlayingResultModel,
    required String? message,
    required int? totalPages,
  }) : this._(
            status: ApiStatus.isLoaded,
            resultModel: nowPlayingResultModel,
            message: message,
            totalPages: totalPages);

  const NowPlayingMoviesStates.isLoading() : this._(status: ApiStatus.isLoading);

  const NowPlayingMoviesStates.isError({required String? errorMessage})
      : this._(status: ApiStatus.isError, errorMessage: errorMessage);
}
