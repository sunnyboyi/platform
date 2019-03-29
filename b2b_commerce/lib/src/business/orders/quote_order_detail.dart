import 'package:b2b_commerce/src/business/orders/form/proofing_order_form.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_from.dart';
import 'package:b2b_commerce/src/production/production_online_order_from.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class QuoteOrderDetailPage extends StatefulWidget {
  QuoteModel item;

  QuoteOrderDetailPage({this.item});

  _QuoteOrderDetailPageState createState() => _QuoteOrderDetailPageState();
}

class _QuoteOrderDetailPageState extends State<QuoteOrderDetailPage> {
  QuoteModel pageItem;

  static Map<QuoteState, MaterialColor> _statesColor = {
    QuoteState.SELLER_SUBMITTED: Colors.green,
    QuoteState.BUYER_APPROVED: Colors.blue,
    QuoteState.BUYER_REJECTED: Colors.red
  };

  TextEditingController rejectController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //页面缓存Model对象
    pageItem = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '报价详情',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildRefuseMessage(),
          _buildCompanyInfo(),
          _buildFactory(),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 15),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: _buildProduct(),
            ),
          ),
          _buildQuoteCost(),
          _buildDeliveryDate(),
          _buildAttachment(),
          _buildRemark(),
          _buildOrderState(),
          _buildSummary()
        ],
      ),
    );
  }

  Widget _buildRefuseMessage() {
    //拒绝状态
    if (widget.item.state == QuoteState.BUYER_REJECTED) {
      return Container(
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(255, 245, 169, 1),
        child: Text(
          '拒绝理由：${widget.item.comment}',
          style: TextStyle(color: Color.fromRGBO(255, 70, 70, 1), fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildOrderState() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('需求订单号：${pageItem.requirementOrder.code}'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('报价单号：${pageItem.code}'),
                ),
                Text(
                  QuoteStateLocalizedMap[pageItem.state],
                  style: TextStyle(
                    color: _statesColor[pageItem.state],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                  '报价时间：' + pageItem.creationTime.toString().substring(0, 10)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    /// 工厂端显示
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return GestureDetector(
        onTap: () {
          //TODO跳转详细页
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[300]))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget
                                              .item.supplier?.profilePicture !=
                                          null
                                      ? '${GlobalConfigs.IMAGE_BASIC_URL}${widget.item.belongTo.profilePicture}'
                                      : 'http://img.jituwang.com/uploads/allimg/150305/258852-150305121F483.jpg')),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.item.supplier?.name}',
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 38, 41, 1)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(229, 242, 255, 1),
                                ),
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  '已认证',
                                  style: TextStyle(
                                      color: Color.fromRGBO(22, 141, 255, 1)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 35,
                      color: Color.fromRGBO(180, 180, 180, 1),
                    )
                  ],
                ),
              ),
              InfoRow(
                label: '联系人',
                value: Text(
                  '${widget.item.supplier?.contactPerson}',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                ),
              ),
              InfoRow(
                  label: '联系手机',
                  hasBottomBorder: false,
                  value: Row(
                    children: <Widget>[
                      Text(
                        '${widget.item.supplier?.contactPhone}',
                        style: TextStyle(
                            color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                      ),
                      Container(
                        child: IconButton(
                          onPressed: () {
                            //TODO调用拨打电话API
                          },
                          icon: Icon(
                            Icons.phone,
                            color: Color.fromRGBO(86, 194, 117, 1),
                          ),
                        ),
                      ),
                      Text(
                        '拨打',
                        style: TextStyle(
                            color: Color.fromRGBO(86, 194, 117, 1),
                            fontSize: 16),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _buildFactory() {
    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '报价工厂',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          pageItem.belongTo.name,
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Stars(
                              starLevel: pageItem.belongTo.starLevel ?? 1,
                              highlightOnly: false,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('历史接单'),
                        Text(
                          pageItem.belongTo.historyOrdersCount.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        Text('单')
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${pageItem.belongTo.contactAddress?.city?.name} ${pageItem.belongTo.contactAddress?.cityDistrict?.name}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildProduct() {
    return Row(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: pageItem.requirementOrder.details.pictures != null &&
                        pageItem.requirementOrder.details.pictures.isNotEmpty
                    ? NetworkImage(
                        '${GlobalConfigs.IMAGE_BASIC_URL}${pageItem.requirementOrder.details.pictures[0].url}')
                    : AssetImage(
                        'temp/picture.png',
                        package: "assets",
                      ),
                fit: BoxFit.cover,
              )),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                pageItem.requirementOrder.details.productName != null
                    ? Text(
                        pageItem.requirementOrder.details.productName,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        //overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        ' ',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                pageItem.requirementOrder.details?.productSkuID != null
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '货号：' +
                              pageItem.requirementOrder.details.productSkuID,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 243, 243, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${pageItem.requirementOrder.details.majorCategoryName()},${pageItem.requirementOrder.details?.category.name},${pageItem.requirementOrder.totalQuantity}件',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 133, 148, 1),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteCost() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '报价费用',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('生产单价'),
                  ),
                  Text(
                    '￥ ${pageItem.unitPrice}',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('面料单价'),
                        ),
                        Text(
                          '￥ ${pageItem.unitPriceOfFabric}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('辅料单价'),
                        ),
                        Text(
                          '￥ ${pageItem.unitPriceOfExcipients}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('加工单价'),
                        ),
                        Text(
                          '￥ ${pageItem.unitPriceOfProcessing}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('其他'),
                        ),
                        Text(
                          '￥ ${pageItem.costOfOther}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('打样费'),
                  ),
                  Text(
                    '￥' + pageItem.costOfSamples.toString(),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDate() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Text(
            '交货时间：${DateFormatUtil.formatYMD(pageItem.expectedDeliveryDate)}'),
      ),
    );
  }

  Widget _buildAttachment() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(color: Colors.grey),
              ),
              Attachments(list: pageItem.attachments),
            ],
          )),
    );
  }

  Widget _buildRemark() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '备注',
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text('${pageItem.remarks}'),
              ),
            ],
          )),
    );
  }

  void refreshData() async {
    //查询明细
    QuoteModel detailModel =
        await QuoteOrderRepository().getquoteDetail(pageItem.code);
    if (detailModel != null) {
      setState(() {
        pageItem = detailModel;
      });
    }
  }

  Widget _buildSummary() {
    List<Widget> buttons;

    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      if (pageItem.state == QuoteState.SELLER_SUBMITTED) {
        buttons = <Widget>[
          Container(
            height: 40,
            width: 150,
            margin: EdgeInsets.only(right: 20),
            child: FlatButton(
                onPressed: onReject,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '拒绝报价',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
          Container(
            width: 150,
            height: 40,
            child: FlatButton(
                onPressed: onApprove,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(255, 214, 12, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '确认报价',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                )),
          )
        ];
      }
    } //工厂端显示
    else {
      if (pageItem.state == QuoteState.SELLER_SUBMITTED) {
        buttons = [
          Container(
            width: 250,
            height: 40,
            child: FlatButton(
                onPressed: onUpdateQuote,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromRGBO(255, 45, 45, 1)),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '修改报价',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                )),
          ),
        ];
      } else if (pageItem.state == QuoteState.BUYER_APPROVED) {
        buttons = <Widget>[
          Container(
            width: 150,
            height: 40,
            margin: EdgeInsets.only(right: 20),
            child: FlatButton(
                onPressed: onCreateProofings,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(255, 245, 193, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '打样订单',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 169, 0, 1), fontSize: 16),
                )),
          ),
          Container(
            width: 150,
            height: 40,
            child: FlatButton(
                onPressed: onCreateProduction,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(255, 214, 12, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '生产订单',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                )),
          )
        ];
      } else {
        buttons = [
          Container(
            width: 250,
            height: 40,
            child: FlatButton(
                onPressed: onQuoteAgain,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(255, 70, 70, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '重新报价',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          )
        ];
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      // color: Colors.green,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: buttons ?? []),
    );
  }

  void alertMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text(message)],
            ),
          ),
    );
  }

  void onReject() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入拒绝原因?'),
          content: TextField(
            controller: rejectController,
            autofocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository()
                    .quoteReject(pageItem.code, rejectController.text);
                Navigator.of(context).pop();
                if (statusCode == 200) {
                  //触发刷新
                  refreshData();
                } else {
                  alertMessage('拒绝失败');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onApprove() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('是否确认?'),
          actions: <Widget>[
            FlatButton(
              child: Text('否'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('是'),
              onPressed: () async {
                int statusCode =
                    await QuoteOrderRepository().quoteApprove(pageItem.code);
                Navigator.of(context).pop();
                if (statusCode == 200) {
                  //触发刷新
                  refreshData();
                } else {
                  alertMessage('确认失败');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onQuoteAgain() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderFrom(
              model: pageItem.requirementOrder,
              quoteModel: pageItem,
            )));
  }

  void onUpdateQuote() async {
    //等待操作回调
    bool isSuccessfule = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderFrom(
              model: pageItem.requirementOrder,
              quoteModel: pageItem,
              update: true,
            )));
    //成功调用列表页传递的更新函数刷新页面
    if (isSuccessfule != null && isSuccessfule) {
      refreshData();
    }
  }

  void onCreateProofings() async {
    //查询明细
    QuoteModel detailModel =
        await QuoteOrderRepository().getquoteDetail(pageItem.code);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProofingOrderForm(
              quoteModel: detailModel,
            )));
  }

  void onCreateProduction() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductionOnlineOrderFrom(
                  quoteModel: pageItem,
                )));
  }
}
