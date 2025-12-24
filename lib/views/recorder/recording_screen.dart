import 'package:ai_scribe_copilot/bloc/recorder/recorder_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_state.dart';
import 'package:ai_scribe_copilot/utils/app_bar_util.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:ai_scribe_copilot/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/audio_route/audio_route_bloc.dart';
import '../../bloc/patient_details/patient_detail_bloc.dart';
import '../../bloc/recorder/recorder_event.dart';
import '../../services/session_manager/session_controller.dart';
import '../../utils/app_button_util.dart';
import '../../utils/confirmation_dialog_util.dart';
import '../../utils/share_data_util.dart';
import 'package:ai_scribe_copilot/l10n/app_localizations.dart';

part 'widgets/mic_plus_animation.dart';
part 'widgets/record_controller.dart';
part 'widgets/recorder_timer.dart';
part 'widgets/waveform_placeholder.dart';
part 'widgets/recording_app_bar.dart';
part 'widgets/audio_route_indicator.dart';
part 'widgets/live_transcript_view.dart';

class RecordingScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  const RecordingScreen({super.key, this.args});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: RecordingAppBar(
        status: context.read<RecorderBloc>().state.status,
      ),
      body: SingleChildScrollView(
        child: MultiBlocListener(
          listeners: [
            BlocListener<AudioRouteBloc, AudioRouteState>(
              listener: (context, autioState) {
                final recorderBloc = context.read<RecorderBloc>();
                if (autioState.route == AudioRouteStatus.speaker) {
                  SnackbarUtil.showSnckBar(
                    context,
                    "Connected to Phone mic...",
                    showOnTop: true,
                  );
                } else if (autioState.route == AudioRouteStatus.bluetooth) {
                  SnackbarUtil.showSnckBar(
                    context,
                    "Connected to Bluetooth mic...",
                    showOnTop: true,
                  );
                } else if (autioState.route == AudioRouteStatus.wiredHeadset) {
                  SnackbarUtil.showSnckBar(
                    context,
                    "Connected to Wired mic...",
                    showOnTop: true,
                  );
                }
                // Restart recorder safely on route change
                if (recorderBloc.state.status == RecordingStatus.recording) {
                  recorderBloc.add(PauseRecording(isFromCall: false));
                }
              },
            ),

            BlocListener<RecorderBloc, RecorderState>(
              listenWhen:
                  (previous, current) =>
                      current.status == RecordingStatus.error,
              listener: (context, recordState) {
                SnackbarUtil.showSnckBar(context, recordState.message!);
              },
            ),
          ],
          child: BlocBuilder<RecorderBloc, RecorderState>(
            builder: (context, state) {
              final transcript =
                  _isShowTranscript(context) ? state.liveTranscript : "";
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Mic Animation
                    MicPulseAnimation(
                      isRecording: state.status == RecordingStatus.recording,
                    ),

                    const SizedBox(height: 12),

                    const AudioRouteIndicator(),

                    const SizedBox(height: 15),
                    // Timer
                    RecorderTimer(duration: state.duration),

                    const SizedBox(height: 15),

                    // Waveform Container
                    WaveformPlaceholder(),

                    const SizedBox(height: 10),

                    LiveTranscriptView(transcript: transcript),
                    const SizedBox(height: 20),

                    // Controls
                    RecorderControls(state: state),

                    const SizedBox(height: 20),

                    // Check Queue Button just for testing
                    //i.e. data is adding to queue or not for async data transfer
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton.icon(
                    //     icon: const Icon(Icons.queue_music),
                    //     label: const Text("Check Queue"),
                    //     style: ElevatedButton.styleFrom(
                    //       padding: const EdgeInsets.symmetric(vertical: 14),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //       backgroundColor: theme.colorScheme.primary,
                    //     ),
                    //     onPressed: () async {
                    //       final rows = await LocalDb.instance.query(
                    //         'pending_chunks',
                    //       );

                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(content: Text('Queued: ${rows.length}')),
                    //       );
                    //       LocalDb.instance.delete(
                    //         'pending_chunks',
                    //         "status = ?",
                    //         ["pending"],
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _isShowTranscript(BuildContext context) {
    final recPId = context.read<RecorderBloc>().state.patientId ?? "";
    final detaPId =
        context.read<PatientDetailBloc>().state.patientDetailModel!.patientId ??
        "";
    return (recPId == detaPId) ? true : false;
  }
}
