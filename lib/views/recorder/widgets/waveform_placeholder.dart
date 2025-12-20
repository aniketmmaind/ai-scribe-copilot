part of '../recording_screen.dart';

class WaveformPlaceholder extends StatelessWidget {
  const WaveformPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color:
            isDark
                ? Colors.grey[900]
                : Colors.grey[100], // subtle waveform background
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<RecorderState>(
        stream: BlocProvider.of<RecorderBloc>(context).stream,
        initialData: BlocProvider.of<RecorderBloc>(context).state,
        builder: (context, snapshot) {
          final state = snapshot.data!;
          final waveform = state.waveform;

          return (waveform.isEmpty)
              ? Center(
                child: Text(
                  AppLocalizations.of(context)!.waveformTxt,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              )
              : Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      waveform
                          .map(
                            (db) => WaveformBars(
                              db: db,
                              color:
                                  isDark
                                      ? Colors.tealAccent
                                      : Colors.blueAccent,
                            ),
                          )
                          .toList(),
                ),
              );
        },
      ),
    );
  }
}

class WaveformBars extends StatelessWidget {
  final double db;
  final Color color;

  const WaveformBars({super.key, required this.db, required this.color});

  @override
  Widget build(BuildContext context) {
    final height = ((db + 60).clamp(4, 150)).toDouble();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      height: height,
      width: 4,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
