import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ai_scribe_copilot/config/api_urls.dart';
import 'package:http/http.dart' as http;
import '../../services/session_manager/session_controller.dart';
import '../exception/app_exception.dart';
import 'base_api_services.dart';

class NetworkServicesApi implements BaseApiServices {
  dynamic jsonResponse;
  //to get
  @override
  Future<dynamic> getApi(String url, var headers) async {
    return _handleRequest((token) {
      return http
          .get(
            Uri.parse(url),
            headers: {...headers, 'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 50));
    });
  }

  @override
  Future postApi(String url, var body, var headers) async {
    return _handleRequest((token) {
      return http
          .post(
            Uri.parse(url),
            headers: {
              ...headers,
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 50));
    });
  }

  @override
  Future putApi(String url, var body, var headers) async {
    try {
      final response = await http
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(Duration(seconds: 50));
      jsonResponse = httpResponse(response);
    } on SocketException {
      throw NoInternetException(message: "No Internet Connection");
    } on TimeoutException {
      throw TimeOutException();
    }
    return jsonResponse;
  }

  Future<dynamic> _handleRequest(
    Future<http.Response> Function(String token) request,
  ) async {
    try {
      final token = SessionController.authToken;
      if (token == null) throw UnautherizedExeption();

      final response = await request(token);
      return httpResponse(response);
    } on TokenExpiredException {
      final refreshed = await _refreshToken();

      if (!refreshed) {
        await SessionController().deleteValue('auth_token');
        await SessionController().deleteValue('refresh_token');
        throw UnautherizedExeption(
          message: 'Session expired. Please login again.',
        );
      }

      final newToken = SessionController.authToken!;
      final retryResponse = await request(newToken);
      return httpResponse(retryResponse);
    } on InvalidCredentialsException {
      // 🚫 DO NOT refresh

      rethrow;
    } on SocketException catch (e) {
      if (e.message.contains('Failed host lookup')) {
        throw ("No internet connection.");
      } else {
        throw ("Connection failed. The server may be offline.");
      }
    } on http.ClientException catch (e) {
      if (e.message.contains('timed out') || e.message.contains('110')) {
        throw ("Server is unavailable. Please try again later.");
      } else {
        throw ("A network error occurred.");
      }
    } catch (e) {
      // debugPrint("e: ${e.toString()}");
      throw ("An unexpected error occurred.");
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = SessionController.refreshToken;
    if (refreshToken == null) return false;
    final response = await http.post(
      Uri.parse("${AppUrls.baseUrl}/api/auth/refresh"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body);
    await SessionController().saveAuthToken('auth_token', data['authToken']);
    await SessionController().saveRefreshToken(
      'refresh_token',
      data['refreshToken'],
    );

    return true;
  }

  // handle response code and return data or expti.
  dynamic httpResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        //to hadle empty body of put api sometimes.
        if (response.body.isEmpty) {
          return {'success': true};
        }
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      case 201:
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      case 400:
        dynamic jsonResponse = jsonDecode(response.body);
        throw FetchDataException(message: jsonResponse['message'].toString());
      case 401:
        final jsonResponse = jsonDecode(response.body);
        final code = jsonResponse['code'];
        if (code == 'TOKEN_EXPIRED') {
          throw TokenExpiredException(message: jsonResponse['message']);
        }

        if (code == 'INVALID_CREDENTIALS') {
          throw InvalidCredentialsException(message: jsonResponse['message']);
        }

        throw UnautherizedExeption(message: jsonResponse['message']);
      case 500:
        throw FetchDataException(message: 'Error While fetching data');
      default:
        throw FetchDataException(
          message: 'Something wents wrong try again later',
        );
    }
  }
}
