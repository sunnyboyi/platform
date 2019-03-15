import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'apparel_product_list.dart';
import 'products/apparel_product_form.dart';
import 'search/apparel_product_search.dart';


class ApparelProductsPage extends StatelessWidget {
//  final List<ApparelProductModel> items = <ApparelProductModel>[];
  final bool isRequirement;
  final ApparelProductModel item;

  ApparelProductsPage({this.isRequirement = false, this.item});

  List<EnumModel> _statuses = <EnumModel>[
    EnumModel('APPROVED', '全部商品'),
//    EnumModel('APPROVED', '上架商品'),
//    EnumModel('UNAPPROVED', '下架商品'),
  ];

  @override
  Widget build(BuildContext context) {
//    List<ApparelProductItem> _items = items.map((item) {
//      return ApparelProductItem(item);
//    }).toList();
//    print("${ApparelProductBLoC.instance.newProduct.hashCode}=============");
    return BLoCProvider<ApparelProductBLoC>(
      bloc: ApparelProductBLoC.instance,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, item);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            centerTitle: true,
            title: Text('商品管理'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 20,
                ),
                onPressed: () => showSearch(
                      context: context,
                      delegate: ApparelProductSearchDelegate(),
                    ),
              ),
            ],
          ),
          body:DefaultTabController(
            length: _statuses.length,
            child: Scaffold(
              appBar: TabBar(
                unselectedLabelColor: Colors.black26,
                labelColor: Color.fromRGBO(255,214,12, 1),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: _statuses.map((status) {
                  return Tab(text: status.name);
                }).toList(),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
                isScrollable: false,
              ),
              body: TabBarView(
                children: _statuses
                    .map((status) => ApparelProductList(
                  isRequirement: isRequirement,
                ),)
                    .toList(),
              ),
            ),
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ApparelProductFormPage(
                          item: ApparelProductBLoC.instance.newProduct,
                          isCreate: true,
                        )),
              );
            },
          ),
        ),
      ),
    );
  }
}
