import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';

class ProofingOrderRepository {
  ///创建打样单
  Future<String> proofingCreate(String quoteCode,ProofingModel model) async {
    Response response;
    try {
      response = await http$.post(OrderApis.proofingCreate(quoteCode),
          data: ProofingModel.toJson(model));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    }
  }
}
