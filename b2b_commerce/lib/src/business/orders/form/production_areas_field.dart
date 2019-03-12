import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionAreasField extends StatefulWidget {
  RequirementOrderModel item;

  ProductionAreasField(this.item);

  ProductionAreasFieldState createState() => ProductionAreasFieldState();
}

class ProductionAreasFieldState extends State<ProductionAreasField> {
  List<EnumModel> _productionAreasSelected = [];
  List<RegionModel> _regions = [];

  @override
  void initState() {
    RegionRepositoryImpl().list().then((regions)=>_regions.addAll(regions));

    // TODO: implement initState
    super.initState();
  }

  //格式选中的地区（多选）
  String formatAreaSelectsText(List<EnumModel> selects,int count) {
    String text = '';

    for (int i = 0; i < selects.length; i++) {
      if (i > count-1) {
        text += '...';
        break;
      }

      if (i == selects.length - 1) {
        text += selects[i].name;
      } else {
        text += selects[i].name + '、';
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '生产地区',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              widget.item.details?.productiveOrientations == null
                  ? '选取'
                  : formatAreaSelectsText(_productionAreasSelected, 2),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
//          CityPickers.showCityPicker(
//            context: context,
//            showType: ShowType.p,
//            theme: ThemeData(primaryColor: Colors.orange),
//          ).then((result) {
//            print(result);
//          });
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                child: EnumSelection(
                  enumModels: _regions.map((region)=>EnumModel(region.isocode, region.name)).toList(),
                  multiple: true,
                  enumSelect: _productionAreasSelected,
                  hasButton: true,
                ),
              );
            },
          ).then((val) {
            setState(() {
              if (_productionAreasSelected.length > 0) {
                widget.item.details.productiveOrientations =
                    _productionAreasSelected.map((area) => RegionModel(isocode: area.code,name: area.name)).toList();
              } else {
                widget.item.details.productiveOrientations = null;
              }
            });
          });
        });
  }
}
