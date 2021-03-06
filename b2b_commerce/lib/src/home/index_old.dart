import 'dart:async';

import 'package:b2b_commerce/src/_shared/users/brand_index_search_delegate_page.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/shares.dart';
import '../_shared/widgets/broadcast_factory.dart';
import '../common/app_image.dart';
import '../common/app_keys.dart';
import '../home/factory/industrial_cluster_factory.dart';
import '../home/pool/requirement_pool_all.dart';
import '../home/pool/requirement_pool_recommend.dart';
import '../home/requirement/fast_publish_requirement.dart';
import '../production/production_offline_order_from.dart';
import '../production/production_unique_code.dart';
import '_shared/widgets/notifications.dart';
import 'factory/factory_page.dart';

/// 网站主页
class HomePage extends StatefulWidget {
  HomePage({Key key, this.userType}) : super(key: AppKeys.homePage);

  final UserType userType;

  final Map<UserType, List<Widget>> widgets = <UserType, List<Widget>>{
    UserType.BRAND: <Widget>[
      BrandFirstMenuSection(),
      BrandSecondMenuSection(),
      FastPublishRequirement(),
      BroadcastSection(),
      BrandTrackingProgressSection(),
      // DividerFactory.buildDivider(40),
    ],
    UserType.FACTORY: <Widget>[
      FactoryRequirementPoolSection(),
      BroadcastSection(),
      FactoryCollaborationSection(),
    ]
  };

  final Map<UserType, Widget> searchInputWidgets = <UserType, Widget>{
    UserType.BRAND: GlobalSearchInput<String>(
      tips: ' 找工厂、找款式...',
      delegate: BrandIndexSearchDelegatePage(),
    ),
    UserType.FACTORY: GlobalSearchInput<RequirementOrderModel>(
      tips: ' 找需求...',
      delegate: RequirementOrderSearchDelegatePage(),
    ),
  };

  get widgetsByUserType => widgets[userType];

  get searchInputWidgetsByUserType => searchInputWidgets[userType];

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey homePageKey = GlobalKey();

  _HomePageState();

  @override
  void initState() {
    MessageBLoC.instance.snackMessageStream.listen((value) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('$value'),
      ));
    });
    // ns$.init(context);

    ///获取未读消息数
    notificationsPool$.checkUnread();
    // 安卓端自动更新
    // TargetPlatform platform = defaultTargetPlatform;
    // if (platform != TargetPlatform.iOS) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => AppVersion(
    //         homePageKey.currentContext,
    //         ignoreVersionNotification:
    //             UserBLoC.instance.ignoreVersionNotification)
    //     .initCheckVersion(AppBLoC.instance.packageInfo.version, 'nbyjy'));
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    ///极光初始化
    jpush$.setContext(context);

    return Scaffold(
      key: homePageKey,
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 188.0,
              pinned: true,
              elevation: 0.5,
              title: HomeTitle(
                leading: widget.searchInputWidgetsByUserType,
              ),
              brightness: Brightness.dark,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    UserBLoC.instance.currentUser.type == UserType.BRAND
                        ? HomeBrandBannerSection()
                        : HomeFactoryBannerSection(),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(widget.widgetsByUserType)),
          ],
        ),
      ),
    );
  }
}

class HomeTitle extends StatelessWidget {
  final Widget leading;

  const HomeTitle({Key key, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: leading,
          ),
          NotificationsIcon()
        ],
      ),
    );
  }
}

/// 首页Banner
class HomeBrandBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      url:
          'http://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E5%93%81%E7%89%8C%E8%BD%AE%E6%92%AD%E5%9B%BE1.png',
    ),
    MediaModel(
      url:
          'http://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E5%93%81%E7%89%8C%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Carousel(items, 240);
  }
}

class HomeFactoryBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      url:
          'http://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E5%B7%A5%E5%8E%82%E8%BD%AE%E6%92%AD%E5%9B%BE1.png',
    ),
    MediaModel(
      url:
          'http://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E5%B7%A5%E5%8E%82%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Carousel(items, 240);
  }
}

/// 品牌 - 首页Tab部分1
class BrandFirstMenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> items = <GridItem>[
      GridItem(
          title: '快反工厂',
          onPressed: () async {
            _jumpToFastFactory(context);
          },
          icon: B2BImage.fastFactory(width: 60, height: 80)),
      GridItem(
          title: '看款下单',
          onPressed: () async {
//            showDialog(
//                context: context,
//                barrierDismissible: false,
//                builder: (_) {
//                  return RequestDataLoading(
//                    requestCallBack: ProductRepositoryImpl()
//                        .cascadedCategories(),
//                    outsideDismiss: false,
//                    loadingText: '加载中。。。',
//                    entrance: '',
//                  );
//                }
//            ).then((value){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductsPage(),
              ),
            );
//            });
          },
          icon: B2BImage.order(width: 60, height: 80)),
    ];

    return EasyGrid(items: items);
  }

  void _jumpToFastFactory(BuildContext context) async {
    List<CategoryModel> categories =
        await ProductRepositoryImpl().majorCategories();
    List<LabelModel> labels = await UserRepositoryImpl().labels();
    List<LabelModel> conditionLabels =
        labels.where((label) => label.name == '快反工厂').toList();
    labels = labels
        .where((label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
        .toList();
    labels.add(LabelModel(name: '已认证', id: 000000));
    if (categories != null && labels != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FactoryPage(
            FactoryCondition(
                starLevel: 0,
                adeptAtCategories: [],
                labels: conditionLabels,
                cooperationModes: []),
            route: '快反工厂',
            categories: categories,
            labels: labels,
          ),
        ),
      );
    }
  }
}

