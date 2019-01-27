import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';


final List<Map<CategoryModel, List<CategoryModel>>> _category = [
  {
    CategoryModel(code: 'C01', name: '男装'): [
      CategoryModel(code: 'C001', name: 'T恤'),
      CategoryModel(code: 'C002', name: '衬衫'),
      CategoryModel(code: 'C003', name: '卫衣'),
      CategoryModel(code: 'C004', name: '卫裤'),
      CategoryModel(code: 'C005', name: '卫裤'),
      CategoryModel(code: 'C006', name: '卫裤'),
      CategoryModel(code: 'C007', name: '卫裤'),
      CategoryModel(code: 'C008', name: '卫裤'),
      CategoryModel(code: 'C009', name: '羽绒服'),
      CategoryModel(code: 'C010', name: '绒服地方'),
      CategoryModel(code: 'C011', name: '卫裤'),
      CategoryModel(code: 'C012', name: '卫裤'),
    ],
    CategoryModel(code: 'C02', name: '女装'): [
      CategoryModel(code: 'C013', name: '棉服服'),
      CategoryModel(code: 'C014', name: '羽绒服地方'),
      CategoryModel(code: 'C015', name: '背带裤'),
      CategoryModel(code: 'C016', name: '牛仔裤'),
      CategoryModel(code: 'C017', name: '牛仔裤'),
      CategoryModel(code: 'C018', name: '牛仔裤'),
      CategoryModel(code: 'C019', name: '牛仔裤'),
      CategoryModel(code: 'C020', name: '牛仔裤'),
      CategoryModel(code: 'C021', name: '牛仔裤'),
      CategoryModel(code: 'C022', name: '牛仔裤裤'),
      CategoryModel(code: 'C023', name: '牛仔裤'),
      CategoryModel(code: 'C024', name: '牛仔裤'),
    ],
  },
];

final List<Map<CategoryModel, List<CategoryModel>>> _majorCategory = [
  {
    CategoryModel(code: 'C1', name: '大类'): [
      CategoryModel(code: 'C2', name: '针织'),
      CategoryModel(code: 'C2', name: '针织'),
      CategoryModel(code: 'C2', name: '针织'),
    ]
  },
];

class ScreenConditions extends StatefulWidget {
  _ScreenConditionsState createState() => _ScreenConditionsState();
}

class _ScreenConditionsState extends State<ScreenConditions> {
  List<CategoryModel> _mojarSelected = [];
  List<CategoryModel> _categorySelected = [];
  String mojar = '点击选取';
  String category = '点击选取';
  bool _isShowA = false;
  bool _isShowB = false;
  bool _isShowC = false;
  bool _isShowD = false;
  String requestCount = '输入';
  TextEditingController inputNumber;
  bool _isShowMore = true;

  @override
  void initState() {
    _isShowA = false;
    _isShowB = false;
    _isShowC = false;
    _isShowD = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('要生产什么'),
        ),
        body: Container(
            child: ListView(
              children: <Widget>[
                _buildBody(context),
                _buildHideBody(context),
                _buildCommitButton(context),
              ],
            )
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            _buildTips(context),
            _buildMajor(context),
            _buildCategory(context),
            _buildRequestCount(context),
            _buildAddress(context),
            _buildHideTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHideBody(BuildContext context) {
    return Offstage(
        offstage: _isShowMore,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                _buildScreenFactory(context),
                _buildCooperationModes(context),
                _buildTechnology(context),
              ],
            ),
          ),
        ));
  }

  Widget _buildTips(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        "描述需求可以帮您更快速的找到合适的工厂",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMajor(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListTile(
            leading: Text(
              "大类",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Container(
                width: 150,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      mojar,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis
                  ),
                )
            )
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: () {
          _showMajorCategorySelect();
        });
  }

  Widget _buildCategory(BuildContext context) {
    return GestureDetector(
        child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ListTile(
              leading: Text(
                "小类",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                width: 150,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis
                  ),
                )
              )
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(16),
            )
        ),
        onTap: () {
          _showCategorySelect();
        });
  }

  Widget _buildRequestCount(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListTile(
            leading: Text(
              "需求数量",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              requestCount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: () {
          _neverSatisfied(context);
        });
  }

  Widget _buildAddress(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20,10,20,10),
      child: ListTile(
        leading: Text(
          "生产地区",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          "点击选取",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildHideTips(BuildContext context){
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(""),
                  ),
                  Text(
                    "更多条件",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  Icon(
                    _isShowMore?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                    color: Colors.orangeAccent,
                    size: 28,
                  ),
                ],
              )
          ),
        ),
        onTap: () {
          setState(() {
            _isShowMore = !_isShowMore;
          });
        });
  }


  Widget _buildScreenFactory(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20,10,20,10),
      height:90,
      child: GridView.count(
        childAspectRatio: 10 / 2.5,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: <Widget>[
          CheckboxListTile(
            title: Text('品牌工厂'),
            value: _isShowA,
            onChanged: (T) {
              setState(() {
                _isShowA = !_isShowA;
              });
            },
          ),
          CheckboxListTile(
            title: Text('担保交易'),
            value: _isShowB,
            onChanged: (T) {
              setState(() {
                _isShowB = !_isShowB;
              });
            },
          ),
          CheckboxListTile(
            title: Text('免费打样'),
            value: _isShowC,
            onChanged: (T) {
              setState(() {
                _isShowC = !_isShowC;
              });
            },
          ),
          CheckboxListTile(
            title: Text('认证工厂'),
            value: _isShowD,
            onChanged: (T) {
              setState(() {
                _isShowD = !_isShowD;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCooperationModes(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20,10,20,10),
      child: ListTile(
        leading: Text(
          "加工类型",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          "点击选取",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildTechnology(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20,10,20,10),
      child: ListTile(
        leading: Text(
          "工艺",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          "点击选取",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildCommitButton(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: RaisedButton(
          color: Colors.orange,
          child: Text(
            '确定',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          onPressed: () {
          },
        )
    );
  }



  void _showMajorCategorySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: CategorySelect(
            categorys: _majorCategory,
            multiple: true,
            verticalDividerOpacity: 1,
            categorySelect: _mojarSelected,
          ),
        );
      },
    ).then((val){
      mojar = '';
      if(_mojarSelected.isNotEmpty){
        for(int i=0;i<_mojarSelected.length;i++){
          mojar += _mojarSelected[i].name + ',';
        }
      }
      setState(() {
        mojar = mojar;
      });
    });


  }

  void _showCategorySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: CategorySelect(
            categorys: _category,
            multiple: true,
            verticalDividerOpacity: 1,
            categorySelect: _categorySelected,
          ),
        );
      },
    ).then((val){
      category = '';
      if(_categorySelected.isNotEmpty){
        for(int i=0;i<_categorySelected.length;i++){
          category += _categorySelected[i].name + ',';
        }
      }
      setState(() {
        category = category;
      });
    });
  }

  Future<void> _neverSatisfied(BuildContext context) async {
    inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller:inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if(inputNumber.text != null){
                  print(inputNumber.text);
                  setState(() {
                    requestCount = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}