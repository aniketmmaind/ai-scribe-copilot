import 'package:ai_scribe_copilot/bloc/patient_details/patient_detail_bloc.dart';
import 'package:ai_scribe_copilot/bloc/session/session_bloc.dart';
import 'package:ai_scribe_copilot/config/routes/routes_name.dart';
import 'package:ai_scribe_copilot/utils/app_bar_util.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_scribe_copilot/l10n/app_localizations.dart';
part 'detail_card.dart';
part 'info_row.dart';
part 'section_title.dart';
part 'patient_detailapp_bar.dart';

class PatientInfoSection extends StatelessWidget {
  final String title;
  final Map<String, String> data;

  const PatientInfoSection({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title),
          const SizedBox(height: 12),
          ...data.entries.map((e) => InfoRow(label: e.key, value: e.value)),
        ],
      ),
    );
  }
}
