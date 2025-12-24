import 'dart:async';
import 'package:ai_scribe_copilot/bloc/patient/patient_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_event.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:ai_scribe_copilot/views/home/widgets/app_drawer_widget.dart';
import 'package:ai_scribe_copilot/views/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_scribe_copilot/l10n/app_localizations.dart';

import '../../config/routes/routes_name.dart';
import '../../services/haptic_manager/haptic_controller.dart';
import '../../utils/empty_list_util.dart';
import '../../utils/failure_util.dart';
import 'widgets/patient_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _autoDrainTimer;
  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<PatientBloc>(context).state.patientListModel == null ||
        BlocProvider.of<PatientBloc>(context).state.patientStatus ==
            PatientStatus.initial) {
      //only work at first time when visit this screen
      context.read<PatientBloc>().add(LoadInitialPatientListEvent());
    }

    _autoDrainTimer = Timer.periodic(Duration(seconds: 5), (_) {
      if (context.mounted) {
        context.read<RecorderBloc>().add(AutoDrainQueueEvent());
      }
    });
  }

  @override
  void dispose() {
    _autoDrainTimer?.cancel();
    super.dispose();
  }

  Future<void> _onPatientListRefresh() async {
    context.read<PatientBloc>().add(RefreshPatientListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(title: AppLocalizations.of(context)!.patientLstTxt),
      drawer: AppDrawerWidget(
        profileUrl: "https://i.pravatar.cc/150?img=3",
        currentLanguage: "hi",
      ),

      body: RefreshIndicator(
        onRefresh: _onPatientListRefresh,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 5.0),
          child: BlocBuilder<PatientBloc, PatientState>(
            buildWhen:
                (previous, current) =>
                    previous.patientStatus != current.patientStatus,

            builder: (context, state) {
              switch (state.patientStatus) {
                case PatientStatus.loading:
                  return Center(child: CircularProgressIndicator());
                case PatientStatus.failure:
                  return Center(
                    child: FailureUtil(
                      title: state.message!,
                      message: AppLocalizations.of(context)!.tryLaterTxt,
                    ),
                  );
                case PatientStatus.success:
                  final patientList = state.patientListModel!.patients;
                  if (patientList.isEmpty) {
                    return EmptyListUtil(
                      title: AppLocalizations.of(context)!.noPatientTxt,
                      message:
                          "${AppLocalizations.of(context)!.pullrefTxt} ${AppLocalizations.of(context)!.addPatientTxt}",
                      icon: Icons.badge_outlined,
                    );
                  }
                  return ListView.separated(
                    itemCount: patientList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return PatientTileWidget(patient: patientList[index]);
                    },
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.addPatientTxt,
        child: Icon(Icons.person_add_alt),
        onPressed: () {
          HapticFeedbackManager.trigger(HapticType.light);
          Navigator.pushNamed(context, RoutesName.addPatientScreen);
        },
      ),
    );
  }
}
