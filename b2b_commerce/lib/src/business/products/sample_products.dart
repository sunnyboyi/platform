import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'sample_product_form.dart';
import 'sample_product_item.dart';

class SampleProductsPage extends StatelessWidget {
  bool isHistoryCreate;
  SampleProductModel model = SampleProductModel();

  SampleProductsPage({this.isHistoryCreate = false});

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = SampleProductBLoC.instance;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses();
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return BLoCProvider<SampleProductBLoC>(
      bloc: SampleProductBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('我的样衣'),
          elevation: 0.5,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SampleProductFormPage(
                        item: model,
                        isCreate: true,
                      ))),
          child: Icon(Icons.add),
        ),
        body: SampleProductList(
          isHistoryCreate: isHistoryCreate,
        ),
      ),
    );
  }
}

class SampleProductList extends StatelessWidget {
  bool isHistoryCreate;
  SampleProductList({this.isHistoryCreate = false});
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<SampleProductBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses();
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
//        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.filterByStatuses();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<SampleProductModel>>(
                stream: bloc.stream,
                // initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<SampleProductModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterByStatuses();
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((product) {
                        return SampleProductItem(
                          item: product,
                          isDetail: true,
                          isHistoryCreate: isHistoryCreate,
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
                  //   _scrollController.animateTo(_scrollController.offset - 70,
                  //       duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  // }
                  return ScrolledToEndTips(
                    hasContent: snapshot.data,
                    scrollController: _scrollController,
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ProgressIndicatorFactory
                      .buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0,
                  );
                },
              ),
            ],
          ),
        ));
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
