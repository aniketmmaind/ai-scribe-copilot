part of '../session_list_screen.dart';

class SessionListItem extends StatelessWidget {
  final Session session;
  final VoidCallback? onTap;

  const SessionListItem({super.key, required this.session, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesName.sessionDetailScreen,
          arguments: {
            'sessionTitle': session.sessionTitle,
            'sessionSummary': session.sessionSummary,
            'patientName':
                context
                    .read<PatientDetailBloc>()
                    .state
                    .patientDetailModel!
                    .name ??
                "",
            'date': DateFormat("dd MMM yyyy").format(session.date!).toString(),
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            // Leading Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            // Title + Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.date.toString().split(" ")[0].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.startTime.toString().split(" ")[1].toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
