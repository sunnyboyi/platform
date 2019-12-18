import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class RequirementTabSection extends StatefulWidget {
  @override
  _RequirementTabSectionState createState() => _RequirementTabSectionState();
}

class _RequirementTabSectionState extends State<RequirementTabSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 700,
        child: DefaultTabController(
            length: 2,
            child: ChangeNotifierProvider<RequirementTabSectionState>(
              builder: (context) => RequirementTabSectionState(),
              child: Scaffold(
                  appBar: TabBar(
                    tabs: [
                      Tab(
                        child: Text('最新需求'),
                      ),
                      Tab(
                        child: Text('附近需求'),
                      )
                    ],
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      NewRequirementsListView(),
                      NearbyRequirementsListView()
                    ],
                  )),
            )));
  }
}

class NewRequirementsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<RequirementTabSectionState, AmapState>(
      builder:
          (context, RequirementTabSectionState state, AmapState amapState, _) =>
          Container(
              child: Container(
                child: state.getNewRequirements(
                    amapState.longitude, amapState.latitude) !=
                    null &&
                    amapState.getAMapLocation() != null
            ? Column(
                  children: state
                      .getNewRequirements(
                      amapState.longitude, amapState.latitude)
                    .map((requirement) => _RequirementItem(
                          model: requirement,
                        ))
                    .toList(),
              )
                    : Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
              ),
      )),
    );
  }
}

class NearbyRequirementsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<RequirementTabSectionState, AmapState>(
      builder:
          (context, RequirementTabSectionState state, AmapState amapState, _) =>
          Container(
              child: Container(
                child: state.getNearbyRequirements(
                    amapState.longitude, amapState.latitude) !=
                    null &&
                    amapState.getAMapLocation() != null
            ? Column(
                  children: state
                      .getNearbyRequirements(
                      amapState.longitude, amapState.latitude)
                    .map((requirement) => _RequirementItem(
                          model: requirement,
                        ))
                    .toList(),
              )
                    : Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
              ),
      )),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final RequirementOrderModel model;

  final double height;

  const _RequirementItem({Key key, this.model, this.height = 120})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300], width: 0.6),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RequirementOrderDetailPage(model.code)));
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${model.details.productName ?? ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                        ),
                        Text('${DateExpress2Util.express(model.creationTime)}')
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Text('${model.details.category.name}'),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                '${model.details.expectedMachiningQuantity}件'),
                          )
                        ],
                      ),
                    ),
                    Text(model.belongTo.contactAddress.city != null
                        ? '${model.belongTo.contactAddress.city.name}${model.belongTo.contactAddress.cityDistrict.name}'
                        : '')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          ImageFactory.buildThumbnailImage(
                              model.belongTo.profilePicture,
                              size: 40,
                              containerSize: 50),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text('${model.belongTo.name}'),
                          )
                        ],
                      ),
                    ),
                    Text('${generateDistanceStr(model.distance)}')
                  ],
                )
              ],
            )),
      ),
    );
  }

  String generateDistanceStr(double distance) {
    if (distance < 1000) {
      return '${distance}KM';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)}KM';
    }
  }
}