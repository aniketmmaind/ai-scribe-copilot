// add type of API here get, post, delete, etc.
abstract class BaseApiServices {
  Future<dynamic> getApi(String url, var headers);
  Future<dynamic> postApi(String url, var body, var headers);
  Future<dynamic> putApi(String url, var body, var headers);
}
