import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:adary/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:http_parser/http_parser.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:http/http.dart' as Http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../model/response/erorr_response.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;

  static String noInternetMessage = AppConstants.NO_INTERNET_MESSAGE.tr;
  final int timeoutInSeconds = 30;

  String? token;
  Map<String, String>? _mainHeaders;

  ApiClient({
    required this.appBaseUrl,
  }) {
    // token = sharedPreferences.getString(AppConstants.token);
    // debugPrint('Token: $token');
    updateHeader();
  }

  void updateHeader() async {
    final user = AppUtils.instance.getUser();

    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      "username": user?.username ?? '',
      "app-key": user?.ky ?? '',
      'Accept-Language': "ar"
    };
    AppUtils.log(_mainHeaders.toString());
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    updateHeader();
    try {
      debugPrint('====> API Call: ${appBaseUrl + uri}\nHeader: $headers');
      Http.Response response = await Http.get(
        Uri.parse(appBaseUrl + uri),
        headers: _mainHeaders ?? headers,
      ).timeout(const Duration(seconds: 240));

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  } // end of getData

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    updateHeader();

    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Call: $uri\nHeader: $headers');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: body,
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  } // end of post data

  Future<Response> postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String>? headers}) async {
    updateHeader();

    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.MultipartRequest _request =
          Http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      _request.headers.addAll(headers!);
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          if (Foundation.kIsWeb) {
            Uint8List _list = await multipart.file.readAsBytes();
            Http.MultipartFile _part = Http.MultipartFile(
              multipart.key,
              multipart.file.readAsBytes().asStream(),
              _list.length,
              filename: basename(multipart.file.path),
              contentType: MediaType('image', 'jpg'),
            );
            _request.files.add(_part);
          } else {
            File _file = File(multipart.file.path);
            _request.files.add(Http.MultipartFile(
              multipart.key,
              _file.readAsBytes().asStream(),
              _file.lengthSync(),
              filename: _file.path.split('/').last,
            ));
          }
        }
      }
      _request.fields.addAll(body);
      Http.Response _response =
          await Http.Response.fromStream(await _request.send());
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  } //postMultipartData

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    updateHeader();

    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.put(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  } // end of put data

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    updateHeader();

    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.delete(
        Uri.parse(appBaseUrl + uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  } // end of delete data

  Response handleResponse(Http.Response response, String uri) {
    updateHeader();

    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body,
      bodyString: response.body.toString(),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _errorResponse.errors[0].message);
      } else if (_response.body.toString().contains('Message')) {
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _response.body['Message']);
      }
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    } else if (_response.statusCode == 500 && _response.body != null) {
      _response = Response(
          statusCode: _response.statusCode,
          body: _response.body,
          statusText: _response.body['Message']);
    }
    debugPrint(
        '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  } // end of handle response
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
