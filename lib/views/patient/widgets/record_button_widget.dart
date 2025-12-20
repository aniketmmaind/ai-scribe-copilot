part of '../patient_details_screen.dart';

class RecordButtonWidget extends StatelessWidget {
  const RecordButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppButton(
        text: AppLocalizations.of(context)!.recordTxt,
        isLoading: false,
        onPressed: () {
          //first to check wheather usser is bussy in another user recording if not then navigate.
          final String recPatientId =
              context.read<RecorderBloc>().state.patientId ?? "";
          final String patientId =
              context
                  .read<PatientDetailBloc>()
                  .state
                  .patientDetailModel!
                  .patientId!;
          final RecordingStatus recordingStatus =
              context.read<RecorderBloc>().state.status;

          if ((recPatientId == patientId) ||
              (recordingStatus == RecordingStatus.stopped ||
                  recordingStatus == RecordingStatus.idle)) {
            HapticFeedbackManager.trigger(HapticType.success);
            Navigator.pushNamed(context, RoutesName.recordingScreen);
            return;
          }
          HapticFeedbackManager.trigger(HapticType.error);
          SnackbarUtil.showSnckBar(
            context,
            "Recording is Inprogress with another user",
          );
        },
      ),
    );
  }
}
