import 'dart:convert';

import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_recommend.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 需求订单搜索页
class RequirementOrderSearchDelegatePage
    extends SearchDelegate<RequirementOrderModel> {
  List<String> history_keywords;

  final bool isRecommend;

  RequirementOrderSearchDelegatePage({this.isRecommend = false}) {
    getHistory();
  }

  //获取本地搜索历史记录
  void getHistory() async {
    //解析
    String jsonStr =
        await LocalStorage.get(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY);
    if (jsonStr != null && jsonStr != '') {
      List<dynamic> list = json.decode(jsonStr);
      history_keywords = list.map((item) => item as String).toList();
    } else {
      history_keywords = [];
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query != ''
          ? IconButton(
              icon: Icon(
                B2BIcons.del_blank_card,
                size: 15,
              ),
              onPressed: () {
                query = '';
              },
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  // @override
  void showResults(BuildContext context) {
    super.showResults(context);
    //记录搜索关键字
    if (query != '' && query.isNotEmpty) {
      history_keywords.add(query);
      LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
          json.encode(history_keywords));
    }

    _jumpToResult(context, query);
  }

  @override
  void showSuggestions(BuildContext context) {
    super.showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      body: Container(child: _buildHistoryListView(context)),
    );
  }

  Widget _buildHistoryListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Text(
            '历史搜索',
            style: TextStyle(
                color: Color.fromRGBO(100, 100, 100, 1), fontSize: 18),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 4.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: history_keywords
                  .map((keyword) => HistoryTag(
                        value: keyword,
                        onTap: () {
                          _jumpToResult(context, keyword);
                        },
                      ))
                  .toList()),
        )
      ],
    );
  }

  void _jumpToResult(BuildContext context, String keyword) async {
    await ProductRepositoryImpl().majorCategories().then((categories) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => isRecommend
              ? RequirementPoolRecommend(
                  categories: categories,
                  requirementFilterCondition: RequirementFilterCondition(
                      categories: [],
                      dateRange: RequirementOrderDateRange.ALL,
                      machiningType: null,
                      keyword: keyword),
                )
              : RequirementPoolAllPage(
                  categories: categories,
                  requirementFilterCondition: RequirementFilterCondition(
                      categories: [],
                      dateRange: RequirementOrderDateRange.ALL,
                      machiningType: null,
                      keyword: keyword),
                ),
        ),
      );
    });
  }
}
