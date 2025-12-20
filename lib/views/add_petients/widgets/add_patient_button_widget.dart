part of '../add_patients_screen.dart';

class AddPatientButtonWidget extends StatelessWidget {
  final formKey;
  const AddPatientButtonWidget({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPatientBloc, AddPatientState>(
      listenWhen: (previous, current) => previous.status != current.status,
      buildWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PatientStatus.success) {
          SnackbarUtil.showSnckBar(
            context,
            "${AppLocalizations.of(context)!.welcomeTxt}  ❤❤",
          );
          context.read<PatientBloc>().add(
            AddPatientToListEvent(
              Patient(
                id: state.addedPatientModel!.patient!.id,
                name: state.addedPatientModel!.patient!.name ?? "",
                email: state.patientRequestModel.email ?? "",
              ),
            ),
          );
        } else if (state.status == PatientStatus.failure) {
          SnackbarUtil.showSnckBar(context, state.message.toString());
        }
      },
      builder: (context, state) {
        return AppButton(
          text: AppLocalizations.of(context)!.addPatientTxt,
          isLoading: state.status == PatientStatus.loading,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              HapticFeedbackManager.trigger(HapticType.success);
              context.read<AddPatientBloc>().add(AddPatientsButtonPressed());
            }
            HapticFeedbackManager.trigger(HapticType.error);
          },
        );
      },
    );
  }
}
