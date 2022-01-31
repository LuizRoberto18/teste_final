import 'package:teste_final/data/album_api.dart';
import 'package:teste_final/models/album.dart';
import 'dart:convert';

class BLocController {
  AlbumApi api;

  BLocController(this.api);

  Future<Album> getlbum(int id) async {
    await api.responseCorpo;
    if (id != null) {
      if (api.responseCorpo!.statusCode == 200) {
        return Album.fromJson(json.decode(api.responseCorpo!.body));
      } else {
        throw Exception("Falid to load album");
      }
    }
    return throw Exception("falid to load album");

  }
// Future<List<Album>> getAllAlbums(){}
// Future<List<Album>> updateAlbum(album){}
// Future<List<Album>> deleteAlbum(int id){}
// Future<List<Album>> createAlbum(album){}

}
