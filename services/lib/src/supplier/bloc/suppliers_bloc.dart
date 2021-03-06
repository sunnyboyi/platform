import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';
import 'package:services/src/supplier/brands_response.dart';

class SuppliersBloc extends BLoCBase {

  // 工厂模式
  factory SuppliersBloc() => _getInstance();

  static SuppliersBloc get instance => _getInstance();
  static SuppliersBloc _instance;

  static SuppliersBloc _getInstance() {
    if (_instance == null) {
      _instance = SuppliersBloc._internal();
    }
    return _instance;
  }

  FactoriesResponse factoriesResponse;
  BrandsResponse brandsResponse;

  List<FactoryModel> _factories;
  List<BrandModel> _brands;

  var _factoryController = StreamController<List<FactoryModel>>.broadcast();
  var _brandController = StreamController<List<BrandModel>>.broadcast();

  Stream<List<FactoryModel>> get factoryStream => _factoryController.stream;

  Stream<List<BrandModel>> get brandStream => _brandController.stream;

  SuppliersBloc._internal() {
    // 初始化
    _brands = List<BrandModel>();
    _factories = List<FactoryModel>();
    brandsResponse = BrandsResponse(0, 10, 0, 0, []);
    factoriesResponse = FactoriesResponse(0, 10, 0, 0, []);
  }

  filterfactories() async {
    factoriesResponse = await UserRepositoryImpl().factorySuppliers({ 'fields':BrandOptions.DEFAULT,});
    _factories.clear();
    _factories.addAll(factoriesResponse.content);
    _factoryController.sink.add(_factories);
    bottomController.sink.add(false);
  }

  filterbrands() async {
    brandsResponse = await UserRepositoryImpl().brandSuppliers({'keyword': '','fields':BrandOptions.DEFAULT});
    _brands.clear();
    _brands.addAll(brandsResponse.content);
    _brandController.sink.add(_brands);
    bottomController.sink.add(false);
  }

  loadingMoreByFactories() async {
    //模拟数据到底
    if (factoriesResponse.number < factoriesResponse.totalPages - 1) {
      Response response = await http$.get(
        Apis.factorySuppliers,
        data: {
          'page': factoriesResponse.number + 1,
          'fields':BrandOptions.DEFAULT,
        },
      );
      factoriesResponse = FactoriesResponse.fromJson(response.data);
      _factories.addAll(factoriesResponse.content);
    } else {
      //通知显示已经到底部
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _factoryController.sink.add(this._factories);
  }

  loadingMoreByBrands() async {
    //模拟数据到底
    if (brandsResponse.number < brandsResponse.totalPages - 1) {
      Response response = await http$.get(
        Apis.brandsSuppliers,
        data: {
          'keyword':'',
          'page': brandsResponse.number + 1,
          'fields':BrandOptions.DEFAULT,
        },
      );
      brandsResponse = BrandsResponse.fromJson(response.data);
      _brands.addAll(brandsResponse.content);
    } else {
      //通知显示已经到底部
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _brandController.sink.add(this._brands);
  }

  void reset() {
    _factories.clear();
    _brands.clear();
  }

  dispose() {
    _factoryController.close();
    _brandController.close();

    super.dispose();
  }
}
