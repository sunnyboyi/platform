import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:b2b_commerce/src/my/company/form/my_brand_address_form.dart';
import 'package:b2b_commerce/src/my/company/form/my_brand_contact_form.dart';
import 'package:common_utils/common_utils.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyBrandBaseFormPage extends StatefulWidget {
  MyBrandBaseFormPage(this.brand);

  final BrandModel brand;

  @override
  State createState() => MyBrandBaseFormPageState();
}

class MyBrandBaseFormPageState extends State<MyBrandBaseFormPage> {
  BrandModel _brand;
  List<MediaModel> medias = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _cooperativeBrandController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _brandFocusNode = FocusNode();
  FocusNode _cooperativeBrandFocusNode = FocusNode();

  String _scaleRange;
  double _fontSize = 16;

  @override
  void initState() {
    _brand = BrandModel.fromJson(BrandModel.toJson(widget.brand));
    if (_brand.profilePicture != null) medias = [_brand.profilePicture];
    _nameController.text = _brand.name ?? '';
    _brandController.text = _brand.brand ?? '';
    _cooperativeBrandController.text = _brand.cooperativeBrand ?? '';
    if (_brand.scaleRange != null) {
      _scaleRange = _brand.scaleRange.toString().split('.')[1];
      print(_brand.scaleRange.toString().split('.')[1]);
    }

    if (_brand.salesMarket == null) {
      _brand.salesMarket = [];
    }
    if (_brand.styles == null) {
      _brand.styles = [];
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('基本资料'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text('保存', style: TextStyle(color: Color(0xffffd60c))),
              onPressed: () {
                if (ObjectUtil.isEmptyList(medias)) {
                  ShowDialogUtil.showValidateMsg(context, '请上传企业logo');
                  return;
                }
                if (ObjectUtil.isEmptyString(_brand.name)) {
                  ShowDialogUtil.showValidateMsg(context, '请填写公司名称');
                  return;
                }
                if (ObjectUtil.isEmptyString(_brand.duties) ||
                    ObjectUtil.isEmptyString(_brand.contactPerson) ||
                    ObjectUtil.isEmptyString(_brand.contactPhone)) {
                  ShowDialogUtil.showValidateMsg(context, '请完善联系信息');
                  return;
                }
                if (_brand.contactAddress?.region?.isocode == null ||
                    ObjectUtil.isEmptyString(_brand.contactAddress.line1)) {
                  ShowDialogUtil.showValidateMsg(context, '请填写企业地址');
                  return;
                }
                if (ObjectUtil.isEmptyList(_brand.adeptAtCategories)) {
                  ShowDialogUtil.showValidateMsg(context, '请选择优势品类');
                  return;
                }
                if (medias.length > 0) {
                  _brand.profilePicture = medias[0];
                } else {
                  _brand.profilePicture = null;
                }
                _brand.name =
                _nameController.text == '' ? null : _nameController.text;
                _brand.brand =
                _brandController.text == '' ? null : _brandController.text;
                _brand.cooperativeBrand = _cooperativeBrandController.text == ''
                    ? null
                    : _cooperativeBrandController.text;

                UserRepositoryImpl().brandUpdate(_brand).then((a) {
                  UserBLoC.instance.refreshUser().then((v) {
                    print('+++++++++++++++++++++');
                  });
                  Navigator.pop(context, true);
                });
              })
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '企业logo',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: _fontSize,
                              )),
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red, fontSize: _fontSize)),
                        ]),
                      ),
                      Text('（长按编辑）',style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: EditableAttachments(
                      list: medias,
                      imageWidth: 100,
                      imageHeight: 100,
                      // isCut: true,
                      ratioY: 1,
                      ratioX: 1,
                      maxNum: 1,
                      loogPressDelete: false,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '公司名称',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: _fontSize,
                          )),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                    ]),
                  ),
                  Expanded(
                    child: TextFieldComponent(
                      padding: EdgeInsets.all(0),
                      focusNode: _nameFocusNode,
                      controller: _nameController,
                      hintText: '请输入公司名称',
                      hideDivider: true,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyBrandContactFormPage(
                              company: _brand,
                            )));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: '联系信息',
                            style: TextStyle(
                                color: Colors.black, fontSize: _fontSize)),
                        TextSpan(
                            text: '*',
                            style: TextStyle(
                                color: Colors.red, fontSize: _fontSize)),
                      ]),
                    ),
                    Expanded(
                        child: Text(
                          _buildContactText(),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.grey),
                        )),
                    Icon(
                      (Icons.chevron_right),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            GestureDetector(
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyBrandAddressFormPage(
                              addressModel: _brand.contactAddress,
                            )));
                if (result != null) {
                  _brand.contactAddress = result;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: '企业地址',
                            style: TextStyle(
                                color: Colors.black, fontSize: _fontSize)),
                        TextSpan(
                            text: '*',
                            style: TextStyle(
                                color: Colors.red, fontSize: _fontSize)),
                      ]),
                    ),
                    Expanded(
                        child: Text(
                          '${_brand?.contactAddress?.details ?? ''}',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.grey),
                        )),
                    Icon(
                      (Icons.chevron_right),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            GestureDetector(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '优势类目',
                              style: TextStyle(
                                  color: Colors.black, fontSize: _fontSize)),
                          TextSpan(
                              text: '*',
                              style: TextStyle(
                                  color: Colors.red, fontSize: _fontSize)),
                        ]),
                      ),
                    ),
                    Text(formatCategorySelectText(_brand.adeptAtCategories),
                        style: TextStyle(color: Colors.grey)),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                List<CategoryModel> categories =
                await ProductRepositoryImpl().cascadedCategories();
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategorySelectPage(
                      categories: categories,
                      minCategorySelect: _brand.adeptAtCategories,
                      multiple: true,
                    ),
                  ),
                );

                if (result != null) {
                  _brand.adeptAtCategories = result;
                }
              },
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '品牌名称',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: _fontSize,
                          )),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextFieldComponent(
                        padding: EdgeInsets.all(0),
                        focusNode: _brandFocusNode,
                        controller: _brandController,
                        hintText: '请输入品牌名称',
                        hideDivider: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '合作品牌',
                          style: TextStyle(
                              color: Colors.black, fontSize: _fontSize)),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextFieldComponent(
                        padding: EdgeInsets.all(0),
                        focusNode: _cooperativeBrandFocusNode,
                        controller: _cooperativeBrandController,
                        hintText: '请输入合作品牌',
                        hideDivider: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            GestureDetector(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '产值规模',
                              style: TextStyle(
                                  color: Colors.black, fontSize: _fontSize)),
                        ]),
                      ),
                    ),
                    Text(
                      _brand.scaleRange == null
                          ? ''
                          : ScaleRangesLocalizedMap[_brand.scaleRange],
                      style: TextStyle(color: Colors.grey),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              onTap: _onScaleSelect,
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            GestureDetector(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: '质量等级',
                              style: TextStyle(
                                  color: Colors.black, fontSize: _fontSize)),
                        ]),
                      ),
                    ),
                    Text(
                      formatEnumSelectsText(
                          _brand.salesMarket, FactoryQualityLevelsEnum, 2),
                      style: TextStyle(color: Colors.grey),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              onTap: _onQualitySelect,
            ),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
            GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '风格',
                                style: TextStyle(
                                    color: Colors.black, fontSize: _fontSize)),
                          ]),
                        ),
                      ),
                      Text(formatEnumSelectsText(_brand.styles, StyleEnum, 4),
                          style: TextStyle(color: Colors.grey)),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
                onTap: _onStyleSelect),
            Divider(
              height: 0,
              color: Color(Constants.DIVIDER_COLOR),
            ),
          ],
        ),
      ),
    );
  }

  String _buildContactText() {
    String text = '未填写';
    if (!ObjectUtil.isEmptyString(_brand.duties) &&
        !ObjectUtil.isEmptyString(_brand.contactPerson) &&
        !ObjectUtil.isEmptyString(_brand.contactPhone)) {
      text = '已填写';
    }
    return text;
  }

  String formatCategorySelectText(List<CategoryModel> categorys) {
    String text = '';

    if (categorys != null) {
      text = '';
      for (int i = 0; i < categorys.length; i++) {
        if (i > 1) {
          text += '...';
          break;
        }

        if (i == categorys.length - 1) {
          text += categorys[i].name;
        } else {
          text += categorys[i].name + '、';
        }
      }
    }

    return text;
  }

  void _onScaleSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleEnumSelectPage(
          items: ScaleRangesEnum,
          title: '产值规模',
          code: _scaleRange,
          count: 3,
        );
      },
    ).then((result) {
      if (result != null) _scaleRange = result;

      ScaleRanges scaleRange = scaleRangeFromString(_scaleRange);

      setState(() {
        _brand.scaleRange = scaleRange;
      });
    });
  }

  void _onQualitySelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          items: FactoryQualityLevelsEnum,
          title: '质量等级',
          codes: _brand.salesMarket,
          count: 3,
          multiple: true,
        );
        // return MultiEnumSelect<ScaleRanges>(
        //   title: '质量等级',
        //   localizedMap: ScaleRangesLocalizedMap,
        //   values: [ScaleRanges.SR001],
        // );
      },
    ).then((result) {
      setState(() {
        if (result != null) {
          _brand.salesMarket = result;
        }
      });
    });
  }

  void _onStyleSelect() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EnumSelectPage(
          title: '选择风格',
          items: StyleEnum,
          codes: _brand.styles,
          multiple: true,
        );
        // return MultiEnumSelect<ScaleRanges>(
        //   title: '质量等级',
        //   localizedMap: ScaleRangesLocalizedMap,
        //   values: [ScaleRanges.SR001],
        // );
      },
    ).then((result) {
      setState(() {
        if (result != null) {
          _brand.styles = result;
        }
      });
    });
  }
}
