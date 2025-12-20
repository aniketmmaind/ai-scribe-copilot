import 'package:ai_scribe_copilot/models/patients/added_patient_model.dart';
import 'package:ai_scribe_copilot/repositories/add_patient/add_patient_repo.dart';
import '../../config/api_urls.dart';
import '../../config/network/network_services_api.dart';

class AddPatientByuseridRepo implements AddPatientRepo {
  final api = NetworkServicesApi();

  @override
  Future<AddedPatientModel> addPatientByUserId(
    Map<String, String> headers,
    userId,
  ) {
    final response = api.postApi(
      "${AppUrls.baseUrl}/api/v1/add-patient-ext",
      userId,
      headers,
    );
    return response.then((value) => AddedPatientModel.fromJson(value));
  }
}
