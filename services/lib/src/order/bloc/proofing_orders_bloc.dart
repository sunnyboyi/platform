import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/response/order_response.dart';

class ProofingOrdersBLoC extends BLoCBase {
  // 工厂模式
  factory ProofingOrdersBLoC() => _getInstance();

  static ProofingOrdersBLoC get instance => _getInstance();
  static ProofingOrdersBLoC _instance;

  ProofingOrdersBLoC._internal() {
    // 初始化
  }

  static ProofingOrdersBLoC _getInstance() {
    if (_instance == null) {
      _instance = new ProofingOrdersBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, PageEntry> _quotesMap = {
    'ALL': PageEntry(currentPage: 0, size: 10, data: List<ProofingModel>()),
    'PENDING_PAYMENT': PageEntry(currentPage: 0, size: 10, data: List<ProofingModel>()),
    'PENDING_DELIVERY': PageEntry(currentPage: 0, size: 10, data: List<ProofingModel>()),
    'SHIPPED': PageEntry(currentPage: 0, size: 10, data: List<ProofingModel>()),
    'COMPLETED': PageEntry(currentPage: 0, size: 10, data: List<ProofingModel>()),
    'CANCELLED': PageEntry(currentPage: 0, size: 10, data: List<ProofingModel>())
  };

  List<ProofingModel> quotes(String status) => _quotesMap[status].data;

  var _controller = StreamController<List<ProofingModel>>.broadcast();

  Stream<List<ProofingModel>> get stream => _controller.stream;

  //锁
  bool lock = false;

  filterByStatuses(String status) async {
    if (!lock) {
      lock = true;
      //若没有数据则查询
      if (_quotesMap[status].data.isEmpty) {
        //  分页拿数据，response.data;
        //请求参数
        Map data = {};
        if (status != 'ALL') {
          data = {
            'statuses': [status]
          };
        }
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(OrderApis.proofing,
              data: data, queryParameters: {'page': _quotesMap[status].currentPage, 'size': _quotesMap[status].size});
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          ProofingOrdersResponse ordersResponse = ProofingOrdersResponse.fromJson(response.data);
          _quotesMap[status].totalPages = ordersResponse.totalPages;
          _quotesMap[status].totalElements = ordersResponse.totalElements;
          _quotesMap[status].data.clear();
          _quotesMap[status].data.addAll(ordersResponse.content);
        }
      }
      _controller.sink.add(_quotesMap[status].data);
      lock = false;
    }
  }

  loadingMoreByStatuses(String status) async {
    if (!lock) {
      lock = true;
      //数据到底
      if (_quotesMap[status].currentPage + 1 == _quotesMap[status].totalPages) {
        //通知显示已经到底部
        bottomController.sink.add(true);
      } else {
        Map data = {};
        if (status != 'ALL') {
          data = {
            'statuses': [status]
          };
        }
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(
            OrderApis.proofing,
            data: data,
            queryParameters: {'page': ++_quotesMap[status].currentPage, 'size': _quotesMap[status].size},
          );
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          ProofingOrdersResponse ordersResponse = ProofingOrdersResponse.fromJson(response.data);
          _quotesMap[status].totalPages = ordersResponse.totalPages;
          _quotesMap[status].totalElements = ordersResponse.totalElements;
          _quotesMap[status].data.addAll(ordersResponse.content);
        }
      }
//    loadingController.sink.add(false);
      _controller.sink.add(_quotesMap[status].data);
      lock = false;
    }
  }

  //下拉刷新
  Future refreshData(String status) async {
    //重置信息
    _quotesMap[status].data.clear();
    _quotesMap[status].currentPage = 0;
    await filterByStatuses(status);
  }

  dispose() {
    _controller.close();

    super.dispose();
  }
}
