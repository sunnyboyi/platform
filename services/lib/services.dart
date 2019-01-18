library app_services;

export 'src/api/apis.dart';
export 'src/net/http_manager.dart';
export 'src/order/bloc/purchase_order_bloc.dart';
export 'src/order/bloc/requirement_order_bloc.dart';
export 'src/order/bloc/requirement_quote_detail_bloc.dart';
export 'src/order/bloc/sales_order_bloc.dart';
export 'src/product/bloc/product_bloc.dart';
export 'src/supplier/bloc/suppliers_bloc.dart';
export 'src/supplier/bloc/suppliers_bloc.dart';
export 'src/system/notification/message_file_storage.dart';
export 'src/system/notification/message_repository.dart';
export 'src/system/notification/message_repository_impl.dart';
export 'src/system/notification/message_web_client.dart';
export 'src/user/bloc/login.dart';
export 'src/user/bloc/user_bloc.dart';
export 'src/user/city_repository.dart';
export 'src/user/city_repository_impl.dart';
export 'src/user/district_repository.dart';
export 'src/user/district_repository_impl.dart';
export 'src/user/region_repository.dart';
export 'src/user/region_repository_impl.dart';

abstract class BLoCBase {
  void dispose();
}
