import 'package:flutter/foundation.dart';
import 'package:inventario/controllers/apis.dart';
import 'package:inventario/models/collects.dart';
import 'package:inventario/models/colleted.dart';
import 'package:inventario/models/error.dart';
import 'package:inventario/models/model_response.dart';
import 'package:inventario/models/resp_collect.dart';
import 'package:inventario/utils/sql/collect_dao.dart';
import 'package:inventario/utils/stream_bloc.dart';
import 'package:teste_final/data/apis.dart';
import 'package:teste_final/models/error.dart';
import 'package:teste_final/models/model_response.dart';
import 'package:teste_final/utls/stream_bloc.dart';

class CollectsBloc extends StreamBlocBroadCast<Collects?> {
  loadCollects(String address) async {
    add(null);

    try {
      ApiResponse<Collects?, ErrorResponse> result = await Apis.fetchCollects(address: address);
      if (result.hasError) {
        addError(result.error!.toJson());
      } else {
        Collects? data = result.response;

        List<Coletas> finalColetas = [];
        for (var e in data!.coletas) {
          int currentIndex = finalColetas.indexWhere(
            (element) =>
                element.codProduto == e.codProduto &&
                e.endereco == element.endereco &&
                e.statusColeta == element.statusColeta,
          );
          if (currentIndex == -1) {
            finalColetas.add(e..matchesCollects.add(e));
          } else {
            finalColetas[currentIndex].matchesCollects.add(e);
          }
        }

        add(data..coletas = finalColetas);
      }
    } catch (e) {
      addError(e.toString());
    }
  }

  deleteListIdCollects(List<Coletas> ids) async {
    bool allSuccess = true;
    for (Coletas id in ids) {
      ApiResponse<bool?, ErrorResponse> result = await Apis.deleteCollects(id: id.idLancto);
      if (result.hasError) {
        allSuccess = false;
      }
    }
    return allSuccess;
  }
}

class CollectController {
  static Future<ApiResponse<CollectResponse, ErrorResponse>> sendCollect(Colleted collected) async {
    final dao = CollectDAO();
    try {
      dao.save(collected);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString() + "Error no dao save");
      }
    }
    ApiResponse<CollectResponse, ErrorResponse> sendResult = await Apis.sendCollect(
      address: collected.endereco,
      collected: collected.qtdColeta,
      product: collected.codProduto,
      force: collected.force,
      codFilial: collected.codFilial,
      codUsr: collected.codUsr,
    );

    try {
      if (sendResult.hasError) {
        if (sendResult.error!.errorCode == 800 || sendResult.error!.errorCode == 900) {
          dao.update(collected.force ? collected.qtdColeta : 0, collected, sended: false, force: collected.force);
        } else if (sendResult.error!.errorCode == 409) {
          dao.update(0, collected, sended: false, force: collected.force);
        }
      } else {
        dao.update(
          collected.force ? collected.qtdColeta : 0,
          collected,
          sended: true,
          force: collected.force,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString() + "Error no dao update");
      }
    }

    return sendResult;
  }

  static updateLocalDB(Colleted collected, {bool sended = true}) {
    final dao = CollectDAO();
    dao.update(
      0,
      collected,
      sended: sended,
    );
  }
}
