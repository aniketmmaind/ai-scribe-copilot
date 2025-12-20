import 'package:ai_scribe_copilot/models/patients/patient_detail_model.dart';
import 'package:ai_scribe_copilot/models/patients/patients_list_model.dart';
import 'package:ai_scribe_copilot/repositories/patient/patient_repo.dart';
import '../../config/api_urls.dart';
import '../../config/network/network_services_api.dart';

class FetchPatientsRepo implements PatientRepo {
  final api = NetworkServicesApi();

  @override
  Future<PatientListModel> fetchPatientByUserId(
    Map<String, String> headers,
    data,
  ) {
    String pathUrl = "${AppUrls.baseUrl}/api/v1/patients";
    final url = Uri.parse(pathUrl).replace(queryParameters: data);
    final response = api.getApi(url.toString(), headers);
    return response.then((resp) => PatientListModel.fromJson(resp));
  }

  @override
  Future<PatientDetailModel> fetchPatientByPatientId(
    Map<String, String> headers,
    patientId,
  ) {
    final response = api.getApi(
      "${AppUrls.baseUrl}/api/v1/patient-details/$patientId",
      headers,
    );
    return response.then((resp) => PatientDetailModel.fromJson(resp));
  }
}
