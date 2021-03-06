import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 默认的Tab Bar
class TabFactory {
  static Widget buildDefaultTabBar(List<EnumModel> tabs,
      {bool scrollable = false, TabController tabController}) {
    return TabBar(
      unselectedLabelColor: Colors.black26,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: tabs.map((tab) {
        return Tab(text: tab.name);
      }).toList(),
      labelStyle: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      isScrollable: scrollable,
      controller: tabController,
    );
  }
}
