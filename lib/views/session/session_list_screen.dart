import 'package:ai_scribe_copilot/bloc/patient_details/patient_detail_bloc.dart';
import 'package:ai_scribe_copilot/bloc/session/session_bloc.dart';
import 'package:ai_scribe_copilot/config/routes/routes_name.dart';
import 'package:ai_scribe_copilot/models/session/session_model.dart';
import 'package:ai_scribe_copilot/utils/empty_list_util.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:ai_scribe_copilot/utils/failure_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ai_scribe_copilot/l10n/app_localizations.dart';
import '../../utils/app_bar_util.dart';
part 'widgets/session_app_bar.dart';
part 'widgets/session_list_item.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshSessionList() async {
    final String patientId =
        context.read<PatientDetailBloc>().state.patientDetailModel!.patientId!;
    context.read<SessionBloc>().add(
      RefreshSessionListEvet(patientId: patientId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String patientName =
        context.read<PatientDetailBloc>().state.patientDetailModel!.name!;
    return Scaffold(
      appBar: SessionAppBar(patienName: patientName),
      body: RefreshIndicator(
        onRefresh: _refreshSessionList,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SessionBloc, SessionState>(
            buildWhen:
                (previous, current) =>
                    previous.sessionStatus != current.sessionStatus,
            builder: (context, state) {
              switch (state.sessionStatus) {
                case SessionStatus.loading:
                  return Center(child: CircularProgressIndicator());
                case SessionStatus.failure:
                  return FailureUtil();
                case SessionStatus.success:
                  final sessionList = state.sessionModel?.sessions;
                  if (sessionList!.isEmpty) {
                    return EmptyListUtil(
                      title: AppLocalizations.of(context)!.noSessionTxt,
                      message:
                          "${AppLocalizations.of(context)!.pullrefTxt} ${AppLocalizations.of(context)!.sessiPullTxt}",
                      icon: Icons.mic_none_outlined,
                    );
                  }
                  return ListView.separated(
                    itemCount: sessionList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return SessionListItem(session: sessionList[index]);
                    },
                  );
                default:
                  return EmptyListUtil(
                    title: AppLocalizations.of(context)!.noSessionTxt,
                    message:
                        "${AppLocalizations.of(context)!.pullrefTxt} ${AppLocalizations.of(context)!.sessiPullTxt}",
                    icon: Icons.mic_none_outlined,
                    onAction: () {
                      final String patientId =
                          context
                              .read<PatientDetailBloc>()
                              .state
                              .patientDetailModel!
                              .patientId!;
                      context.read<SessionBloc>().add(
                        RefreshSessionListEvet(patientId: patientId),
                      );
                    },
                    actionText: "Refresh",
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
