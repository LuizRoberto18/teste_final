import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:teste_final/models/album.dart';
import 'package:http/http.dart' as http;
import 'package:teste_final/models/error.dart';

import 'dart:convert' as convert;

import 'package:teste_final/models/model_response.dart';

class AlbumApi {
  String _apibase = "https://jsonplaceholder.typicode.com/";
  AlbumApi(this._apibase);
  Future<List<Album>> getAPIAlbums() async {
    var url = Uri.parse(_apibase);
    print("get > $url");

    var response = await http.get(url);
    String json = response.body;
    print(json);
    print("statusCode: ${response.statusCode}");
    List list = convert.json.decode(json);

    final albums = <Album>[];
    for (Map map in list) {
      Album a = Album.fromJson(map as Map<String, dynamic>);
      albums.add(a);
    }
    //List<Album> albums = list.map<Album>(((map) => Album.fromJson(map as Map<String, dynamic>)).toList();

    return albums;
  }

//RETORNANDO LISTA DE DE TODOS OS ALBUMS
  Future<ApiResponse<Album?, ErrorResponse>> fatchAllAlbum() async {
    final url = Uri.parse("${_apibase}/albums");
    try {
      Response response = await http.get(url).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return ApiResponse(
          response: Album.fromJson(json.decode(response.body)),
        );
      } else {
        return ApiResponse(
          hasError: true,
          error: ErrorResponse.fromJson(json.decode(response.body)),
        );
      }
    } on TimeoutException catch (e) {
      return ApiResponse(
        hasError: true,
        error: ErrorResponse(errorCode: 800, errorMessage: e.toString()),
      );
    }
  }

//RETORNANDO ALBUM POR ID
  Future<ApiResponse<Album?, ErrorResponse>> getAlbum(int id) async {
    final url = Uri.parse("${_apibase}/albums/${id}");
    try {
      Response response = await http.get(url).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return ApiResponse(
          response: Album.fromJson(json.decode(response.body)),
        );
      } else {
        return ApiResponse(
          hasError: true,
          error: ErrorResponse.fromJson(json.decode(response.body)),
        );
      }
    } on TimeoutException catch (e) {
      return ApiResponse(
        hasError: true,
        error: ErrorResponse(errorCode: 800, errorMessage: e.toString()),
      );
    }
  }

  //CRIANDO ALBUM
  Future<ApiResponse<Album?, ErrorResponse>> createAlbum(
      int? id, int? userId, String title) async {
    final url = Uri.parse("${_apibase}/albums");
    try {
      Map params = {
        "title": title,
        "id": id,
        "userId": userId,
      };
      /*if (Album != null) {
        Response response = await http
            .post(url, body: json.encode(params))
            .timeout(Duration(seconds: 5));
      }*/
      Response response = await http
          .post(url, body: json.encode(params))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 201) {
        return ApiResponse(
            response: Album.fromJson(json.decode(response.body)));
      } else if (response.statusCode == 409) {
        return ApiResponse(
            hasError: true,
            error: ErrorResponse.fromJson(json.decode(response.body)));
      } else {
        return ApiResponse(
            hasError: true,
            error: ErrorResponse.fromJson(json.decode(response.body)));
      }
    } on TimeoutException catch (e) {
      return ApiResponse(
          hasError: true,
          error: ErrorResponse(
            errorCode: 800,
            errorMessage: "Erro ao enviar solicitação",
          ));
    }
  }

//ATUALIZANDO UM ALBUM
  Future<ApiResponse<Album?, ErrorResponse>> updadeAlbum(
      int? id, int? userId, String title) async {
    final url = Uri.parse("${_apibase}/albums");
    try {
      Map params = {
        "title": title,
        "id": id,
        "userId": userId,
      };
      /*if (Album != null) {
        Response response = await http
            .post(url, body: json.encode(params))
            .timeout(Duration(seconds: 5));
      }*/
      Response response = await http
          .put(url, body: json.encode(params))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        return ApiResponse(
            response: Album.fromJson(json.decode(response.body)));
      } else {
        return ApiResponse(
            hasError: true,
            error: ErrorResponse.fromJson(json.decode(response.body)));
      }
    } on TimeoutException catch (e) {
      return ApiResponse(
          hasError: true,
          error: ErrorResponse(
            errorCode: 800,
            errorMessage: "Erro ao enviar solicitação",
          ));
    }
  }

  //DELETANDO ALBUM
  Future<ApiResponse<Album?, ErrorResponse>> deletarAlbum(String id) async {
    final url = Uri.parse("$_apibase/albums/$id");
    try {
      Response response = await http.delete(url).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return ApiResponse(
            response: Album.fromJson(json.decode(response.body)));
      } else {
        return ApiResponse(
            hasError: true,
            error: ErrorResponse.fromJson(json.decode(response.body)));
      }
    } on TimeoutException catch (e) {
      return ApiResponse(
        hasError: true,
        error: ErrorResponse(
          errorCode: 900,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
