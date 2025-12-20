import 'dart:async';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/audio_route_manager.dart/audio_route_controller.dart';
part 'audio_route_event.dart';
part 'audio_route_state.dart';

class AudioRouteBloc extends Bloc<AudioRouteEvent, AudioRouteState> {
  final AudioRouteListener _listener = AudioRouteListener();
  StreamSubscription? _sub;

  AudioRouteBloc()
    : super(const AudioRouteState(route: AudioRouteStatus.speaker)) {
    on<StartAudioRouteListening>(_onStart);
    on<StopAudioRouteListening>(_onStop);
    on<AudioRouteChanged>(_onChanged);
  }

  Future<void> _onStart(
    StartAudioRouteListening event,
    Emitter<AudioRouteState> emit,
  ) async {
    await _listener.start();

    _sub = _listener.stream.listen((route) {
      add(AudioRouteChanged(route));
    });
  }

  void _onChanged(AudioRouteChanged event, Emitter<AudioRouteState> emit) {
    emit(state.copyWith(route: event.route));
  }

  Future<void> _onStop(
    StopAudioRouteListening event,
    Emitter<AudioRouteState> emit,
  ) async {
    await _sub?.cancel();
    _listener.dispose();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _listener.dispose();
    return super.close();
  }
}
