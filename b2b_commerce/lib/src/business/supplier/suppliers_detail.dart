import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/products/existing_product.dart';
import 'package:b2b_commerce/src/business/supplier/contact_factory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class SuppliersDetail extends StatefulWidget {
  final SupplierModel supplierModel;
  final bool isSupplier;

  SuppliersDetail(
      {Key key, @required this.supplierModel, @required this.isSupplier})
      : super(key: key);

  _SuppliersDetailState createState() => _SuppliersDetailState();
}

class _SuppliersDetailState extends State<SuppliersDetail> {

  @override
  void initState() {
//    if(widget.supplierModel.quoteOrder.requirementOrder == null)
//      widget.supplierModel.quoteOrder.requirementOrder = RequirementOrderModel(details: RequirementInfoModel());


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text(widget.isSupplier ? '供应商管理' : '工厂信息'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            color: Color.fromRGBO(255, 149, 22, 1),
            onPressed: () =>
                _selectActionButton(widget.supplierModel.factory.contactPhone),
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Center(
                  child: Text(
                    '联系厂家',
                    style: TextStyle(color: Color.fromRGBO(255, 149, 22, 1)),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactFactoryPage(),
                  ),
                );
              })
        ],
      ),
      body: Container(child: _buildSuppliersWidget(context)),
      floatingActionButton: _buildRequestOrderButton(context),
    );
  }

  Widget _buildSuppliersWidget(BuildContext context) {
    return Container(child: _buildSuppliersScorll(context));
  }

  Widget _buildSuppliersScorll(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildTop(context),
        _buildQuoteInfo(context),
        _buildPurchaseOrderInfo(context),
        _buildHistoryOrderCount(context),
        _buildFactory(context),
//        _buildFactoryInfo(context),
        _buildFabric(context),
        _buildExistingProductItem(context),
        _buildCooperativeBrand(context),
        _buildFactoryWorkPicInfo(context),
        _buildFactoryAuthentication(context),
      ],
    );
  }

  //发布需求按钮
  Widget _buildRequestOrderButton(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        '发布需求',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
              order: RequirementOrderModel(details: RequirementInfoModel(),attachments: []),
              isCreate: true,
            ),
          ),
        );
      },
      backgroundColor: Color.fromRGBO(255, 214, 12, 1),
    );
  }

  //供应商明细头部显示
  Widget _buildTop(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.grey,
//            child: Image.network(
//              widget.supplierModel.factory.profilePicture,
//              width: 110,
//              height: 110,
//              fit: BoxFit.fill,
//            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
            child: Column(
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.supplierModel.factory.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: _buildItemsStarIcon(context,
                              widget.supplierModel.factory.starLevel ?? 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${widget.supplierModel.factory.address}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Image.network(
                            'https://www.vvfeng.com/data/upload/ueditor/20170422/58fab741b57e7.jpg',
                            width: 20,
                            height: 20,
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Image.network(
                            'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548234386864&di=8f02d11edaa58d5a881f7828d6300fd2&imgtype=0&src=http%3A%2F%2Fa3.mzstatic.com%2Fus%2Fr30%2FPurple111%2Fv4%2F5f%2Fc7%2Fff%2F5fc7ff3e-42b4-d629-462f-148b523a4702%2FCRV_AP_600x360.jpeg',
                            width: 20,
                            height: 20,
                          )),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '已认证',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.deepOrange),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //报价单信息
  Widget _buildQuoteInfo(BuildContext context) {
    return widget.isSupplier
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                      child: RichText(
                        text: TextSpan(
                            text: '向我报价',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${widget.supplierModel.quoteCount}',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                              TextSpan(
                                  text: '次', style: TextStyle(fontSize: 16)),
                            ]),
                      ),
                    )),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: <Widget>[
                              Text("查看更多"),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        )),
                  ],
                ),
                Divider(
                  height: 3,
                  color: Colors.black,
                ),
                _buildQuoteHeader(),
                _buildQuoteEntries(),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        : Container();
  }

  //采购单信息
  Widget _buildPurchaseOrderInfo(BuildContext context) {
    return widget.isSupplier
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                      child: RichText(
                        text: TextSpan(
                            text: '订单合作',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${widget.supplierModel.orderCount}',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16)),
                              TextSpan(
                                  text: '次', style: TextStyle(fontSize: 16)),
                            ]),
                      ),
                    )),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: <Widget>[
                              Text("查看更多"),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        )),
                  ],
                ),
                Divider(
                  height: 3,
                  color: Colors.black,
                ),
                _buildPurchaseOrderHeader(context),
                Column(
                  children: _buildPurchaseOrderContent(context),
                ),
                _buildPurchaseOrderBottom(context),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        : Container();
  }

  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            title: Text('供应商名'),
            trailing: Text(widget.supplierModel.factory.name,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('合作单数'),
            trailing: Text(widget.supplierModel.orderCount.toString(),
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('联系人'),
            trailing: Text(widget.supplierModel.factory.contactPerson,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('手机号码'),
            trailing: Text(widget.supplierModel.factory.contactPhone,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          new Divider(),
          ListTile(
            title: Text('地址'),
            trailing: Text(widget.supplierModel.factory.address,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //历史订单信息
  Widget _buildHistoryOrderCount(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 110,
                margin: EdgeInsets.all(5),
                child: Text(
                  '历史接单数',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
//                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${widget.supplierModel.factory.historyOrdersCount}单',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 110,
                margin: EdgeInsets.all(5),
                child: Text(
                  '响应报价时间',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
//                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${widget.supplierModel.factory.responseQuotedTime}小时(平均)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //工厂部分信息
  Widget _buildFactory(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 110,
                margin: EdgeInsets.all(5),
                child: Text(
                  '月均产能',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
//                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${MonthlyCapacityRangesLocalizedMap[widget.supplierModel.factory.monthlyCapacityRange]}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                width: 110,
                child: Text(
                  '产值规模',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
//                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ScaleRangesLocalizedMap[
                            widget.supplierModel.factory.scaleRange],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: 110,
                  child: Text(
                    '优势品类',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
//                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: _buildItemsByEntityList(
                      context, widget.supplierModel.factory.categories),
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //面辅料
  Widget _buildFabric(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                width: 110,
                child: Text(
                  '常备面料',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
//                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.chevron_right),
                    )),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //现款产品
  Widget _buildExistingProductItem(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 110,
                      child: Text(
                        '现款产品',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.all(5),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.chevron_right),
                          )),
                    )
                  ],
                ),
              ),
              Container(
                height: 170,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GridView.count(
                    physics: new NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.5 / 5,
                    children: List.generate(3, (index) {
                      return Container(
                          child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: widget.supplierModel.factory
                                          .products[index].thumbnail !=
                                      null
                                  ? Image.network(
                                      widget.supplierModel.factory
                                          .products[index].thumbnail.url,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1)),
                                      child: Icon(
                                        B2BIcons.noPicture,
                                        color: Color.fromRGBO(200, 200, 200, 1),
                                        size: 60
                                      ),
                                    ),
                            ),
                            Container(
                              child: Text(
                                widget
                                    .supplierModel.factory.products[index].name,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '￥${widget.supplierModel.factory.products[index].price} ～ ￥${widget.supplierModel.factory.products[index].price}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                    })),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExistingProductsPage([]),
            ),
          );
        });
  }

  //合作品牌
  Widget _buildCooperativeBrand(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: 110,
                  child: Text(
                    '合作品牌',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.chevron_right),
                      )),
                )
              ],
            ),
          ),
          /* Container(
             height: 200,
             width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GridView.count(
                    physics: new NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: List.generate(widget.supplierModel.factory.cooperativeBrands.length, (index) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: Image.network(
                          widget.supplierModel.factory.cooperativeBrands[index].profilePicture,
                          width: 60,
                          height: 60,
                          fit: BoxFit.fill,
                        ),
                      );
                    })
                )
            ),*/
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //工厂生产环境
  Widget _buildFactoryWorkPicInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    '硬件设备和生产环境',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Image.network(
                        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548324012344&di=9d970990f5941d68919dfbe264b328c9&imgtype=0&src=http%3A%2F%2Fwww.gdhangying.com%2Fewinupfile%2F2016102911390175014.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '新型H-365裁衣机床',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Image.network(
                        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548324406887&di=065efea8f76ed217de5dbaaed0178471&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F6a600c338744ebf835dc43c9d3f9d72a6159a792.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '新型H-365裁衣机床',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //工厂端认证信息
  Widget _buildFactoryAuthentication(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(
              '认证信息',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('注册时间'),
            trailing: Text(
                '${DateFormatUtil.formatYMD(widget.supplierModel.factory.creationTime)}'),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('车位数量'),
            trailing:
                Text(widget.supplierModel.factory.latheQuantity.toString()),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('税号'),
            trailing: Text(widget.supplierModel.factory.taxNumber),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            leading: Text('开户行'),
            trailing: Text(widget.supplierModel.factory.bankOfDeposit),
          ),
          Divider(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '认证证件',
                    )
                  ],
                ),
                Attachments(
                  list: widget.supplierModel.factory.certificates,
                )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //星级
  List<Widget> _buildItemsStarIcon(BuildContext context, int starLevel) {
    List<Widget> _widget = new List();
    for (int i = 0; i < starLevel; i++) {
      _widget.add(Container(
        child: Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      ));
    }
    return _widget;
  }

  //转换枚举List显示
  List<Widget> _buildItemsByEntityList(
      BuildContext context, List<dynamic> _list) {
    List<Widget> _widget = new List();
    if (_list.isNotEmpty) {
      for (int i = 0; i < _list.length; i++) {
        _widget.add(Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _list[i].name,
                style: TextStyle(fontSize: 16),
              )),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
        ));
      }
    }
    return _widget;
  }

  Widget _buildPurchaseOrderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
        margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  '生产订单号：' + widget.supplierModel.purchaseOrder.code,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                Text(
                  PurchaseOrderStatusLocalizedMap[
                      widget.supplierModel.purchaseOrder.status],
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16, color: Colors.green),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  '创建时间：${DateFormatUtil.formatYMD(widget.supplierModel.purchaseOrder.creationTime)}',
                  style: TextStyle(fontSize: 14),
                )
              ],
            )
          ],
        ));
  }

  List<Widget> _buildPurchaseOrderContent(BuildContext context) {
    return widget.supplierModel.purchaseOrder.entries.map((entry) {
      return Container(
          padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
          margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Row(
            children: <Widget>[
              Image.network(
                entry.product.thumbnail.url,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                entry.product.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '货号：' + entry.product.skuID,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ))
                        ],
                      )))
            ],
          ));
    }).toList();
  }

  Widget _buildPurchaseOrderBottom(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '共' +
                    widget.supplierModel.purchaseOrder.totalQuantity
                        .toString() +
                    '件产品   合计： ￥' +
                    widget.supplierModel.purchaseOrder.totalPrice.toString(),
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            )
          ],
        ));
  }

  Widget _buildQuoteHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '报价单号：${widget.supplierModel.quoteOrder.code}',
                style: TextStyle(fontSize: 15),
              ),
              RichText(
                text: TextSpan(
                    text: '报价',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${widget.supplierModel.quoteOrder.totalPrice}',
                          style: TextStyle(color: Colors.red)),
                      TextSpan(text: '元'),
                    ]),
              ),
              Text(
                  QuoteStateLocalizedMap[widget.supplierModel.quoteOrder.state] ?? '',
                  style: TextStyle(color: Colors.blue, fontSize: 15))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '报价时间：${DateFormatUtil.formatYMD(widget.supplierModel.quoteOrder.creationTime)}',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteEntries() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 10, 10),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: widget.supplierModel.quoteOrder.requirementOrder
                                  .details.pictures !=
                              null &&
                          widget.supplierModel.quoteOrder.requirementOrder
                              .details.pictures.isNotEmpty
                      ?
                  CachedNetworkImage(
                      width: 100,
                      height: 100,
                      imageUrl: widget.supplierModel.quoteOrder
                          .requirementOrder.details.pictures[0].url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30,
                          ),
                      errorWidget: (context, url, error) =>
                          SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30,
                          )
                  )
                      : AssetImage(
                    'temp/picture.png',
                    package: "assets",
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.supplierModel.quoteOrder.requirementOrder.details
                              .productName !=
                          null
                      ? Text(
                          widget.supplierModel.quoteOrder.requirementOrder
                              .details.productName,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          '暂无产品',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  widget.supplierModel.quoteOrder.requirementOrder.details
                              .productSkuID !=
                          null
                      ? Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            '货号：${widget.supplierModel.quoteOrder.requirementOrder.details.productSkuID}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "${widget.supplierModel.quoteOrder.totalQuantity}件",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(255, 214, 12, 1)),
                      )
                    ],
                  ),
                  Text(
                    '需求订单号：${widget.supplierModel.quoteOrder.requirementOrder.code}',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _selectActionButton(String tel) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
                    leading: Icon(Icons.message),
                    title: Text('发送短信'),
                    onTap: () async {
                      var url = 'sms:' + tel;
                      await launch(url);
                    },
                  ),
          ],
        );
      },
    );
  }
}
