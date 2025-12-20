part of '../recording_screen.dart';

class RecordingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RecordingStatus status;

  const RecordingAppBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecorderBloc, RecorderState>(
      builder: (context, state) {
        return AppBarUtil(
          title:
              (state.status == RecordingStatus.idle)
                  ? AppLocalizations.of(context)!.initRecTxt
                  : (state.status == RecordingStatus.recording)
                  ? AppLocalizations.of(context)!.progRecTxt
                  : (state.status == RecordingStatus.stopped)
                  ? AppLocalizations.of(context)!.complRecTxt
                  : (state.status == RecordingStatus.paused)
                  ? AppLocalizations.of(context)!.pauseRecTxt
                  : AppLocalizations.of(context)!.welcomeTxt,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
