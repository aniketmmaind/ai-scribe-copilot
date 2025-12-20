import 'package:ai_scribe_copilot/bloc/recorder/recorder_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingGainController extends StatelessWidget {
  final double gain;
  const RecordingGainController({super.key, required this.gain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.graphic_eq,
                color: theme.colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                "Mic Gain",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "${gain.toStringAsFixed(1)}×",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Gain Slider
          Slider(
            value: gain,
            min: 0.1,
            max: 2.0,
            divisions: 30,
            activeColor: theme.colorScheme.primary,
            thumbColor: theme.colorScheme.primary,
            onChanged: (value) {
              context.read<RecorderBloc>().add(SetGainEvent(gain: value));
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Low Sensitivity", style: theme.textTheme.bodySmall),
              Text("High Sensitivity", style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
