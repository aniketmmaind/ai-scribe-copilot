import 'package:ai_scribe_copilot/bloc/patient_details/patient_detail_bloc.dart';
import 'package:ai_scribe_copilot/config/routes/routes_name.dart';
import 'package:ai_scribe_copilot/models/patients/patients_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientTileWidget extends StatelessWidget {
  final Patient patient;

  const PatientTileWidget({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        context.read<PatientDetailBloc>().add(
          FetchtPatientDetailsEvent(patientId: patient.id!),
        );

        Navigator.pushNamed(
          context,
          RoutesName.patientDetailsScreen,
          arguments: {'name': patient.name},
        );
      },
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.15),
          ),
        ),

        child: Row(
          children: [
            // Avatar Circle
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              child: Icon(
                Icons.person,
                size: 30,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 16),

            // Name + Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name!,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    patient.email ?? "",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.textTheme.bodySmall!.color,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
