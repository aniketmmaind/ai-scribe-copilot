import '../../models/patients/added_patient_model.dart';

abstract class AddPatientRepo {
  Future<AddedPatientModel> addPatientByUserId(
    Map<String, String> headers,
    var data,
  );
}
