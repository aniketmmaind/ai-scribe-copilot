import 'package:ai_scribe_copilot/models/user/user_model.dart';
import 'package:ai_scribe_copilot/repositories/login/login_repo.dart';
import '../../config/api_urls.dart';
import '../../config/network/network_services_api.dart';

class LoginUserRepo implements LoginRepo {
  final api = NetworkServicesApi();

  @override
  Future<UserModel> loginUser(Map<String, String> headers, data) {
    final response = api.postApi(
      "${AppUrls.baseUrl}/api/auth/login",
      data,
      headers,
    );

    return response.then((value) => UserModel.fromJson(value));
  }
}
