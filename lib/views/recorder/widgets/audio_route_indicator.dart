part of '../recording_screen.dart';

class AudioRouteIndicator extends StatelessWidget {
  const AudioRouteIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioRouteBloc, AudioRouteState>(
      buildWhen: (prev, curr) => prev.route != curr.route,
      builder: (context, state) {
        final _RouteUi ui = _mapRouteToUi(state.route);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ui.bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ui.borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ui.icon, color: ui.iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                ui.label,
                style: TextStyle(
                  color: ui.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _RouteUi _mapRouteToUi(AudioRouteStatus route) {
    switch (route) {
      case AudioRouteStatus.bluetooth:
        return _RouteUi(
          label: "Bluetooth Mic",
          icon: Icons.bluetooth_audio,
          bgColor: Colors.blue.withOpacity(0.12),
          borderColor: Colors.blue,
          iconColor: Colors.blue,
          textColor: Colors.blue,
        );

      case AudioRouteStatus.wiredHeadset:
        return _RouteUi(
          label: "Wired Mic",
          icon: Icons.headset_mic,
          bgColor: Colors.green.withOpacity(0.12),
          borderColor: Colors.green,
          iconColor: Colors.green,
          textColor: Colors.green,
        );

      default:
        return _RouteUi(
          label: "Phone Mic",
          icon: Icons.mic,
          bgColor: Colors.orange.withOpacity(0.12),
          borderColor: Colors.orange,
          iconColor: Colors.orange,
          textColor: Colors.orange,
        );
    }
  }
}

/// Small private UI model (clean separation)
class _RouteUi {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  _RouteUi({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });
}
