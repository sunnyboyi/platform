import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../../business/orders/purchase_order_detail.dart';
import '../../../common/order_payment.dart';
import '../../../common/logistics_input_page.dart';

class PurchaseOrderItem extends StatefulWidget {
  PurchaseOrderItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  _PurchaseOrderItemState createState() => _PurchaseOrderItemState();
}

class _PurchaseOrderItemState extends State<PurchaseOrderItem> with AutomaticKeepAliveClientMixin {
  static Map<PurchaseOrderStatus, Color> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.IN_PRODUCTION: Color(0xFFFFD600),
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            _buildContent(context),
            bloc.isBrandUser ? _buildBrandButton(context) : _buildFactoryButton(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        //根据code查询
        PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(widget.order.code);

        if (model != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PurchaseOrderDetailPage(order: model)),
          );
        }
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              (widget.order.salesApplication == SalesApplication.ONLINE &&
                          widget.order.depositPaid == false &&
                          widget.order.deposit != null &&
                          widget.order.deposit != 0 &&
                          widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) ||
                      (widget.order.salesApplication == SalesApplication.ONLINE &&
                          widget.order.balancePaid == false &&
                          widget.order.balance != null &&
                          widget.order.balance != 0 &&
                          widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '￥',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.order.salesApplication == SalesApplication.ONLINE && widget.order.depositPaid == false && widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT ? widget.order.deposit == null ? '' : widget.order.deposit : widget.order.balance == null ? '' : widget.order.balance}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildHeaderText(context),
                      ],
                    )
                  : Container(
                      child: widget.order.delayed
                          ? Text('已延期',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ))
                          : Container()),
              widget.order.status == null
                  ? Container()
                  : Expanded(
                      flex: 3,
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${PurchaseOrderStatusLocalizedMap[widget.order.status]}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 18,
                              color: _statusColors[widget.order.status],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    '${widget.order.belongTo == null ? widget.order.companyOfSeller : widget.order.belongTo.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                '${widget.order.salesApplication == null ? '' : SalesApplicationLocalizedMap[widget.order.salesApplication]}',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 16),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    if (widget.order.salesApplication == SalesApplication.ONLINE &&
        widget.order.depositPaid == false &&
        (widget.order.deposit != null || widget.order.deposit > 0) &&
        widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        color: const Color.fromRGBO(255, 243, 243, 1),
        child: Text(
          '待付定金',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (widget.order.salesApplication == SalesApplication.ONLINE &&
        widget.order.balancePaid == false &&
        (widget.order.balance != null || widget.order.balance > 0) &&
        widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        color: const Color.fromRGBO(255, 243, 243, 1),
        child: Text(
          '待付尾款',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildContent(BuildContext context) {
    //计算总数
    int sum = 0;
    widget.order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: widget.order.product == null || widget.order.product.thumbnail == null
                      ? AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        )
                      : NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${widget.order.product.thumbnail.url}'),
                  fit: BoxFit.cover,
                )),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: widget.order.product == null || widget.order.product.name == null
                            ? Container()
                            : Text(
                                '${widget.order.product.name}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '货号：${widget.order.product == null ? '' : widget.order.product.skuID}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      widget.order.product == null || widget.order.product.category == null
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 243, 243, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${widget.order.product.category.name}  $sum件",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: const Color.fromRGBO(255, 133, 148, 1),
                                ),
                              ),
                            )
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _buildBrandButton(BuildContext context) {
    if (widget.order.salesApplication == SalesApplication.ONLINE) {
      if (widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
        if (widget.order.depositPaid == false && widget.order.deposit != null && widget.order.deposit > 0) {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                      width: 100,
                      margin: const EdgeInsets.fromLTRB(45, 0, 30, 0),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT
                          ? RaisedButton(
                              color: Colors.red,
                              child: Text(
                                '取消订单',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: true, // user must tap button!
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        '提示',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      content: Text('是否要取消订单？'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            '取消',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            '确定',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () async {
                                            bool result = await PurchaseOrderRepository()
                                                .purchaseOrderCancelling(widget.order.code);
                                            _showMessage(context, result, '订单取消');
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              })
                          : Container()),
                ),
                Expanded(
                  child: Container(
                      width: 100,
                      padding: const EdgeInsets.fromLTRB(45, 0, 20, 0),
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                          color: Color(0xFFFFD600),
                          child: Text(
                            '去支付',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderPaymentPage(
                                      order: widget.order,
                                      paymentFor: PaymentFor.DEPOSIT,
                                    )));
                          })),
                ),
              ],
            ),
          );
        } else {
          return Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(right: 30),
                width: 150,
                child: FlatButton(
                  color: Color(0xFFFFD600),
                  child: const Text(
                    '确认',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                  onPressed: () async {
                    bool result = await PurchaseOrderRepository().confirmProduction(widget.order.code, widget.order);
                    _showMessage(context, result, '确认生产');
                  },
                ),
              ),
            ),
          );
        }
      }
      //支付尾款
      else if (widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
        if (widget.order.balancePaid == false && widget.order.balance != null && widget.order.balance > 0) {
          return Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(right: 30),
                width: 150,
                child: FlatButton(
                  color: const Color(0xFFFFD600),
                  child: const Text(
                    '去支付',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderPaymentPage(
                              order: widget.order,
                              paymentFor: PaymentFor.BALANCE,
                            )));
                  },
                ),
              ),
            ),
          );
        }
      }
      //确认收货
      if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 30),
              width: 150,
              child: FlatButton(
                color: const Color(0xFFFFD600),
                child: const Text(
                  '确认收货',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () async {
                  bool result = false;
                  result = await PurchaseOrderRepository().purchaseOrderShipped(widget.order.code, widget.order);
                  _showMessage(context, result, '确认收货');
                },
              ),
            ),
          ),
        );
      }
    } else {
      //确认收货
      if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 30),
              width: 150,
              child: FlatButton(
                color: const Color(0xFFFFD600),
                child: const Text(
                  '确认收货',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () async {
                  bool result = false;
                  result = await PurchaseOrderRepository().purchaseOrderShipped(widget.order.code, widget.order);
                  _showMessage(context, result, '确认收货');
                },
              ),
            ),
          ),
        );
      }
    }

    return Container();
  }

  Widget _buildFactoryButton(BuildContext context) {
    //流程是待付款状态并定金未付的情况下能修改订单金额
    if (widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT && widget.order.depositPaid == false) {
      return Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.only(right: 30),
            width: 150,
            child: FlatButton(
                color: Colors.red,
                child: const Text(
                  '修改金额',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  _showDepositDialog(context, widget.order);
                }),
          ),
        ),
      );
    }
    //流程是生产中时，显示验货完成按钮
