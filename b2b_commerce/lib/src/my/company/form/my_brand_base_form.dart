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

  List<String> _scaleRange = [];
  double _fontSize = 16;

  @override
  void initState() {
    _brand = BrandModel.fromJson(BrandModel.toJson(widget.brand));
    if (_brand.profilePicture != null) medias = [_brand.profilePicture];
    _nameController.text = _brand.name ?? '';
    _brandController.text = _brand.brand ?? '';
    _cooperativeBrandController.text = _brand.cooperativeBrand ?? '';
    if (_brand.scaleRange != null) {
      _scaleRange.add(_brand.scaleRange.toString().split('.')[1]);
      print(_brand.scaleRange.toString().split('.')[1]);
    }

    if(_brand.salesMarket == null){
      _brand.salesMarket = [];
    }
    if(_brand.styles == null){
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
                if (ObjectUtil.isEmptyString(_brand.name)) {
                  ShowDialogUtil.showValidateMsg(context, '请填写公司名称');
                  return;
                }
                if(ObjectUtil.isEmptyString(_brand.duties)|| ObjectUtil.isEmptyString(_brand.contactPerson) || ObjectUtil.isEmptyString(_brand.contactPhone)){
                  ShowDialogUtil.showValidateMsg(context, '请完善联系信息');
                  return;
                }
                if(_brand.contactAddress == null){
                  ShowDialogUtil.showValidateMsg(context, '请填写企业地址');
                  return;
                }
                if(ObjectUtil.isEmptyList(_brand.adeptAtCategories)){
                  ShowDialogUtil.showValidateMsg(context, '请选择优势品类');
                  return;
                }
                if (medias.length > 0) {
                  _brand.profilePicture = medias[0];
                } else {
                  _brand.profilePicture = null;
                }
                _brand.name = _nameController.text == '' ? null : _nameController.text;
                _brand.brand = _brandController.text == '' ? null : _brandController.text;
                _brand.cooperativeBrand =
                    _cooperativeBrandController.text == '' ? null : _cooperativeBrandController.text;

                UserRepositoryImpl().brandUpdate(_brand).then((a) {
                  UserBLoC.instance.refreshUser().then((v){
                    print('+++++++++++++++++++++');
                  });
                  Navigator.pop(context,true);
                });
              })
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '上传企业logo',
                      style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                    ),
                    TextSpan(
                      text: '(长按编辑)',
                      style: TextStyle(color: Colors.grey,fontSize: 14,)
                    ),
                  ]
                ),
              ),
            ),
            EditableAttachments(
              list: medias,
              maxNum: 1,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: '公司名称',
                              style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                          ),
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: Colors.red)
                          ),
                        ]
                    ),
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
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyBrandContactFormPage(company: _brand,)));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '联系信息',
                                style: TextStyle(color: Colors.black,fontSize: _fontSize)
                            ),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red,fontSize: _fontSize)
                            ),
                          ]
                      ),
                    ),
                    Expanded(child: Text(_buildContactText(),textAlign: TextAlign.end,style: TextStyle(color: Colors.grey),)),
                    Icon((Icons.chevron_right),color: Colors.grey,),
                  ],
                ),
              ),
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            GestureDetector(
              onTap: () async {
                dynamic result = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        MyBrandAddressFormPage(
                          addressModel: _brand.contactAddress,)));
                print(result.region);
                print(result.city);
                if (result != null) {
                  _brand.contactAddress = result;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '企业地址',
                                style: TextStyle(color: Colors.black,fontSize: _fontSize)
                            ),
                            TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red,fontSize: _fontSize)
                            ),
                          ]
                      ),
                    ),
                    Expanded(child: Text('${_brand?.contactAddress?.details}',textAlign: TextAlign.end,style: TextStyle(color: Colors.grey),)),
                    Icon((Icons.chevron_right),color: Colors.grey,),
                  ],
                ),
              ),
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            GestureDetector(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '优势类目',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red,fontSize: _fontSize)
                              ),
                            ]
                        ),
                      ),
                    ),
                    Text(
                      formatCategorySelectText(_brand.adeptAtCategories),style: TextStyle(color: Colors.grey)
                    ),
                    Icon(Icons.chevron_right,color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                List<CategoryModel> categories = await ProductRepositoryImpl().cascadedCategories();
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
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: '品牌名称',
                              style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                          ),
                        ]
                    ),
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
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: '合作品牌',
                              style: TextStyle(color: Colors.black,fontSize: _fontSize)
                          ),
                        ]
                    ),
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
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            GestureDetector(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '产值规模',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                            ]
                        ),
                      ),
                    ),
                    Text(_brand.scaleRange == null ? '' : ScaleRangesLocalizedMap[_brand.scaleRange],style: TextStyle(color: Colors.grey),),
                    Icon(Icons.chevron_right,color: Colors.grey,),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                        items: ScaleRangesEnum,
                        title: '产值规模',
                        codes: _scaleRange,
                        count: 3,
                      ),
                    ));

                if (result != null) _scaleRange = result;

                if (_scaleRange.length > 0) {
                  ScaleRanges scaleRange = ScaleRanges.values.singleWhere(
                          (scaleRange) => scaleRange.toString().split('.')[1] == _scaleRange[0],
                      orElse: () => null);

                  _brand.scaleRange = scaleRange;
                }
              },
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            GestureDetector(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '质量等级',
                                  style: TextStyle(color: Colors.black,fontSize: _fontSize)
                              ),
                            ]
                        ),
                      ),
                    ),
                    Text(formatEnumSelectsText(_brand.salesMarket,FactoryQualityLevelsEnum,2),style: TextStyle(color: Colors.grey),),
                    Icon(Icons.chevron_right,color: Colors.grey,),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnumSelectPage(
                        items: FactoryQualityLevelsEnum,
                        title: '质量等级',
                        codes: _brand.salesMarket,
                        count: 3,
                        multiple: true,
                      ),
                    ));

                if (result != null){
                  _brand.salesMarket = result;
                }
                print('${_brand.salesMarket}[]]]]]]]]]');
                print('${result}[]]]]]]]]]');
              },
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
            GestureDetector(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: '风格',
                                    style: TextStyle(color: Colors.black,fontSize: _fontSize)
                                ),
                              ]
                          ),
                        ),),
                    Text(
                      formatEnumSelectsText(_brand.styles, StyleEnum, 4),style: TextStyle(color: Colors.grey)
                    ),
                    Icon(Icons.chevron_right,color: Colors.grey),
                  ],
                ),
              ),
              onTap: () async {
                dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnumSelectPage(
                          title: '选择风格',
                          items: StyleEnum,
                          codes: _brand.styles,
                          multiple: true,
                        ),
                  ),
                );

                if (result != null) {
                  _brand.styles = result;
                }
              },
            ),
            Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
          ],
        ),
      ),
    );
  }

  String _buildContactText(){
    String text = '未填写';
    if(!ObjectUtil.isEmptyString(_brand.duties) &&
        !ObjectUtil.isEmptyString(_brand.contactPerson) &&
        !ObjectUtil.isEmptyString(_brand.contactPhone)){
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
}
