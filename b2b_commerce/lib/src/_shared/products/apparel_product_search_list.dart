import 'package:b2b_commerce/src/_shared/products/apparel_product_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/products/brand/apparel_product_brand_detail.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_detail.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:widgets/widgets.dart';

class ApparelProductSearchList extends StatefulWidget {
  ApparelProductSearchList({
    Key key,
    this.status,
    this.keyword,
    this.isSelection = false,
  }) : super(key: key);
  final String status;

  //是否选择项
  final bool isSelection;

  final String keyword;

  final ScrollController scrollController = ScrollController();

  _ApparelProductSearchListState createState() => _ApparelProductSearchListState();
}

class _ApparelProductSearchListState extends State<ApparelProductSearchList> {
  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ApparelProductBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if(widget.isSelection){
          bloc.loadingMoreSelectData(widget.keyword,status: widget.status);
        }else{
          bloc.loadingMoreSearchData(widget.keyword,status: widget.status);
        }

      }
    });

    //监听滚动事件，打印滚动位置
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (widget.scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        widget.scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
//        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            if(widget.isSelection){
              return await bloc.getSelectData(widget.keyword,status: widget.status);
            }else{
              return await bloc.getSearchData(widget.keyword,status: widget.status);
            }
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: widget.scrollController,
            children: <Widget>[
              StreamBuilder<PageEntry>(
                stream: widget.isSelection ? bloc.selectSearchStream : bloc.searchStream,
                builder: (BuildContext context,
                    AsyncSnapshot<PageEntry> snapshot) {
                  if (snapshot.data == null) {
                    if(widget.isSelection){
                      bloc.getSelectData(widget.keyword,status: widget.status);
                    }else{
                      bloc.getSearchData(widget.keyword,status: widget.status);
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.data.data.length <= 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          child: Image.asset(
                            'temp/logo2.png',
                            package: 'assets',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Container(child: Text('搜不到含有该关键字的产品')),
                        Container(
                          child: Text('请点击右下角创建产品'),
                        ),
                        Container(
                          child: FlatButton(
                            color: Color.fromRGBO(255, 214, 12, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyHelpPage()));
                            },
                            child: Text('如何创建产品？'),
                          ),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.data.map((product) {
                        return ApparelProductItem(
                          isSelectOption: widget.isSelection,
                          item: product,
                          onPrdouctProduction: () => _onProudctProduction(product),
                          onProductShlefing:  () => _onProductShlefing(product),
                          onPrdouctUpdating: () => _onProductUpdating(product),
                          onPrdouctDeleting: () => _onProductDeleting(product),
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.bottomStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  // if (snapshot.data) {
                  //   widget.scrollController.animateTo(widget.scrollController.offset - 70,
                  //       duration: new Duration(milliseconds: 500),
                  //       curve: Curves.easeOut);
                  // }
                  return ScrolledToEndTips(
                    hasContent: snapshot.data,
                    scrollController: widget.scrollController,
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: snapshot.data ? 1.0 : 0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  void _onProductDeleting(ApparelProductModel product) {
    ShowDialogUtil.showAlertDialog(context, '是否要删除产品', () async {
      await ProductRepositoryImpl().delete(product.code);
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('删除产品成功'),
        duration: Duration(
          seconds: 2,
        ),
      ));
      if(widget.isSelection){
        ApparelProductBLoC.instance.getSelectData(widget.keyword,status: widget.status);
      }else{
        ApparelProductBLoC.instance.deleteSearchProductResetData(widget.status,product.code);
      }
    });
  }

  void _onProductUpdating(ApparelProductModel product) {
    ProductRepositoryImpl().detail(product.code).then((product) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BLoCProvider(
                bloc: ApparelProductBLoC.instance,
                child: UserBLoC.instance.currentUser.type == UserType.FACTORY ? ApparelProductDetailPage(
                  item: product,
                  status: widget.status,
                ): ApparelProductBrandDetailPage(
                  item: product,
                ),
              ),
        ),
      );
    });
  }

  void _onProudctProduction(ApparelProductModel product) {
    RequirementOrderModel orderModel =
    RequirementOrderModel(details: RequirementInfoModel(), attachments: []);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequirementOrderFrom(
                  product: product,
                  isCreate: true,
                  order: orderModel,
                )));
  }

  void _onProductShlefing(ApparelProductModel product) {
    if (product.approvalStatus == ArticleApprovalStatus.approved) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().off(product.code),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((value) {
        bool result = false;
        if (value != null && value != '') {
          result = false;
        } else {
          result = true;
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '下架成功',
                failTips: '下架失败',
                callbackResult: result,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
        if(widget.isSelection){
          ApparelProductBLoC.instance.getSelectData(widget.keyword,status: widget.status);
        }else{
          ApparelProductBLoC.instance.getSearchData(widget.keyword,status: widget.status);
        }
      });
    } else if (product.approvalStatus == ArticleApprovalStatus.unapproved) {
      if (product.variants == null || product.variants.isEmpty) {
        _showValidateMsg(context, '颜色尺码为空不可上架');
        return;
      }

      if (UserBLoC.instance.currentUser.type == UserType.BRAND &&
          product.price == null) {
        _showValidateMsg(context, '产品价格为空不可上架');
        return;
      } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY ){
        if(product.basicProduction == null || product.productionIncrement == null || product.productionDays == null) {
          _showValidateMsg(context, '价格设置资料未完善，不可上架');
          return;
        }else{
          bool b = false;
          if(product.steppedPrices == null || product.steppedPrices.isEmpty){
            print('${product.steppedPrices}-------');
            b = true;
          }else{
            print('${product.steppedPrices}======');
            for (var stepped in product.steppedPrices) {
              if(stepped.minimumQuantity == null || stepped.price == null){
                b = true;
                return;
              }
            }
          }

          if(b){
            _showValidateMsg(context, '价格设置资料未完善，不可上架');
            return;
          }

        }
      }

      if(product.productType != null && (product.productType.contains(ProductType.SPOT_GOODS) || product.productType.contains(ProductType.TAIL_GOODS))){
        product.steppedPrices.sort((a,b) => a.minimumQuantity.compareTo(b.minimumQuantity));
        if(_colorTotalNum(product.colorSizes) < product.steppedPrices[0].minimumQuantity){
          _showValidateMsg(context, '库存总数量小于最小起订量，不可上架');
          return;
        }
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductRepositoryImpl().on(product.code),
              outsideDismiss: false,
              loadingText: '正在保存。。。',
              entrance: '',
            );
          }).then((value) {
            print('value${value}');
        bool result = false;
        if (value != null && value != '') {
          result = false;
        } else {
          result = true;
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '上架成功',
                failTips: '上架失败',
                callbackResult: result,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
            if(widget.isSelection){
              ApparelProductBLoC.instance.getSelectData(widget.keyword,status: widget.status);
            }else{
              ApparelProductBLoC.instance.getSearchData(widget.keyword,status: widget.status);
            }
      });
    }
  }

  //非空提示
  bool _showValidateMsg(BuildContext context, String message) {
    _validateMessage(context, '${message}');
    return false;
  }

  Future<void> _validateMessage(BuildContext context, String message) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            outsideDismiss: true,
          );
        });
  }

  int _colorTotalNum(List<ColorSizeModel> colorSizes) {
    int result = 0;
    colorSizes?.forEach((colorSize) {
      colorSize.sizes.forEach((size){
        result += size.quality ?? 0;
      });
    });
    return result;
  }
}

//class _ToTopBtn extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final bloc = ProductBlocProvider.of(context);
//
//    return StreamBuilder<bool>(
//        stream: bloc.toTopBtnStream,
//        initialData: false,
//        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//          return snapshot.data
//              ? FloatingActionButton(
//                  child: Icon(
//                    Icons.arrow_upward,
//                    color: Colors.white,
//                  ),
//                  onPressed: () {
//                    bloc.returnToTop();
//                  },
//                  backgroundColor: Colors.blue,
//                )
//              : Container();
//        });
//  }
//}
