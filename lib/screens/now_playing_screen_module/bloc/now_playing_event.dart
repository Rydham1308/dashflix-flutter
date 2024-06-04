part of 'now_playing_bloc.dart';

@immutable
abstract class NowPlayingEvent {}

class GetNowPlayingEvent extends NowPlayingEvent {
  GetNowPlayingEvent();
}