/// 品牌 - 首页Tab部分2
class BrandSecondMenuSection extends StatelessWidget {
  const BrandSecondMenuSection({Key key}) : super(key: key);

  Widget _buildFindFactoriesByMapMenuItem(BuildContext context) {
    return AdvanceIconButton(
      onPressed: () async {
        List<CategoryModel> categories =
            await ProductRepositoryImpl().majorCategories();
        List<LabelModel> labels = await UserRepositoryImpl().labels();
        labels = labels
            .where((label) =>
                label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
//        labels.add(LabelModel(name: '已认证', id: 1000000));
        if (categories != null && labels != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FactoryPage(
                FactoryCondition(
                    starLevel: 0,
                    adeptAtCategories: [],
                    labels: [],
                    cooperationModes: []),
                route: '就近找厂',
                categories: categories,
                labels: labels,
              ),
            ),
          );
        }
      },
      title: '就近找厂',
      isHot: true,
      icon: Icon(
        B2BIcons.factory_map,
        color: Color.fromRGBO(97, 164, 251, 1.0),
        size: 30,
      ),
    );
  }

  Widget _buildFindFactoriesByIndustrialClusterMenuItem(BuildContext context) {
    return AdvanceIconButton(
      onPressed: () async {
        List<LabelModel> labels =
            await UserRepositoryImpl().industrialClustersFromLabels();
        List<LabelModel> factoryLabels = await UserRepositoryImpl().labels();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndustrialClusterPage(
              labels: labels,
              factoryLabels: factoryLabels,
            ),
          ),
        );
      },
      title: '产业集群',
      icon: Icon(
        B2BIcons.industrial_cluster,
        color: Color.fromRGBO(105, 210, 217, 1),
        size: 30,
      ),
    );
  }

  Widget _buildBrandedFactoriesMenuItem(BuildContext context) {
    return AdvanceIconButton(
      onPressed: () {
        _jumpToQualityFactory(context);
      },
      title: '优选工厂',
      icon: Icon(
        B2BIcons.factory_brand,
        color: Color.fromRGBO(105, 224, 139, 1),
        size: 30,
      ),
    );
  }

  Widget _buildAllFactoriesMenuItem(BuildContext context) {
    return AdvanceIconButton(
      onPressed: () async {
        List<CategoryModel> categories =
            await ProductRepositoryImpl().majorCategories();
        List<LabelModel> labels = await UserRepositoryImpl().labels();
        labels = labels
            .where((label) =>
                label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
//        labels.add(LabelModel(name: '已认证', id: 1000000));
        if (categories != null && labels != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FactoryPage(
                FactoryCondition(
                    starLevel: 0,
                    adeptAtCategories: [],
                    labels: [],
                    cooperationModes: []),
                route: '全部工厂',
                categories: categories,
                labels: labels,
              ),
            ),
          );
        }
      },
      title: '全部工厂',
      icon: Icon(
        B2BIcons.factory_all,
        color: Color.fromRGBO(148, 161, 246, 1.0),
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildFindFactoriesByMapMenuItem(context),
            _buildFindFactoriesByIndustrialClusterMenuItem(context),
            _buildBrandedFactoriesMenuItem(context),
            _buildAllFactoriesMenuItem(context),
          ],
        ),
      ),
    );
  }

  void _jumpToQualityFactory(BuildContext context) async {
    List<CategoryModel> categories =
        await ProductRepositoryImpl().majorCategories();
    List<LabelModel> labels = await UserRepositoryImpl().labels();
    List<LabelModel> conditionLabels =
        labels.where((label) => label.name == '优选工厂').toList();
    labels = labels
        .where((label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
        .toList();
    labels.add(LabelModel(name: '已认证', id: 1000000));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FactoryPage(
          FactoryCondition(
              starLevel: 0,
              adeptAtCategories: [],
              labels: conditionLabels,
              cooperationModes: []),
          route: '优选工厂',
          categories: categories,
          labels: labels,
        ),
      ),
    );
  }
}

/// 广播部分
class BroadcastSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BroadcastFactory.buildBroadcast('进入钉单请优先注册并提交认证资料');
  }
}

