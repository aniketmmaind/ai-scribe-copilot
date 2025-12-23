part of 'patient_info_section.dart';

class PatientDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const PatientDetailAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBarUtil(
      title: title,
      actions: [
        IconButton(
          tooltip: AppLocalizations.of(context)!.sessionlstTxt,
          onPressed: () {
            PatientDetailsStatus status =
                context.read<PatientDetailBloc>().state.status;

            if (status == PatientDetailsStatus.initial) {
              String patientId =
                  context
                      .read<PatientDetailBloc>()
                      .state
                      .patientDetailModel!
                      .patientId!;
              context.read<SessionBloc>().add(
                LoadInitialSesionListEvent(patientId: patientId),
              );
            }
            Navigator.pushNamed(context, RoutesName.sessionListScreen);
          },
          icon: Icon(Icons.history),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
