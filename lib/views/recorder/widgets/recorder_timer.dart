part of '../recording_screen.dart';
class RecorderTimer extends StatelessWidget {
  final Duration duration;

  const RecorderTimer({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String two(int n) => n.toString().padLeft(2, '0');

    final minutes = two(duration.inMinutes.remainder(60));
    final seconds = two(duration.inSeconds.remainder(60));

    return Text(
      "$minutes:$seconds",
      style: textTheme.displayMedium!.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
