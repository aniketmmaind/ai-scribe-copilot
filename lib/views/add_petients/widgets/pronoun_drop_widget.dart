part of '../add_patients_screen.dart';

class PronounDropWidget extends StatelessWidget {
  const PronounDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPatientBloc, AddPatientState>(
      buildWhen:
          (previous, current) =>
              previous.patientRequestModel.pronoun !=
              current.patientRequestModel.pronoun,
      builder: (context, state) {
        return DropdownUtil<String>(
          value: state.patientRequestModel.pronoun!,
          items: [
            "She/Her",
            "He/Him",
            "They/Them",
            "Prefer not to say",
            "Other",
          ],
          labelBuilder:
              (pronoun) =>
                  pronoun == "She/Her"
                      ? "She/Her"
                      : pronoun == "He/Him"
                      ? "He/Him"
                      : pronoun == "They/Them"
                      ? "They/Them"
                      : pronoun == "Prefer not to say"
                      ? "Prefer not to say"
                      : "Other",
          onChanged: (value) {
            context.read<AddPatientBloc>().add(
              PronounChangeEvent(pronoun: value!),
            );
          },
        );
      },
    );
  }
}
