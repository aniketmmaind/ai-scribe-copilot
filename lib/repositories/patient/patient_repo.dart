import 'package:ai_scribe_copilot/models/patients/patient_detail_model.dart';
import 'package:ai_scribe_copilot/models/patients/patients_list_model.dart';

abstract class PatientRepo {
  Future<PatientListModel> fetchPatientByUserId(
    Map<String, String> headers,
    var data,
  );
  Future<PatientDetailModel> fetchPatientByPatientId(
    Map<String, String> headers,
    String patientId,
  );
}
