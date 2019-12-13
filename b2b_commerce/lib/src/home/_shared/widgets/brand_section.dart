import 'package:b2b_commerce/src/business/orders/requirement/requirement_order_first_form.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 品牌 - 首页Tab部分1
class BrandFirstMenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> items = <GridItem>[
      GridItem(
        title: '发布需求',
        onPressed: () async {
          RequirementOrderModel requirementOrderModel = RequirementOrderModel(
              details: RequirementInfoModel(), attachments: []);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        builder: (_) => RequirementOrderFormState(),
                      ),
                    ],
                    child: Consumer(
                      builder: (context, RequirementOrderFormState state, _) =>
                          RequirementOrderFirstForm(
                            formState: state,
                          ),
                    ),
                  ),
            ),
          );
        },
      ),
      GridItem(
        title: '推荐工厂',
        onPressed: () async {
          List<CategoryModel> categories =
          await ProductRepositoryImpl().majorCategories();
          List<LabelModel> labels = await UserRepositoryImpl().labels();
          labels = labels
              .where((label) =>
          label.group == 'FACTORY' || label.group == 'PLATFORM')
              .toList();
          if (categories != null && labels != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FactoryPage(
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
      ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: Colors.white,
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildProductionFactory(context),
                  _buildFreeCapacity(context),
                  _buildProductOrdering(context),
                  _buildNearbyFactory(context)
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildQualityFactory(context),
                  _buildContractManage(context),
                  _buildOrderCoordination(context),
                  _builRequirement(context)
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildProductionFactory(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.productionFactory(),
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
              builder: (context) =>
                  FactoryPage(
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
      title: '生产找厂',
    );
  }

  Widget _buildFreeCapacity(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.freeCapacity(),
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.ROUTE_CAPACITY_MATCHING);
      },
      title: '空闲产能',
    );
  }

  Widget _buildProductOrdering(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.productOrdering(),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductsPage(),
          ),
        );
      },
      title: '看款下单',
    );
  }

  Widget _buildNearbyFactory(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.nearbyFactory(),
      onPressed: () async {
        List<CategoryModel> categories =
        await ProductRepositoryImpl().majorCategories();
        List<LabelModel> labels = await UserRepositoryImpl().labels();
        labels = labels
            .where((label) =>
        label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
        if (categories != null && labels != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FactoryPage(
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
    );
  }

  Widget _buildQualityFactory(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.qualityFactory(),
      onPressed: () async {
        List<CategoryModel> categories =
        await ProductRepositoryImpl().majorCategories();
        List<LabelModel> labels = await UserRepositoryImpl().labels();
        List<LabelModel> conditionLabels =
        labels.where((label) => label.name == '优选工厂').toList();
        labels = labels
            .where((label) =>
        label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
        labels.add(LabelModel(name: '已认证', id: 1000000));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                FactoryPage(
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
      },
      title: '优选工厂',
    );
  }

  Widget _buildContractManage(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.contractManage(),
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.ROUTE_MY_CONTRACT);
      },
      title: '合同管理',
      number: 2,
      showNum: true,
    );
  }

  Widget _buildOrderCoordination(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.orderCoordination(),
      onPressed: () {},
      title: '订单协同',
    );
  }

  Widget _builRequirement(BuildContext context) {
    return ImageNumButton(
      width: 55,
      height: 80,
      image: B2BImage.requirement(),
      onPressed: () {},
      title: '我的需求',
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

class BrandReportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '衣报送',
            style: TextStyle(
                color: Constants.THEME_COLOR_MAIN, fontWeight: FontWeight.bold),
          ),
          Text('接单工厂 556'),
          Text('正在报价 216'),
          Text('今日成交 12'),
        ],
      ),
    );
  }
}