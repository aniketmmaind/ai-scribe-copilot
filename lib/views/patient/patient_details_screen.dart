import 'package:ai_scribe_copilot/bloc/recorder/recorder_bloc.dart';
import 'package:ai_scribe_copilot/config/routes/routes_name.dart';
import 'package:ai_scribe_copilot/services/haptic_manager/haptic_controller.dart';
import 'package:ai_scribe_copilot/utils/app_button_util.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:ai_scribe_copilot/utils/failure_util.dart';
import 'package:ai_scribe_copilot/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/patient_details/patient_detail_bloc.dart';
import '../../models/patients/patient_detail_model.dart';
import 'package:ai_scribe_copilot/l10n/app_localizations.dart';

import 'widgets/patient_info_section.dart';
part 'widgets/record_button_widget.dart';

class PatientDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? args;
  const PatientDetailScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final String name = args?['name'] ?? "Unknown";

    return Scaffold(
      extendBody: true,
      appBar: PatientDetailAppBar(title: name.toString()),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<PatientDetailBloc, PatientDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case PatientDetailsStatus.loading:
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              case PatientDetailsStatus.success:
                return _patientDetails(state.patientDetailModel!, context);
              case PatientDetailsStatus.failure:
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: FailureUtil(
                    message: AppLocalizations.of(context)!.tryLaterTxt,
                  ),
                );
              default:
                return Center(child: Text("PatientDetails"));
            }
          },
        ),
      ),
      floatingActionButton: RecordButtonWidget(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Widget _patientDetails(PatientDetailModel patient, BuildContext context) {
    return Column(
      children: [
        /// Basic Info
        PatientInfoSection(
          title: AppLocalizations.of(context)!.basicInfoTxt,
          data: {
            AppLocalizations.of(context)!.nameTxt: patient.name ?? "",
            AppLocalizations.of(context)!.pronounTxt: patient.pronoun ?? "",
            AppLocalizations.of(context)!.emailTxt: patient.email ?? "",
          },
        ),

        /// Background
        PatientInfoSection(
          title: AppLocalizations.of(context)!.bgTxt,
          data: {AppLocalizations.of(context)!.bgTxt: patient.background ?? ""},
        ),

        /// Histories
        PatientInfoSection(
          title: AppLocalizations.of(context)!.historiesTxt,
          data: {
            AppLocalizations.of(context)!.mediTxt: patient.mediHist ?? "",
            AppLocalizations.of(context)!.familyTxt: patient.familyHist ?? "",
            AppLocalizations.of(context)!.socialTxt: patient.socialHist ?? "",
            AppLocalizations.of(context)!.prevTxt: patient.prevHist ?? "",
          },
        ),
      ],
    );
  }
}
