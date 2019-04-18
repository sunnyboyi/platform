import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/production/production_offline_order_from.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionUniqueCodePage extends StatefulWidget {
  final ApparelProductModel product;

  ProductionUniqueCodePage({this.product});

  _ProductionUniqueCodePageState createState() =>
      _ProductionUniqueCodePageState();
}

class _ProductionUniqueCodePageState extends State<ProductionUniqueCodePage> {
  TextEditingController _textEditingController = TextEditingController();

  PurchaseOrderModel uniqueCodeEntry;
  String userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('导入唯一码'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '请输入唯一码',
                          style: TextStyle(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              fontSize: 18),
                        ),
                        TextField(
                          autofocus: true,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              suffix: GestureDetector(
                            onTap: () async{
                              String unique = _textEditingController.text;
                              if(unique != null && unique != ''){
                                //请求参数
                                Map data = {
                                  'salesApplications': unique,
                                };
                                Response<Map<String, dynamic>> response;

                                PurchaseOrderModel _purchaseOrder = await PurchaseOrderRepository().getDetailsForUniqueCode(unique);

                                if (_purchaseOrder != null) {
                                  setState(() {
                                    uniqueCodeEntry = _purchaseOrder;
                                  });
                                }
                              }else{
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: true, // user must tap button!
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: const Text('提示',style: TextStyle(fontSize: 16),),
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          child: Text('请输入唯一码'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text(
                              '检索',
                              style: TextStyle(
                                  color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                  uniqueCodeEntry == null
                      ? GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Center(
                        child: Text(
                          '没有唯一码？ 点击这里 >>',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,MaterialPageRoute(
                              builder: (context) =>
                                  ProductionOfflineOrder()
                          )
                      );
                    },
                  )
                      : Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '唯一码对应订单信息',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                        uniqueCodeEntry != null ?
                        UniqueCodeItem(
                          order: uniqueCodeEntry,
                        ) : Container()
                      ],
                    ),
                  ),
                ],
              ),
              uniqueCodeEntry != null ?
                  Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 40),
                      child: FlatButton(
                        color: Color(0xFFFFD600),
                        child: Text(
                          '确定导入',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        disabledColor : Color(0xffBC8F8F),
                        disabledTextColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        onPressed: uniqueCodeEntry == null ? null : () async {
                          bool result = false;
                          try{
                            result = await PurchaseOrderRepository().linkUniqueCode(uniqueCodeEntry.uniqueCode);
                          }catch(e){
                            print(e);
                          }
                          _showMessage(context,result,'绑定唯一码',uniqueCodeEntry.code);
                        },
                      ),
                    ):Container(),
            ],
          ),
        ));
  }


  void _showMessage(BuildContext context,bool result,String message,String code){
    _requestMessage(context,result == true? '${message}成功' : '${message}失败',result,code);
  }

  Future<void> _requestMessage(BuildContext context,String message,bool result,String code) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
              child: Text(
                '${message}',
                style: TextStyle(
                  fontSize: 22,
                ),
              )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(code);
                ProductionBLoC.instance.refreshData();

                Navigator.of(context).pop();
                result == true ?
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        PurchaseOrderDetailPage(order: model)
                    ), ModalRoute.withName('/')) : null;
              },
            ),
          ],
        );
      },
    );
  }


}

class UniqueCodeItem extends StatelessWidget {
  const UniqueCodeItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PurchaseOrderDetailPage(order: order),
        //   ),
        // );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            Column(
              children: <Widget>[
                _buildEntries(),
              ],
            ),
            _buildBottom()
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String userType;
      final bloc = BLoCProvider.of<UserBLoC>(context);
      if(bloc.isBrandUser){
        userType = 'brand';
      }else{
        userType = 'factory';
      }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  userType != null && userType == 'brand'?
                  '工厂：${order.belongTo.name}':'品牌：${order.purchaser.name}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Text(
                '${PurchaseOrderStatusLocalizedMap[order.status]}',
                style: TextStyle(
                    color: Color(0xFFFFD600),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
     int sum = 0;
    order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image:  order.product == null ||  order.product.thumbnail == null?
                    AssetImage(
                      'temp/picture.png',
                      package: "assets",
                    ):
                    NetworkImage('${order.product.thumbnail.previewUrl()}'),
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: order.product == null || order.product.name == null?
                            Container():
                            Text(
                              '${order.product.name}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                '货号：${order.product == null ? '' : order.product.skuID}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            )),
                        order.product == null || order.product.category == null?
                        Container() :
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 243, 243, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "${order.product.category.name}  ${sum}件",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 133, 148, 1)),
                          ),
                        )
                      ],
                    )))
          ],
        ));
  }

  Widget _buildBottom() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '生产单号：${order.code}',
          style: TextStyle(fontSize: 15),
        ),
      )
    );
  }

}
