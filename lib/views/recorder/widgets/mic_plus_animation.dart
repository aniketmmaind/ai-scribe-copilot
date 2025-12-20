part of '../recording_screen.dart';

class MicPulseAnimation extends StatelessWidget {
  final bool isRecording;

  const MicPulseAnimation({super.key, required this.isRecording});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: Duration(milliseconds: 600),
      scale: isRecording ? 1.25 : 1.0,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.red.withOpacity(0.2),
        child: Icon(Icons.mic, color: Colors.red, size: 48),
      ),
    );
  }
}
