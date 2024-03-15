part of 'popular_movies_bloc.dart';

@immutable
abstract class PopularMoviesState {
  const PopularMoviesState();
}

class PopularMoviesStates extends PopularMoviesState {
  final ApiStatus status;
  final List<ResultModel>? resultModel;
  final String? errorMessage;
  final String? message;
  final int? totalPages;

  const PopularMoviesStates._(
      {required this.status, this.resultModel, this.errorMessage, this.message, this.totalPages});

  const PopularMoviesStates.isInitial() : this._(status: ApiStatus.isInitial);
  const PopularMoviesStates.isAdding() : this._(status: ApiStatus.isAdding);
  const PopularMoviesStates.isLast() : this._(status: ApiStatus.isLast);

  const PopularMoviesStates.isLoaded({
    required List<ResultModel>? resultModel,
    required String? message,
    required int? totalPages,
  }) : this._(status: ApiStatus.isLoaded, resultModel: resultModel, message: message,  totalPages: totalPages);

  const PopularMoviesStates.isLoading() : this._(status: ApiStatus.isLoading);

  const PopularMoviesStates.isError({required String? errorMessage})
      : this._(status: ApiStatus.isError, errorMessage: errorMessage);
}