/// 跟踪进度版块
class BrandTrackingProgressSection extends StatelessWidget {
  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '跟踪进度',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(100, 100, 100, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '线下订单',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromRGBO(150, 150, 150, 1),
          ),
        )
      ],
    );
  }

  Widget _buildUniqueCode(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductionUniqueCodePage(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(232, 232, 232, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: <Widget>[
            Text(
              '请输入工厂发来的唯一码',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoUniqueCode(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '没有唯一码？',
            style:
                TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 15),
          ),
          Container(
            height: 25,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color.fromRGBO(255, 214, 12, 1),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductionOfflineOrder()));
              },
              child: Text(
                '去创建',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        children: <Widget>[
          _buildTitle(),
          _buildUniqueCode(context),
          _buildNoUniqueCode(context),
        ],
      ),
    );
  }
}

class FactoryRequirementPoolSection extends StatefulWidget {
  _FactoryRequirementPoolSection createState() =>
      _FactoryRequirementPoolSection();
}

class _FactoryRequirementPoolSection
    extends State<FactoryRequirementPoolSection> {
  int requirementAll = 0;
  bool hasGetRequirementAll = false;
  int requirementRecommend = 0;
  final StreamController _reportsStreamController =
      StreamController<Reports>.broadcast();

  void queryReports() async {
    Reports response = await ReportsRepository().reportRequirementCount();
    if (response != null) {
      _reportsStreamController.add(response);
      requirementAll = response.ordersCount8;
      requirementRecommend = response.ordersCount9;
    }
  }

  void getAllRequirementCount() async {
    int count = await ReportsRepository().offlineRequirementCount();
    if (count != null) {
      setState(() {
        requirementAll = count;
        hasGetRequirementAll = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);
    if (bloc.currentUser.status != UserStatus.OFFLINE) {
      queryReports();
    } else if (bloc.currentUser.status == UserStatus.OFFLINE &&
        requirementAll == 0 &&
        !hasGetRequirementAll) {
      getAllRequirementCount();
    }
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StreamBuilder<Reports>(
            stream: _reportsStreamController.stream,
            initialData: Reports(),
            builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
              return GestureDetector(
                onTap: () async {
                  await ProductRepositoryImpl()
                      .majorCategories()
                      .then((categories) {
                    if (categories != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              RequirementPoolAllPage(categories: categories),
                        ),
                      );
                    }
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: AllRequirementMenuItem(count: requirementAll),
                ),
              );
            },
          ),
          DividerFactory.buildVerticalSeparator(35),
          StreamBuilder<Reports>(
            stream: _reportsStreamController.stream,
            initialData: Reports(),
            builder: (BuildContext context, AsyncSnapshot<Reports> snapshot) {
              return GestureDetector(
                onTap: () async {
                  await ProductRepositoryImpl()
                      .majorCategories()
                      .then((categories) {
                    if (categories != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RequirementPoolRecommend(
                                categories: categories,
                              )));
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: Colors.white,
                  child: RecommendedRequirementMenuItem(
                      count: requirementRecommend),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AllRequirementMenuItem extends StatelessWidget {
  const AllRequirementMenuItem({Key key, @required this.count})
      : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '全部需求',
            style: TextStyle(
              color: Color.fromRGBO(36, 38, 41, 1),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          RichText(
            text: TextSpan(
              text: '$count +',
              style: TextStyle(
                color: Color.fromRGBO(255, 45, 45, 1),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '需求等待回复',
                  style: TextStyle(
                    color: Color.fromRGBO(100, 100, 100, 1),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecommendedRequirementMenuItem extends StatelessWidget {
  const RecommendedRequirementMenuItem({Key key, @required this.count})
      : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Text(
                  '推荐需求',
                  style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 38, 38, 1),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          RichText(
            text: TextSpan(
                text: '待我',
                style: TextStyle(
                  color: Color.fromRGBO(100, 100, 100, 1),
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '报价',
                      style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1))),
                  TextSpan(
                      text: '的需求',
                      style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)))
                ]),
          )
        ],
      ),
    );
  }
}

/// 协同管理
class FactoryCollaborationSection extends StatelessWidget {
  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '协同管理',
          style: TextStyle(
            color: Color.fromRGBO(100, 100, 100, 1),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        Text(
          '线下订单',
          style: TextStyle(
            color: Color.fromRGBO(150, 150, 150, 1),
          ),
        )
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FlatButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductionOfflineOrder(),
            ),
          );
        },
        child: Text(
          '创建线下订单',
          style: TextStyle(
              color: Color.fromRGBO(36, 38, 41, 1),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCreationTips() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '• 使用钉单APP统一管理生产订单;',
            style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
          ),
          Text(
            '• 创建后生成唯一码，邀请品牌线上查看生产进度;',
            style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
          )
        ],
      ),
    );
  }

  Widget _buildUniqueCodeInput(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductionUniqueCodePage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(232, 232, 232, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '请输入品牌发来的唯一码',
        ),
      ),
    );
  }

  Widget _buildInputTips() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '• 品牌已创建线下订单，直接通过唯一码导入;',
        style: TextStyle(
          color: Color.fromRGBO(150, 150, 150, 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: <Widget>[
          _buildTitle(),
          _buildCreateButton(context),
          _buildCreationTips(),
          DividerFactory.buildHorizontalSeparator(10, 20),
          _buildUniqueCodeInput(context),
          _buildInputTips(),
        ],
      ),
    );
  }
}
