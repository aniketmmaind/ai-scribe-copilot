import 'package:ai_scribe_copilot/models/session/session_model.dart';
import 'package:ai_scribe_copilot/repositories/session/session_repo.dart';
import '../../config/api_urls.dart';
import '../../config/network/network_services_api.dart';

class FetchSessionRepo implements SessionRepo {
  final api = NetworkServicesApi();

  @override
  Future<SessionModel> fetchPatientSessionByPatientId(
    Map<String, String> headers,
    patientId,
  ) {
    final response = api.getApi(
      "${AppUrls.baseUrl}/api/v1/fetch-session-by-patient/$patientId",
      headers,
    );
    return response.then((resp) => SessionModel.fromJson(resp));
  }
}
