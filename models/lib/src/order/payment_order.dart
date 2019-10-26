import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'payment_order.g.dart';

/// 付款单
@JsonSerializable()
class PaymentOrderModel extends ItemModel {
  /// 当前账期
  PayMoneyType moneyType;

  /// 付款金额
  double amount;

  ///付款类型
  PaymentType paymentType;

  ///支付凭证
  MediaModel payCertificate;

  ///备注
  String remarks;

  ///剩余支付金额
  double remainPaymentAmount;

  ///所属账务方案子项
  @JsonKey(toJson: _orderPayPlanItemToJson)
  OrderPayPlanItemModel orderPayPlanItem;

  PaymentOrderModel(
      {this.moneyType,
      this.amount,
      this.paymentType,
      this.payCertificate,
      this.remarks,
      this.remainPaymentAmount});

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderModelFromJson(json);

  static Map<String, dynamic> toJson(PaymentOrderModel model) =>
      _$PaymentOrderModelToJson(model);

  static Map<String, dynamic> _orderPayPlanItemToJson(
          OrderPayPlanItemModel orderPayPlanItem) =>
      OrderPayPlanItemModel.toJson(orderPayPlanItem);
}

/// 收款单
@JsonSerializable()
class ReceiptOrderModel extends ItemModel {
  /// 当前账期
  PayMoneyType moneyType;

  /// 付款金额
  double amount;

  ///付款类型
  PaymentType paymentType;

  ///支付凭证
  MediaModel payCertificate;

  ///备注
  String remarks;

  ///剩余支付金额
  double remainPaymentAmount;

  ///所属账务方案子项
  @JsonKey(toJson: _orderPayPlanItemToJson)
  OrderPayPlanItemModel orderPayPlanItem;

  ReceiptOrderModel(
      {this.moneyType,
      this.amount,
      this.paymentType,
      this.payCertificate,
      this.remarks,
      this.remainPaymentAmount});

  factory ReceiptOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptOrderModelFromJson(json);

  static Map<String, dynamic> toJson(ReceiptOrderModel model) =>
      _$ReceiptOrderModelToJson(model);

  static Map<String, dynamic> _orderPayPlanItemToJson(
          OrderPayPlanItemModel orderPayPlanItem) =>
      OrderPayPlanItemModel.toJson(orderPayPlanItem);
}