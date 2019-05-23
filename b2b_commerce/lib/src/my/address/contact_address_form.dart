import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/my/address/amap_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'region_select.dart';

class ContactAddressFormPage extends StatefulWidget {
  ContactAddressFormPage({this.address, this.company});

  final AddressModel address;

  final B2BUnitModel company;

  @override
  ContactAddressFormPageState createState() => ContactAddressFormPageState();
}

class ContactAddressFormPageState extends State<ContactAddressFormPage> {
  TextEditingController _line1Controller;
  FocusNode _line1FocusNode = FocusNode();
  String regionCityAndDistrict;

  List<Widget> tipsWidget;

  @override
  void initState() {
    super.initState();
    _line1Controller = TextEditingController(text: widget.address?.line1);
    tipsWidget = [];
    if (widget.address != null &&
        widget.address.region != null &&
        widget.address.city != null &&
        widget.address.cityDistrict != null) {
      regionCityAndDistrict = widget.address.region.name +
          widget.address.city.name +
          widget.address.cityDistrict.name;
    } else {
      regionCityAndDistrict = '';
    }
  }

  _selectRegionCityAndDistrict(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegionSelectPage(RegionRepositoryImpl()),
      ),
    ) as DistrictModel;

    if (result == null) {
      return;
    }

    widget.address.cityDistrict = result;
    widget.address.city = result.city;
    widget.address.region = result.city.region;

    regionCityAndDistrict = widget.address.region.name +
        widget.address.city.name +
        widget.address.cityDistrict.name;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[
      B2BListTitle(
        isRequired: true,
        onTap: () {
          _selectRegionCityAndDistrict(context);
        },
        prefix: Text(
          '选择省市区',
          style: TextStyle(fontSize: 16),
        ),
        suffix: Text(
          regionCityAndDistrict,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      B2BListTitle(
        isRequired: true,
        onTap: onLocation,
        prefix: Text(
          '选择定位',
          style: TextStyle(fontSize: 16),
        ),
        suffix: Text(
          '${widget.company.longitude},${widget.company.latitude}',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      TextFieldComponent(
        focusNode: _line1FocusNode,
        controller: _line1Controller,
        leadingText: Text('详细地址',
            style: TextStyle(
              fontSize: 16,
            )),
        hintText: '道路、门牌号、小区、楼栋号、单元室等',
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        dividerPadding: EdgeInsets.symmetric(),
      ),
      Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                '定位工厂坐标后，品牌可以通过"就近找厂"快速找到您的工厂',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text("编辑地址"),
          actions: <Widget>[
            IconButton(
              icon: Text(
                '确定',
                style: TextStyle(),
              ),
              onPressed: () async {
                widget.address.line1 = _line1Controller.text;
                Navigator.of(context).pop(widget.address);
              },
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: widgets,
          ),
        ));
  }

  void onLocation() async {
    Tip tip =
        await showSearch(context: context, delegate: AmapSearchDelegatePage());
    setState(() {
      List<String> locationArray = tip.location.split(',');
      widget.company.longitude = double.parse(locationArray[0]);
      widget.company.latitude = double.parse(locationArray[1]);
      widget.company.localAddress = tip.address;
    });
  }

  // void onAmapTip(String keyword) async {
  //   AmapResponse amapResponse = await AmapService.instance.inputtips(keyword);
  //   setState(() {
  //     tipsWidget = amapResponse.tips
  //         .map((tip) => TipRow(
  //               name: tip.name,
  //               address: tip.address,
  //               location: tip.location,
  //             ))
  //         .toList();
  //   });
  // }

  void getGpsLocation() async {
    AMapLocation location = await AmapService.instance.location();
    if (location == null) {
      showDialog(
          context: context,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.CONFIRM_DIALOG,
              contentText1: '获取位置授权失败，请设置应用位置服务',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }
}

class TipRow extends StatelessWidget {
  final String name;

  final String address;

  final String location;

  const TipRow({Key key, this.name, this.address, this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          width: double.infinity,
          // height: 80,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${name}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      '${address}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(
                B2BIcons.arrow_left_bottom,
                color: Colors.grey,
              )
            ],
          )),
    );
  }
}
