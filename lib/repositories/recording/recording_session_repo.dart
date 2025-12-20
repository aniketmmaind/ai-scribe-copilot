import 'package:ai_scribe_copilot/config/api_urls.dart';
import 'package:ai_scribe_copilot/config/network/network_services_api.dart';
import 'package:ai_scribe_copilot/models/recorder/presigned_model.dart';

import 'recoding_base.dart';

class RecordingSessionRepo implements RecodingBase {
  final api = NetworkServicesApi();
  @override
  Future<String> createSession(Map<String, String> headers, data) {
    final response = api.postApi(
      "${AppUrls.baseUrl}/api/v1/upload-session",
      data,
      headers,
    );
    return response.then((value) => value['id'].toString());
  }

  @override
  Future<PresignedModel> getPresignedUrl(Map<String, String> headers, data) {
    final response = api.postApi(
      "${AppUrls.baseUrl}/api/v1/get-presigned-url",
      data,
      headers,
    );
    return response.then((value) => PresignedModel.fromJson(value));
  }

  @override
  Future<bool> setRecording(
    String url,
    Map<String, String> headers,
    data,
  ) async {
    try {
      await api.putApi(url, data, headers);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> notifyChunckRecording(
    Map<String, String> headers,
    dynamic data,
  ) async {
    try {
      await api.postApi(
        "${AppUrls.baseUrl}/api/v1/notify-chunk-uploaded",
        data,
        headers,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
