import 'dart:async';
import 'dart:convert';

import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_second_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 产品分类选择页
class RequirementOrderFirstForm extends StatefulWidget {
  RequirementOrderFirstForm({
    this.formState,
  });

  final RequirementOrderFormState formState;

  _RequirementOrderFirstFormState createState() =>
      _RequirementOrderFirstFormState();
}

class _RequirementOrderFirstFormState extends State<RequirementOrderFirstForm> {
  GlobalKey _scaffoldKey = GlobalKey();
  CategoryModel _categorySelect;

  @override
  void initState() {
    //埋点>>>需求发布1页面进入
    FlutterUmplus.event("requirement_publish_1_page");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ShowDialogUtil.showChoseDiglog(context, '正在创建订单，是否确认退出', () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('需求发布(1/2)'),
          actions: <Widget>[],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '下一步',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              onPressed: () async {
                print(widget.formState.model.details.category);
                print(widget.formState.model.details.majorCategory);
                if (widget.formState.model.details.majorCategory == null) {
                  ShowDialogUtil.showValidateMsg(context, '请选择面料类别');
                  return;
                }
                if (widget.formState.model.details.category == null) {
                  ShowDialogUtil.showValidateMsg(context, '请选择品类');
                  return;
                }
                if (widget.formState.model.details.productiveOrientations ==
                        null ||
                    widget.formState.model.details.productiveOrientations
                            .length ==
                        0) {
                  ShowDialogUtil.showValidateMsg(context, '请选择工厂区域');
                  return;
                }
                //埋点>>>需求发布1填写下一步
                FlutterUmplus.event("requirement_publish_1_finsh",
                    label:
                    '${widget.formState.model.details.majorCategory.name}');

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RequirementOrderSecondForm(
                          formState: widget.formState,
                        )));
              }),
        ),
        body: ListView(
          children: <Widget>[
            Consumer(
              builder: (context, MajorCategoryState categoryState, _) =>
                  FutureBuilder(
                future: categoryState.getMajorCategories(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CategoryModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      color: Colors.white,
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '选择面料类型',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    )
                                  ]),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                    '已选：${widget.formState.model.details
                                        ?.majorCategory?.name ?? ''}'),
                              )
                            ],
                          ),
                          SingleMajorCategorySelect(
                            categories: snapshot.data,
                            categorySelect:
                                widget.formState.model.details.majorCategory,
                            onItemTap: (categoryModel) {
                              setState(() {
                                widget.formState.model.details.majorCategory =
                                    categoryModel;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Divider(
              height: 0,
              color: Colors.grey[350],
              thickness: 1.5,
            ),
            Consumer(
              builder: (context, CategoryState categoryState, _) =>
                  FutureBuilder(
                future: categoryState.getCascadedCategories(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CategoryModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      color: Colors.white,
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '选择品类',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' *    ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '已选：',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${widget.formState.model.details.category?.parent != null ? widget.formState.model.details.category.parent.name + '-' : ''}'
                                          '${widget.formState.model.details.category?.name ?? ''}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SingleMajorCategorySelectGridView(
                            categories: snapshot.data,
                            categorySelect:
                                widget.formState.model.details.category?.parent,
                            onItemTap: (categoryModel) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Consumer(
                                      builder: (context,
                                              CategoryState categoryState, _) =>
                                          FutureBuilder(
                                        future: categoryState
                                            .getCascadedCategories(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<CategoryModel>>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else {
                                            return SingleCategorySelect(
                                              selectLeft: categoryModel.code,
                                              categories: snapshot.data,
                                              categorySelect: widget.formState
                                                  .model.details.category,
                                              onItemTap: (categoryModel) {
                                                setState(() {
                                                  widget.formState.model.details
                                                      .category = categoryModel;
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Divider(
              height: 0,
              color: Colors.grey[350],
              thickness: 1.5,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 15,
              ),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '选择工厂区域',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          TextSpan(
                            text: ' *    ',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: '已选：',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          TextSpan(
                            text: formatAreaSelectsText(
                                widget.formState.model.details
                                    .productiveOrientations,
                                2),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          //CN-10代表全国
                          setState(() {
                            widget
                                .formState.model.details.productiveOrientations
                                .add(RegionModel(isocode: 'CN-10'));
                          });
                          dynamic m = widget
                              .formState.model.details.productiveOrientations
                              .firstWhere((region) => region.isocode == 'CN-10',
                                  orElse: null);
                          print(m);
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: ClassHandleUtil.isNotEmpty(widget
                                      .formState
                                      .model
                                      .details
                                      .productiveOrientations) &&
                                  widget.formState.model.details
                                          .productiveOrientations
                                          .indexWhere(
                                        (region) => region.isocode == 'CN-10',
                                      ) >
                                      -1
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffd60c))
                              : BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                          child: Center(child: Text('全国')),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            //获取所有省份
                            rootBundle
                                .loadString('data/province_only.json')
                                .then((v) {
                              List data = json.decode(v);
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return RegionSelector(
                                    regions: data
                                        .map<RegionModel>((region) =>
                                            RegionModel.fromJson(region))
                                        .toList(),
                                    regionSelects: widget.formState.model
                                        .details.productiveOrientations,
                                    multiple: true,
                                  );
                                },
                              ).then((v) {
                                setState(() {
                                  widget.formState.model.details
                                      .productiveOrientations
                                      .removeWhere((region) =>
                                          region.isocode == 'CN-10');
                                });
                              });
                            });
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: ClassHandleUtil.isNotEmpty(widget
                                      .formState
                                      .model
                                      .details
                                      .productiveOrientations) &&
                                  widget.formState.model.details
                                          .productiveOrientations
                                          .indexWhere(
                                        (region) => region.isocode == 'CN-10',
                                      ) <
                                      0
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffd60c))
                              : BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text('自定义')),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //格式选中的地区（多选）
  String formatAreaSelectsText(List<RegionModel> selects, int count) {
    String text = '';

    if (widget.formState.model.details.productiveOrientations.indexWhere(
          (region) => region.isocode == 'CN-10',
        ) >
        -1) {
      return '全国';
    }

    for (int i = 0; i < selects.length; i++) {
      if (i > count - 1) {
        text += '...';
        break;
      }

      if (i == selects.length - 1) {
        text += selects[i].name;
      } else {
        text += selects[i].name + '、';
      }
    }

    return text;
  }
}
