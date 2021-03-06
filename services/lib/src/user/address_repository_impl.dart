import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl();

  @override
  Future<List<AddressModel>> list() async {
    Response response;
    List<AddressModel> result;
    try {
      response = await http$.get(UserApis.addresses);
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = response.data
          .map<AddressModel>((address) => AddressModel.fromJson(address))
          .toList();
    } else {
      result = null;
    }
    return result;
  }

  @override
  Future<AddressModel> detail(String id) async {
    Response response = await http$.get(UserApis.getAddress(id));
    return AddressModel.fromJson(response.data);
  }

  @override
  Future<bool> create(AddressModel form) async {
    bool result = false;

    Response response = await http$.post(UserApis.addressCreate,
        data: AddressModel.toJson(form));
    if (response != null && response.statusCode == 200) {
      result = true;
    } else {
      result = false;
    }

    return result;
  }

  @override
  Future<bool> update(AddressModel form) async {
    bool result = false;

    Response response = await http$.put(UserApis.addressUpdate(form.id),
        data: AddressModel.toJson(form));
    if (response != null && response.statusCode == 200) {
      result = true;
    } else {
      result = false;
    }

    return result;
  }

  @override
  Future<String> delete(String id) async {
    Response response = await http$.delete(UserApis.addressDelete(id));
    return response.data;
  }
}
