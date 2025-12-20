part of 'audio_route_bloc.dart';

abstract class AudioRouteEvent extends Equatable {}

class StartAudioRouteListening extends AudioRouteEvent {
  @override
  List<Object?> get props => [];
}

class StopAudioRouteListening extends AudioRouteEvent {
  @override
  List<Object?> get props => [];
}

class AudioRouteChanged extends AudioRouteEvent {
  final AudioRouteStatus route;
  AudioRouteChanged(this.route);

  @override
  List<Object?> get props => [route];
}
