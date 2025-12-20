import 'package:ai_scribe_copilot/models/session/session_model.dart';

abstract class SessionRepo {
  Future<SessionModel> fetchPatientSessionByPatientId(
    Map<String, String> headers,
    var data,
  );
}
