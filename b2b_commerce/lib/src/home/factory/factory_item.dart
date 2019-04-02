import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../_shared/widgets/image_factory.dart';
import '../../my/my_factory.dart';

class FactoryItem extends StatelessWidget {
  const FactoryItem({
    Key key,
    @required this.model,
    this.showButton = false,
    this.hasInvited = false,
  }) : super(key: key);

  final FactoryModel model;

  ///是否显示按钮
  final bool showButton;

  ///是否已经邀请
  final bool hasInvited;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 获取该工厂的现款商品
        ProductsResponse productsResponse = await ProductRepositoryImpl().getProductsOfFactories({
          'factory': model.uid,
        }, {
          'size': 3
        });

        // TODO 工厂跳转
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyFactoryPage(
                  model,
                  isFactoryDetail: true,
                  products: productsResponse.content,
                ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  FactoryNameText(model: model),
                  showButton ? InviteFactoryButton() : Container(),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    ImageFactory.buildThumbnailImage(model.profilePicture),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PopulationScaleText(model: model),
                            CertifiedTagsAndLabelsText(model: model),
                            StarLevelAndOrdersCountText(model: model),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CategoriesText(
                    model: model,
                  )
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300], width: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class FactoryNameText extends StatelessWidget {
  FactoryNameText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text('${model.name}', style: TextStyle(fontSize: 18)),
    );
  }
}

class PopulationScaleText extends StatelessWidget {
  PopulationScaleText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${PopulationScaleLocalizedMap[model.populationScale] ?? ''}',
      style: TextStyle(
        color: Color.fromRGBO(180, 180, 180, 1),
      ),
    );
  }
}

class CertifiedTagsAndLabelsText extends StatelessWidget {
  CertifiedTagsAndLabelsText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  bool _isApproved() {
    return model.approvalStatus == ArticleApprovalStatus.approved;
  }

  List<Widget> _buildTags() {
    List<Widget> tags = [
      _isApproved()
          ? Tag(
              label: '  已认证  ',
              backgroundColor: Color.fromRGBO(254, 252, 235, 1),
            )
          : Tag(
              label: '  未认证  ',
              color: Colors.black,
              backgroundColor: Colors.grey[300],
            )
    ];
    model.labels.forEach((label) {
      tags.add(Tag(
        label: label.name,
        color: Colors.grey,
      ));
    });

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: _buildTags(),
      ),
    );
  }
}

class StarLevelAndOrdersCountText extends StatelessWidget {
  StarLevelAndOrdersCountText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      // color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Stars(
              size: 14,
              color: Color.fromRGBO(255, 183, 0, 1),
              highlightOnly: false,
              starLevel: model.starLevel ?? 0,
            ),
          ),
          RichText(
            text: TextSpan(text: '已接', style: TextStyle(color: Colors.grey), children: <TextSpan>[
              TextSpan(
                text: '${model.historyOrdersCount}',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '单')
            ]),
          ),
        ],
      ),
    );
  }
}

class CategoriesText extends StatelessWidget {
  CategoriesText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  Widget _buildTag(int i) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Text(
        '${model.categories[i].name}',
        style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1)),
      ),
    );
  }

  Widget _buildTags() {
    // 取前3条
    List<Container> tags = <Container>[];
    if (model.categories != null) {
      // TODO: 用更好的方法实现：先截取，再生成
      if (model.categories.length > 6) {
        for (int i = 0; i < model.categories.length && i < 6; i++) {
          tags.add(_buildTag(i));
        }
      } else {
        for (int i = 0; i < model.categories.length; i++) {
          tags.add(_buildTag(i));
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: tags,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildTags(),
    );
  }
}

class InviteFactoryButton extends StatelessWidget {
  const InviteFactoryButton({Key key, this.hasInvited}) : super(key: key);

  final bool hasInvited;

  @override
  Widget build(BuildContext context) {
    if (hasInvited) {
      return Container(
        height: 23,
        width: 80,
        child: Center(
          child: Text(
            '已邀请',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(20)),
      );
    } else {
      return Container(
        height: 23,
        width: 80,
        margin: EdgeInsets.only(left: 20),
        child: FlatButton(
          onPressed: () {},
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '邀请报价',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }
}

class Tag extends StatelessWidget {
  const Tag({
    Key key,
    this.width = 32,
    this.height = 20,
    @required this.label,
    this.color = const Color.fromRGBO(244, 143, 177, 1.0),
    this.backgroundColor = const Color.fromRGBO(248, 187, 208, 0.3),
  }) : super(key: key);

  final double width;
  final double height;
  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 1, 4, 1),
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 14),
        ),
      ),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(2)),
    );
  }
}