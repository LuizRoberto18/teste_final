

import 'package:http/http.dart';
import 'package:teste_final/models/album.dart';
import 'package:http/http.dart' as http;
import 'package:teste_final/models/error.dart';

import 'dart:convert' as convert;

import 'package:teste_final/models/model_response.dart';

class AlbumApi {
 String _apibase = "https://jsonplaceholder.typicode.com/";
 AlbumApi(this._apibase);
 Future<List<Album>> getAlbums() async {
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

   Future<ApiResponse<Album?, ErrorResponse>> fatchAlbum() async {
      var url = Uri.parse("${_apibase}/albums");
      try{
        Response response = await http.get(url).timeout(Duration(seconds: 5));
      }
  }
}
