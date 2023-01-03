import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler {
 static String baseurl = "https://backend.adorafrika.com/api";
  var log = Logger();
  Dio dio = Dio();

  Future<Response> get(String url) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    url = formater(url);
    dio.options.contentType = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    return await dio.get(url);
  }

  Future<Response> getwithparams(String url, dynamic params) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    url = formater(url);
    url = url + "/$params";
    dio.options.contentType = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $token";
    return await dio.get(url);
  }

  Future<Response> unsecureget(String url) async {
    url = formater(url);
    dio.options.contentType = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';
    return await dio.get(url);
  }

  Future<Response> unsecurepost(String url, Map<String, dynamic> body) async {
   // url = formater(url);

    return dio.post(url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            "Content-type": "application/json",
            HttpHeaders.contentTypeHeader: "application/json"
          },
        ));
    ;
  }

  Future<Response> post(
      String url, String token, Map<String, String> body) async {
    url = formater(url);
    return await dio.post(url,
        data: jsonEncode(body),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ));
  }

  Future<http.Response> authenticateUser(
      String url, Map<String, String> body) async {
    //url = formater(url);
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {
        "Content-type": "application/json",
      //  HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    return response;
  }

  Future<http.Response?>? postPanegyrique(
      String url, String lienson, Map<String, String> data) async {
    url = formater(url);

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("fichier_audio", lienson));
    request.fields['famille'] = data['famille']!;
    request.fields['region'] = data['region']!;
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      //"Authorization": "Bearer $token"
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String formater(String url) {
    return baseurl + url;
  }

  NetworkImage getImage(String username) {
    String url = formater("/uploads//$username.jpg");
    return NetworkImage(url);
  }
}
