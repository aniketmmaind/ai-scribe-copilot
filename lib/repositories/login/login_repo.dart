import 'package:ai_scribe_copilot/models/user/user_model.dart';

abstract class LoginRepo {
  Future<UserModel> loginUser(Map<String, String> headers, var data);
}
