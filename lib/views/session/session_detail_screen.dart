import 'package:ai_scribe_copilot/utils/app_bar_util.dart';
import 'package:ai_scribe_copilot/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/share_data_util.dart';

class SessionDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? args;

  const SessionDetailScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String sessionTitle =
        args?['sessionTitle'] ?? AppLocalizations.of(context)!.sessionSumTxt;
    final String patientName =
        args?['patientName'] ?? AppLocalizations.of(context)!.notprovTxt;
    final String sessionSummary =
        args?['sessionSummary'] ?? AppLocalizations.of(context)!.summaryErrTxt;

    final String date = args?['date'] ?? "Unknown date";

    return Scaffold(
      appBar: AppBarUtil(title: AppLocalizations.of(context)!.sessiondtlTxt),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Text(
                sessionTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                patientName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // DIVIDER
              Divider(color: theme.dividerColor.withOpacity(0.5)),

              const SizedBox(height: 16),

              // SUMMARY LABEL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.summaryTxt,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.shareSummTxt,
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      if (sessionSummary.trim().isEmpty) {
                        SnackbarUtil.showSnckBar(
                          context,
                          AppLocalizations.of(context)!.shareErrTxt,
                        );
                      } else {
                        ShareUtil.shareTranscriptAsTxt(
                          context,
                          sessionSummary,
                          patientName: args!['patientName'] ?? "",
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // SUMMARY CONTENT
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    sessionSummary,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      fontSize: 16,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
