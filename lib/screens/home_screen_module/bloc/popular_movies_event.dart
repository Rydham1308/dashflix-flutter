part of 'popular_movies_bloc.dart';

@immutable
abstract class PopularMoviesEvent {}

class GetPopularMoviesEvent extends PopularMoviesEvent {
  GetPopularMoviesEvent();
}
