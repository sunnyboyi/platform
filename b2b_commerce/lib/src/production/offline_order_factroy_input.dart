import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';


class OfflineOrderFactroyInput extends StatefulWidget{
  _OfflineOrderFactroyInputState createState() => _OfflineOrderFactroyInputState();
}

class _OfflineOrderFactroyInputState extends State<OfflineOrderFactroyInput>{
  FocusNode _factoryFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _factoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String factory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('输入生产信息'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 149, 22, 1)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    //带值返回上一页
                    Navigator.of(context).pop(factory);
                  }
              )
            ]
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildFactoryInfo(context),
              ],
            ))
    );
  }

  Widget _buildFactoryInfo(BuildContext context){
    TextEditingController inputNumber = TextEditingController();
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _factoryFocusNode,
              controller: _factoryController,
              autofocus:true,
              leadingText: '工厂名称',
              hintText: '请输入工厂名称',
                  onChanged: (value){
                    factory = value;
                  },
            ),
//            decoration: new BoxDecoration(
//              border: new Border.all(width: 1.0, color: Colors.black26),
//              borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
//            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _nameFocusNode,
              controller: _nameController,
              leadingText: '联系人名',
              hintText: '请输入联系人名',
//                  onChanged: (value){
//                    widget.item.name = value;
//                  },
            ),
//            decoration: new BoxDecoration(
//              border: new Border.all(width: 1.0, color: Colors.black26),
//              borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
//            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _phoneFocusNode,
              controller: _phoneController,
              leadingText: '联系电话',
              hintText: '请输入联系电话',
              inputType: TextInputType.phone,
//                  onChanged: (value){
//                    widget.item.name = value;
//                  },
            ),
//            decoration: new BoxDecoration(
//              border: new Border.all(width: 1.0, color: Colors.black26),
//              borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
//            ),
          ),
        ],
      ),
    );
  }

}