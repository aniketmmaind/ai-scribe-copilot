part of '../recording_screen.dart';

class LiveTranscriptView extends StatelessWidget {
  final String transcript;

  const LiveTranscriptView({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;
    // if (transcript.isEmpty) return const SizedBox();

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              (transcript.isEmpty)
                  ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.trnscrptTxt,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  )
                  : SingleChildScrollView(
                    reverse: true,
                    child: Text(
                      transcript,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
        ),
        BlocBuilder<RecorderBloc, RecorderState>(
          builder: (context, state) {
            final hasTranscript = state.liveTranscript.trim().isNotEmpty;
            final canShare =
                hasTranscript &&
                (state.status != RecordingStatus.recording &&
                    state.status == RecordingStatus.stopped);

            if (!canShare) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: IconButton(
                tooltip: "Share Transcript",
                icon: const Icon(Icons.share),
                onPressed: () {
                  final transcript = state.liveTranscript;
                  final patientName =
                      context
                          .read<PatientDetailBloc>()
                          .state
                          .patientDetailModel
                          ?.name;

                  ShareUtil.shareTranscriptAsTxt(
                    context,
                    transcript,
                    patientName: patientName,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
