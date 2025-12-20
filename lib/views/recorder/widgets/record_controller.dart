part of '../recording_screen.dart';

class RecorderControls extends StatelessWidget {
  final RecorderState state;

  const RecorderControls({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case RecordingStatus.idle:
        return _buildStart(context);

      case RecordingStatus.loading:
        return _buildLoading(context);

      case RecordingStatus.recording:
        return _buildRecording(context);

      case RecordingStatus.paused:
        return _buildPaused(context);

      default:
        return _buildStart(context);
    }
  }

  Widget _buildStart(BuildContext context) {
    return AppButton(
      tooltipMsg: "Start Recording",
      text: AppLocalizations.of(context)!.startTxt,
      onPressed: () {
        context.read<RecorderBloc>().add(
          StartRecording(
            patientId:
                context
                    .read<PatientDetailBloc>()
                    .state
                    .patientDetailModel!
                    .patientId
                    .toString(),
            userId: SessionController.user!.id!,
            patientName:
                context
                    .read<PatientDetailBloc>()
                    .state
                    .patientDetailModel!
                    .name
                    .toString(),
          ),
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return AppButton(
      tooltipMsg: "Loading",
      text: "",
      isLoading: true,
      onPressed: () {},
    );
  }

  Widget _buildRecording(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            tooltipMsg: "Pause",
            text: AppLocalizations.of(context)!.pauseTxt,
            onPressed: () {
              context.read<RecorderBloc>().add(PauseRecording());
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: AppButton(
            tooltipMsg: "Complete",
            text: AppLocalizations.of(context)!.complTxt,
            onPressed: () async {
              final bloc = context.read<RecorderBloc>();
              bloc.add(PauseRecording());
              final confirmed = await ConfirmationDialogUtil.show(
                context: context,
                title: AppLocalizations.of(context)!.wCmplRecTxt,
                message:
                    "${AppLocalizations.of(context)!.recQue1Txt} ${AppLocalizations.of(context)!.recQue2Txt}",
                confirmText: AppLocalizations.of(context)!.complTxt,
                cancelText: AppLocalizations.of(context)!.conRecTxt,
                isDestructive: true,
              );
              if (!context.mounted) return;
              if (!confirmed) {
                bloc.add(ResumeRecording());
              } else {
                bloc.add(StopRecording());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaused(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            tooltipMsg: "Resume",
            text: AppLocalizations.of(context)!.resumeTxt,
            onPressed: () {
              if (!state.autoPause) {
                context.read<RecorderBloc>().add(ResumeRecording());
                return;
              }
              SnackbarUtil.showSnckBar(context, "Phone Call is Inprogress...");
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: AppButton(
            tooltipMsg: "Complete",
            text: AppLocalizations.of(context)!.complTxt,
            onPressed: () async {
              final bloc = context.read<RecorderBloc>();
              bloc.add(PauseRecording());
              final confirmed = await ConfirmationDialogUtil.show(
                context: context,
                title: AppLocalizations.of(context)!.wCmplRecTxt,
                message:
                    "${AppLocalizations.of(context)!.recQue1Txt} ${AppLocalizations.of(context)!.recQue2Txt}",
                confirmText: AppLocalizations.of(context)!.complTxt,
                cancelText: AppLocalizations.of(context)!.conRecTxt,
                isDestructive: true,
              );
              if (!context.mounted) return;
              if (!confirmed) {
                bloc.add(ResumeRecording());
              } else {
                bloc.add(StopRecording());
              }
            },
          ),
        ),
      ],
    );
  }
}
