import 'package:b2b_commerce/src/business/orders/sale/components/sales_detail_button_group.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///销售订单底部按钮
class SalesListButtonGroup extends SalesDetailButtonGroup {
  SalesListButtonGroup({
    double height,
    SalesOrderModel model,
    VoidCallback callback,
  }) : super(height: height, model: model, callback: callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buildButtons(context)),
    );
  }

  @override
  List<Widget> buildButtons(BuildContext context) {
    //根据买卖方显示按钮
    UserType userType = BLoCProvider.of<UserBLoC>(context).currentUser.type;

    List<Widget> buttons = [
      Expanded(
        flex: 1,
        child: Container(),
      ),
    ];

    //工厂按钮
    if (userType == UserType.FACTORY) {
      //TODO退款状态判断
      if (model.refunding != null && model.refunding) {
        buttons.add(buildSpaceBtn());
        buttons.add(buildBtn2(context, () => onRefundDetail(context), '退货详情'));
        return buttons;
      }

      switch (model.status) {
        case SalesOrderStatus.PENDING_DELIVERY:
          buttons.add(buildSpaceBtn());
          buttons.add(buildBtn2(context, () => onDelivery(context), '发货'));
          break;
        default:
      }
    }

    ///买方按钮
    else {
      //TODO退款状态判断
      if (model.refunding != null && model.refunding) {
        buttons.add(buildSpaceBtn());
        buttons.add(buildBtn2(context, () => onCancelRefund(context), '撤销退货'));
        return buttons;
      }

      switch (model.status) {
        case SalesOrderStatus.PENDING_PAYMENT:
          buttons.add(buildBtn1(context, () => onClose(context), '取消订单'));
          buttons.add(buildBtn2(context, () => onPay(context), '支付'));
          break;
        case SalesOrderStatus.PENDING_DELIVERY:
          buttons.add(buildBtn1(context, () => onRefund(context), '退货'));
          buttons.add(buildBtn2(context, onRemind, '提醒发货'));
          break;
        case SalesOrderStatus.PENDING_CONFIRM:
          buttons.add(buildBtn1(context, () => onRefund(context), '退货'));
          buttons.add(buildBtn2(context, () => onConfirm(context), '确认收货'));
          break;
        default:
      }
    }

    return buttons;
  }

  ///样式1按钮
  @override
  Widget buildBtn1(BuildContext context, VoidCallback onPressed, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 30,
        child: OutlineButton(
            child: Text(
              '$text',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            onPressed: onPressed),
      ),
    );
  }

  ///样式2按钮
  @override
  Widget buildBtn2(BuildContext context, VoidCallback onPressed, String text) {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 30,
          child: FlatButton(
              color: Colors.orangeAccent,
              child: Text(
                '$text',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              onPressed: onPressed)),
    );
  }
}
