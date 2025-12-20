part of 'audio_route_bloc.dart';

class AudioRouteState extends Equatable {
  final AudioRouteStatus route;

  const AudioRouteState({required this.route});

  AudioRouteState copyWith({AudioRouteStatus? route}) {
    return AudioRouteState(route: route ?? this.route);
  }

  @override
  List<Object?> get props => [route];
}
