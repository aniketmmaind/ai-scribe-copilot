import 'package:ai_scribe_copilot/bloc/add_patient/add_patient_bloc.dart';
import 'package:ai_scribe_copilot/bloc/patient/patient_bloc.dart';
import 'package:ai_scribe_copilot/models/patients/patients_list_model.dart';
import 'package:ai_scribe_copilot/services/haptic_manager/haptic_controller.dart';
import 'package:ai_scribe_copilot/utils/app_bar_util.dart';
import 'package:ai_scribe_copilot/utils/app_textfield_util.dart';
import 'package:ai_scribe_copilot/utils/dropdown_util.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:ai_scribe_copilot/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/app_button_util.dart';

part '../add_petients/widgets/background_textfield_widget.dart';
part '../add_petients/widgets/email_textfield_widget.dart';
part '../add_petients/widgets/fullname_textfield_widget.dart';
part '../add_petients/widgets/multi_textfield_widget.dart';
part '../add_petients/widgets/pronoun_drop_widget.dart';
part '../add_petients/widgets/patient_app_bar.dart';
part '../add_petients/widgets/add_patient_button_widget.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode backgroundFocusNode = FocusNode();
  FocusNode mediHistFocusNode = FocusNode();
  FocusNode socialHistFocusNode = FocusNode();
  FocusNode prevTreatFocusNode = FocusNode();
  FocusNode familyHistFocusNode = FocusNode();

  // Pronoun dropdown values
  final List<String> pronouns = [
    "She/Her",
    "He/Him",
    "They/Them",
    "Prefer not to say",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PatientAppBar(title: AppLocalizations.of(context)!.addPatientTxt),

      body: SafeArea(
        child: BlocBuilder<AddPatientBloc, AddPatientState>(
          buildWhen:
              (previous, current) =>
                  (previous.status != current.status ||
                      previous.formKeyId != current.formKeyId),
          builder: (context, state) {
            return SingleChildScrollView(
              key: ValueKey(state.formKeyId), // THIS CLEARS ALL FIELDS
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FullnameTextfieldWidget(
                      focusNode: fullNameFocusNode,
                      formKeyId: state.formKeyId,
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        PronounDropWidget(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: EmailTextfieldWidget(
                            focusNode: emailFocusNode,
                            formKeyId: state.formKeyId,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    BackgroundTextfieldWidget(
                      focusNode: backgroundFocusNode,
                      formKeyId: state.formKeyId,
                    ),
                    const SizedBox(height: 18),

                    MultiTextfieldWidget(
                      focusNode: mediHistFocusNode,
                      formKeyId: state.formKeyId,
                      label: AppLocalizations.of(context)!.mediTxt,
                      icon: Icons.healing,
                      theme: theme,
                      onChanged: (mediHist) {
                        context.read<AddPatientBloc>().add(
                          MediHistChangeEvent(mediHist: mediHist),
                        );
                      },
                    ),
                    MultiTextfieldWidget(
                      focusNode: familyHistFocusNode,
                      formKeyId: state.formKeyId,
                      label: AppLocalizations.of(context)!.familyTxt,
                      icon: Icons.group,
                      theme: theme,
                      onChanged: (familyHist) {
                        context.read<AddPatientBloc>().add(
                          FamilyHistChangeEvent(familyHist: familyHist),
                        );
                      },
                    ),
                    MultiTextfieldWidget(
                      focusNode: socialHistFocusNode,
                      formKeyId: state.formKeyId,
                      label: AppLocalizations.of(context)!.socialTxt,
                      icon: Icons.people_alt_outlined,
                      theme: theme,
                      onChanged: (socialHist) {
                        context.read<AddPatientBloc>().add(
                          SocialHistChangeEvent(socialHist: socialHist),
                        );
                      },
                    ),
                    MultiTextfieldWidget(
                      focusNode: prevTreatFocusNode,
                      formKeyId: state.formKeyId,
                      label: AppLocalizations.of(context)!.prevTxt,
                      icon: Icons.medical_services_outlined,
                      theme: theme,
                      onChanged: (prevHist) {
                        context.read<AddPatientBloc>().add(
                          PrevHistChangeEvent(prevHist: prevHist),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    AddPatientButtonWidget(formKey: _formKey),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