//   else if(order.status == PurchaseOrderStatus.IN_PRODUCTION && order.currentPhase == ProductionProgressPhase.INSPECTION){
//       return Container(
//         child: Align(
//           alignment: Alignment.bottomRight,
//           child: Container(
//             padding: EdgeInsets.only(right: 30),
//             width: 150,
//             child: FlatButton(
//                 color: Color(0xFFFFD600),
//                 child: Text(
//                   '验货完成',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                 ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.all(Radius.circular(20))),
//                 onPressed: () {
//                   _showBalanceDialog(context, order);
//                 }
//             ),
//           ),
//         )
//     );
//   }
    //当流程是待出库状态下

    else if (widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      //尾款已付时，出现确认发货
      if (widget.order.balancePaid ||
          widget.order.balance == 0 ||
          widget.order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 30),
              width: 150,
              child: FlatButton(
                color: const Color(0xFFFFD600),
                child: const Text(
                  '确认发货',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LogisticsInputPage(isProductionOrder: true, purchaseOrderModel: widget.order),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      } else if (widget.order.salesApplication == SalesApplication.ONLINE && !widget.order.balancePaid) {
        //未付尾款时可以修改金额
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              width: 150,
              child: FlatButton(
                color: Colors.red,
                child: const Text(
                  '修改金额',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  _showBalanceDialog(context, widget.order);
                },
              ),
            ),
          ),
        );
      }
    }
    //当流程是已出库时，可以查看物流
    else if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
      return Container(
//          child: Align(
//            alignment: Alignment.bottomRight,
//            child: Container(
//              padding: EdgeInsets.only(right: 30),
//              width: 150,
//              child: FlatButton(
//                  color: Color(0xFFFFD600),
//                  child: Text(
//                    '查看物流',
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 18,
//                    ),
//                  ),
//                  shape: RoundedRectangleBorder(
//                      borderRadius:
//                      BorderRadius.all(Radius.circular(20))),
//                  onPressed: () {
//                    //todo 接通查看物流信息页面
//                  }
//              ),
//            ),
//          )
          );
    }

    return Container();
  }

  //修改金额按钮方法
  Future<void> _neverUpdateBalance(BuildContext context, PurchaseOrderModel model) async {
    TextEditingController dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('提示', style: const TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '订单总额：￥${model.totalPrice}',
                ),
                Text(
                  '已付定金：￥${model.deposit}',
                ),
                Text(
                  '应付尾款：￥${model.totalPrice != null && model.deposit != null ? model.totalPrice - model.deposit : ''}',
                  style: const TextStyle(color: Colors.red),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller: dialogText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '请输入尾款',
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 30),
                  width: 230,
                  child: FlatButton(
                      color: const Color(0xFFFFD600),
                      child: const Text(
                        '确定',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                      onPressed: () async {
                        bool result = false;
                        if (dialogText.text != null && dialogText.text != '') {
                          double balance = dialogText.text == null || dialogText.text == ''
                              ? model.balance
                              : double.parse(dialogText.text);
                          model.balance = balance;
                          model.skipPayBalance = false;
                          try {
                            result = await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code, model);
                          } catch (e) {
                            print(e);
                          }
                          if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
                            try {
                              for (int i = 0; i < widget.order.progresses.length; i++) {
                                if (widget.order.currentPhase == widget.order.progresses[i].phase) {
                                  result = await PurchaseOrderRepository().productionProgressUpload(widget.order.code,
                                      widget.order.progresses[i].id.toString(), widget.order.progresses[i]);
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                          Navigator.of(context).pop();
                          _showMessage(context, result, '修改尾款');
                        }
                      }),
                ),
                FlatButton(
                  child: Text(
                    '无需付款直接跳过>>',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showTips(context, model);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //修改定金
  Future<void> _neverUpdateDeposit(BuildContext context, PurchaseOrderModel model) async {
    final TextEditingController depositText = TextEditingController();
    final TextEditingController unitText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('提示', style: const TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('订单总额：￥${model.totalPrice}'),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller: depositText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: '定金：￥${model.deposit}'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller: unitText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: '单价：￥${model.unitPrice}'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 30),
              width: 230,
              child: FlatButton(
                  color: const Color(0xFFFFD600),
                  child: const Text(
                    '确定',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                  onPressed: () async {
                    bool result = false;
                    double unit =
                        unitText.text == null || unitText.text == '' ? model.unitPrice : double.parse(unitText.text);
                    double deposit = depositText.text == null || depositText.text == ''
                        ? model.deposit
                        : double.parse(depositText.text);
                    model.deposit = deposit;
                    model.unitPrice = unit;
                    model.skipPayBalance = false;
                    try {
                      result = await PurchaseOrderRepository().purchaseOrderDepositUpdate(model.code, model);
                    } catch (e) {
                      print(e);
                    }
                    Navigator.of(context).pop();
                    _showMessage(context, result, '修改定金');
                  }),
            ),
          ],
        );
      },
    );
  }

  //打开修改尾款金额弹框
  void _showBalanceDialog(BuildContext context, PurchaseOrderModel model) {
    _neverUpdateBalance(context, model);
  }

  //打开修改定金金额弹框
  void _showDepositDialog(BuildContext context, PurchaseOrderModel model) {
    _neverUpdateDeposit(context, model);
  }

  void _showTips(BuildContext context, PurchaseOrderModel model) {
    _neverComplete(context, model);
  }

  void _showMessage(BuildContext context, bool result, String message) {
    _requestMessage(context, result ? '$message成功' : '$message失败');
    PurchaseOrderBLoC.instance.refreshData('ALL');
  }

  //确认跳过按钮
  Future<void> _neverComplete(BuildContext context, PurchaseOrderModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '提示',
            style: const TextStyle(fontSize: 16),
          ),
          content: Text('是否无需付款直接跳过？'),
          actions: <Widget>[
            FlatButton(
              child: const Text('取消', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('确定', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                bool result = false;
                model.balance = 0;
                model.skipPayBalance = true;
                try {
                  result = await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code, model);
                  if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
                    try {
                      for (int i = 0; i < widget.order.progresses.length; i++) {
                        if (widget.order.currentPhase == widget.order.progresses[i].phase) {
                          result = await PurchaseOrderRepository().productionProgressUpload(
                              widget.order.code, widget.order.progresses[i].id.toString(), widget.order.progresses[i]);
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                } catch (e) {
                  result = false;
                  print(e);
                } finally {
                  Navigator.of(context).pop();
                  _showMessage(context, result, '操作');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestMessage(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text('提示', style: const TextStyle(fontSize: 16)),
          children: <Widget>[SimpleDialogOption(child: Text('$message'))],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}