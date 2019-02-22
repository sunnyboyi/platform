import 'dart:io';

import 'package:b2b_commerce/src/business/orders/requirement_import_product.dart';
import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

final List<Map<CategoryModel, List<CategoryModel>>> _category = [
  {
    CategoryModel(code: 'C01', name: '男装'): [
      CategoryModel(code: 'C001', name: 'T恤',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C002', name: '衬衫',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C003', name: '卫衣',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C004', name: '卫裤',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C005', name: '卫裤',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C006', name: '卫裤',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C007', name: '卫裤',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C008', name: '卫裤',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C009', name: '羽绒服',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C010', name: '绒服地方',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C011', name: '卫裤',parent: CategoryModel(code: 'C01', name: '男装')),
      CategoryModel(code: 'C012', name: '卫裤',parent: CategoryModel(code: 'C01', name: '男装')),
    ],
    CategoryModel(code: 'C02', name: '女装'): [
      CategoryModel(code: 'C013', name: '棉服服',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C014', name: '羽绒服地方',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C015', name: '背带裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C016', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C017', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C018', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C019', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C020', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C021', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C022', name: '牛仔裤裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C023', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
      CategoryModel(code: 'C024', name: '牛仔裤',parent: CategoryModel(code: 'C02', name: '女装')),
    ],
  },
];

final List<CategoryModel> _majorCategory = [
  CategoryModel(code: 'C2', name: '针织'),
  CategoryModel(code: 'C3', name: '针织'),
  CategoryModel(code: 'C4', name: '针织'),
];

final List<EnumModel> technologyList = [
  EnumModel.fromJson({'code': '全工艺', 'name': '全工艺'}),
  EnumModel.fromJson({'code': '打板', 'name': '打板'}),
  EnumModel.fromJson({'code': '车缝', 'name': '车缝'}),
  EnumModel.fromJson({'code': '裁剪', 'name': '裁剪'}),
  EnumModel.fromJson({'code': '印花', 'name': '印花'}),
  EnumModel.fromJson({'code': '后枕', 'name': '后枕'}),
];

final List<EnumModel> productionAreaList = [
  EnumModel.fromJson({'code': 'GuangDong', 'name': '广东省'}),
  EnumModel.fromJson({'code': 'BeiJing', 'name': '北京市'}),
  EnumModel.fromJson({'code': 'ZheJiang', 'name': '浙江省'}),
  EnumModel.fromJson({'code': 'ShangHai', 'name': '上海市'}),
];

class RequirementOrderFrom extends StatefulWidget {
  _RequirementOrderFromState createState() => _RequirementOrderFromState();
}

class _RequirementOrderFromState extends State<RequirementOrderFrom> {
  List<CategoryModel> _mojarSelected = [];
  List<EnumModel> _mojarEnumSelected = [];
  List<CategoryModel> _categorySelected = [];
  List<EnumModel> _productionAreaSelected = [];
  String mojar = '选取';
  String category = '选取';
  String processCount = '输入';
  String expectPrice = '输入';
  TextEditingController inputNumber;
  TextEditingController inputPerson;
  bool _isShowMore = true;
  String address = '选取';
  String processingType = '选取';
  String technology = '选取';
  String deliveryDate = '选取';
  String remarks = '输入';
  List<File> _normalImages = [];
  List<String> normal;
  String isProvideSampleProduct = '选取';
  String isInvoice = '选取';
  String inspectionMethod = '选取';
  bool _isRequirementPool = true;
  String _productionArea = '选取';
  String isProofing = '选取';
  String contactInformation = '输入';
  String contactPerson = '';
  String contactPhone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('需求发布'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.play_for_work),
              color: Color.fromRGBO(255, 149, 22, 1),
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequirementImportProduct(),
                    ),
                  )
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Center(
                  child: Text(
                    '导入商品',
                    style: TextStyle(color: Color.fromRGBO(255, 149, 22, 1)),
                  ),
                ),
              ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequirementImportProduct(),
                    ),
                  );
                }
            )
          ],
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            _buildBody(context),
            _buildCommitButton(context),
          ],
        ))
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: <Widget>[
            _buildPic(context),
            _buildMajor(context),
            new Divider(height: 0,),
            _buildCategory(context),
            new Divider(height: 0,),
            _buildProcessCount(context),
            new Divider(height: 0,),
            _buildExpectPrice(context),
            new Divider(height: 0,),
            _buildDeliveryDate(context),
            new Divider(height: 0,),
            _buildContactInformation(context),
            new Divider(height: 0,),
            _buildAddress(context),
            _isShowMore ? Container() : new Divider(height: 0,),
            _buildHideBody(context),
            _buildHideTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHideBody(BuildContext context) {
    return Offstage(
        offstage: _isShowMore,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                _buildProductionArea(context),
                new Divider(height: 0,),
                _buildCooperationModes(context),
                new Divider(height: 0,),
                _buildProofing(context),
                new Divider(height: 0,),
                _buildSampleProduct(context),
                new Divider(height: 0,),
                _buildInvoice(context),
                new Divider(height: 0,),
                _buildRemarks(context),
              ],
            ),
          ),
        ));
  }

  //图片
  Widget _buildPic(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                '参考图片',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '（若无图片可不上传）',
                style: TextStyle(color: Colors.red, fontSize: 14),
              )
            ],
          ),
        ),
        PhotoPicker(
          images: _normalImages,
          maxNum: 10,
          width: 400,
        ),
      ],
    );
  }

  //大类
  Widget _buildMajor(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '商品大类',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(mojar,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis),
                  ))),
        ),
        onTap: () {
          _showMajorCategorySelect();
        });
  }

  //小类
  Widget _buildCategory(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '商品类目',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis),
                  ))),
        ),
        onTap: () {
          _showCategorySelect();
        });
  }

  //加工数量
  Widget _buildProcessCount(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '加工数量',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              processCount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _neverProcessCount(context);
        });
  }

  //期望价格
  Widget _buildExpectPrice(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '期望价格',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              expectPrice,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _neverExpectPrice(context);
        });
  }

  //交货时间
  Widget _buildDeliveryDate(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '交货时间',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(deliveryDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis),
                  ))),
        ),
        onTap: () {
          _showDatePicker();
        });
  }

  //联系方式
  Widget _buildContactInformation(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '联系方式',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              contactInformation,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _neverContactInformation(context);
        });
  }

  //送货地址
  Widget _buildAddress(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '送货地址',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              address,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          address = '';
          setState(() {
            address = address;
          });
          AddressPicker.showAddressPicker(
            context,
            selectProvince: (province) {
              address += province['name'];
            },
            selectCity: (city) {
              address += city['name'];
            },
            selectArea: (area) {
              address += area['name'];
              setState(() {
                address = address;
              });
            },
          );
        });
  }

  //是否展开更多
  Widget _buildHideTips(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(''),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '继续完善需求信息，更加精准匹配工厂',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    '更多条件',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFF9516),
                    ),
                  ),
                  Icon(
                    _isShowMore
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Color(0xFFFF9516),
                    size: 28,
                  ),
                ],
              )),
          decoration: BoxDecoration(
            color: Color.fromRGBO(242, 242, 242, 1),
          ),
        ),
        onTap: () {
          setState(() {
            _isShowMore = !_isShowMore;
          });
        });
  }

  //生产地区倾向
  Widget _buildProductionArea(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '生产地区',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              _productionArea,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _showProductionAreaSelect();
        });
  }

  //加工类型
  Widget _buildCooperationModes(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '加工类型',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              processingType,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _showTypeSelect();
        });
  }

  //是否需要打样
  Widget _buildProofing(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否需要打样',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              isProofing,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _showIsProofingSelect();
        });
  }

  //是否提供样衣
  Widget _buildSampleProduct(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否提供样衣',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              isProvideSampleProduct,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _showIsProvideSampleProductSelect();
        });
  }

  //是否开具发票
  Widget _buildInvoice(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否开具发票',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              isInvoice,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _showIsInvoiceSelect();
        });
  }

  //订单备注
  Widget _buildRemarks(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '订单备注',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              remarks,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          _neverOrderRemarks(context);
        });
  }

  //确认发布按钮
  Widget _buildCommitButton(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: RaisedButton(
                  color: Color(0xFFFF9516),
                  child: Text(
                    '确定发布',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  onPressed: () {})),
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            width: 200,
            child: Center(
              child: CheckboxListTile(
                title: Text(
                  '发布到需求池',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey),
                ),
                value: _isRequirementPool,
                onChanged: (T) {
                  setState(() {
                    _isRequirementPool = !_isRequirementPool;
                  });
                },
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 242, 242, 1),
      ),
    );
  }

  //大类
  void _showMajorCategorySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: EnumSelection(
            enumModels: _majorCategory.map((category) => EnumModel(category.code, category.name)).toList(),
            multiple: false,
            enumSelect: _mojarEnumSelected,
          ),
        );
      },
    ).then((val) {
      _mojarSelected = _mojarEnumSelected.map((enumModel) => CategoryModel(code: enumModel.code,name: enumModel.name)).toList();
      mojar = '';
      if (_mojarSelected.isNotEmpty) {
        for (int i = 0; i < _mojarSelected.length; i++) {
          mojar += _mojarSelected[i].name + ',';
        }
      }
      setState(() {
        mojar = mojar;
      });
    });
  }

  //小类
  void _showCategorySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: CategorySelect(
            categorys: _category,
            multiple: false,
            verticalDividerOpacity: 1,
            categorySelect: _categorySelected,
          ),
        );
      },
    ).then((val) {
      category = '';
      if (_categorySelected.isNotEmpty) {
        for (int i = 0; i < _categorySelected.length; i++) {
          category += _categorySelected[i].name + ',';
        }
      }
      setState(() {
        category = category;
      });
    });
  }

  //加工数量
  Future<void> _neverProcessCount(BuildContext context) async {
    inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入加工数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入加工数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    processCount = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //联系方式
  Future<void> _neverContactInformation(BuildContext context) async {
    inputNumber = TextEditingController();
    inputPerson = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入联系方式'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputPerson,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: '请输入联系人',
                  ),
                ),
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入手机号码',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null && inputPerson.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    contactInformation = inputPerson.text + ',' +inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //期望价格
  Future<void> _neverExpectPrice(BuildContext context) async {
    inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入加工数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入加工数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    expectPrice = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999));

    if (_picked != null) {
      print(_picked);
      setState(() {
        deliveryDate = DateFormatUtil.formatYMD(_picked);
      });
    }
  }

  //加工类型
  void _showTypeSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('清加工'),
                  onTap: () async {
                    setState(() {
                      processingType = '清加工';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('包工包料'),
                  onTap: () async {
                    setState(() {
                      processingType = '包工包料';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //订单备注
  Future<void> _neverOrderRemarks(BuildContext context) async {
    inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('备注'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入订单备注',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    remarks = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //是否打样选项
  void _showIsProofingSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('需要打样'),
                  onTap: () async {
                    setState(() {
                      isProofing = '需要打样';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不需要打样'),
                  onTap: () async {
                    setState(() {
                      isProofing = '不需要打样';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //是否提供样衣选项
  void _showIsProvideSampleProductSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('提供样衣'),
                  onTap: () async {
                    setState(() {
                      isProvideSampleProduct = '提供样衣';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不提供样衣'),
                  onTap: () async {
                    setState(() {
                      isProvideSampleProduct = '不提供样衣';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //是否开具发票选项
  void _showIsInvoiceSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('开发票'),
                  onTap: () async {
                    setState(() {
                      isInvoice = '开发票';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('不开发票'),
                  onTap: () async {
                    setState(() {
                      isInvoice = '不开发票';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  //生产地倾向
  void _showProductionAreaSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: EnumSelection(
            enumModels: productionAreaList,
            multiple: true,
            enumSelect: _productionAreaSelected,
          ),
        );
      },
    ).then((val) {
      _productionArea = '';
      if (_productionAreaSelected.isNotEmpty) {
        for (int i = 0; i < _productionAreaSelected.length; i++) {
          _productionArea += _productionAreaSelected[i].name + ',';
        }
      }
      setState(() {
        _productionArea = _productionArea;
      });
    });
  }

}
