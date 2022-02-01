import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:inventario/models/collects.dart';
import 'package:inventario/models/error.dart';
import 'package:inventario/models/model_response.dart';
import 'package:inventario/models/product.dart';
import 'package:inventario/models/resp_collect.dart';
import 'package:inventario/utils/prefs.dart';
import 'package:teste_final/models/error.dart';
import 'package:teste_final/models/model_response.dart';

import '../global.dart';
import 'package:http/http.dart' as http;

class Apis {
  static Future<bool> checkVersion(String platform, String baseUrl) async {
    String url = '$mainUrl/ctrver/VALIDAR?'
        'APP=$app&'
        'CODUSER=&'
        'PLATAFORMA=$platform&'
        'VERSAO=$version';

    try {
      Response response = await http.put(Uri.parse(baseUrl + url)).timeout(
            const Duration(seconds: 5),
          );

      mainUrl = baseUrl;

      return true;
    } catch (e) {
      return false;
    }
  }

  ///Login by fetch protheus user
  static Future<bool> login(
    String login,
    String password,
  ) async {
    try {
      String url = '$mainUrl'
          '/AUTHUSER?'
          'USR=$login&'
          'PWD=$password&'
          'APP=$app';

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Prefs.setString("user", json.decode(response.body)['codUser']);
        user = json.decode(response.body)['codUser'];
        return true;
      }

      return false;
    } catch (error) {
      return false;
    }
  }

  static Future<ApiResponse<Product?, ErrorResponse>> fetchProduct(
      String code) async {
    String url = '$mainUrl/INVENTARIO/PRODUTO?'
        'CODPRODUTO=$code';

    try {
      Response response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return ApiResponse(
          response: Product.fromJson(json.decode(response.body)),
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
        error: ErrorResponse(
          errorCode: 800,
          errorMessage: e.toString(),
        ),
      );
    } catch (e) {
      return ApiResponse(
        hasError: true,
        error: ErrorResponse(
          errorCode: 900,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  static Future<ApiResponse<CollectResponse, ErrorResponse>> sendCollect({
    required num collected,
    required String address,
    required String product,
    required bool force,
    required String codFilial,
    required String codUsr,
  }) async {
    String url = '$mainUrl/INVENTARIO/LOJA';

    try {
      Map params = {
        "codUsr": codUsr,
        "codFilial": codFilial,
        "qtdColeta": collected,
        "endereco": address,
        "codProduto": product,
        "force": force,
      };

      Response response = await http
          .post(
            Uri.parse(url),
            body: json.encode(params),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        return ApiResponse(
          response: CollectResponse.fromJson(json.decode(response.body)),
        );
      } else if (response.statusCode == 409) {
        return ApiResponse(
          hasError: true,
          error: ErrorResponse.fromJson(json.decode(response.body))
            ..alreadyHave = true,
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
        error: ErrorResponse(
          errorCode: 800,
          errorMessage: "Erro ao enviar!\nSerá enviado novamente em segundos!",
        ),
      );
    } catch (e) {
      return ApiResponse(
        hasError: true,
        error: ErrorResponse(
          errorCode: 900,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  static Future<ApiResponse<Collects?, ErrorResponse>> fetchCollects(
      {required String address}) async {
    String url = '$mainUrl/INVENTARIO/LOJA?'
        'ENDERECO=$address';

    try {
      Response response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return ApiResponse(
          response: Collects.fromJson(json.decode(response.body)),
        );
      } else {
        return ApiResponse(
          hasError: true,
          error: ErrorResponse.fromJson(json.decode(response.body)),
        );
      }
    } catch (e) {
      print(e);
      return ApiResponse(
        hasError: true,
        error: ErrorResponse(
          errorCode: 900,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  static Future<ApiResponse<bool?, ErrorResponse>> deleteCollects(
      {required String id}) async {
    String url = '$mainUrl/INVENTARIO/LOJA?'
        'ID_LANCTOS=$id';

    try {
      Response response =
          await http.delete(Uri.parse(url)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return ApiResponse(
          response: true,
        );
      } else {
        return ApiResponse(
          hasError: true,
          error: ErrorResponse.fromJson(json.decode(response.body)),
        );
      }
    } catch (e) {
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
