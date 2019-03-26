import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionProgressesPage extends StatefulWidget{
  PurchaseOrderModel order;

  ProductionProgressesPage({Key key, @required this.order}) : super(key: key);

  _ProductionProgressesPageState createState() =>
      _ProductionProgressesPageState(order: order);
}

class _ProductionProgressesPageState extends State<ProductionProgressesPage> {
  DateTime _blDate;
  String _blNumber;
  TextEditingController dialogText;
  String userType;
  PurchaseOrderModel order;
  String phase;
  String remarks;

  _ProductionProgressesPageState({this.order});

  @override
  void initState() {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if(bloc.isBrandUser){
      userType = 'brand';
    }else{
      userType = 'factory';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text('生产进度明细'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Center(
              child: Text(
                '${ProductionProgressPhaseLocalizedMap[order.currentPhase]}',
                style: TextStyle(
                  color: Color(0xFFFFD600),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: _buildProgresses(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildProgresses(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: ListView(children: _buildPurchaseProductionProgresses(context)),
    );
  }

  List<Widget> _buildPurchaseProductionProgresses(BuildContext context) {
    List<Widget> _list = new List();
    int _index = 0;
    for(int i =0; i< order.progresses.length; i++){
      if (ProductionProgressPhaseLocalizedMap[order.progresses[i].phase] == ProductionProgressPhaseLocalizedMap[order.currentPhase]) {
        _index = order.progresses[i].sequence;
      }
    }
    for (int i = 0; i < order.progresses.length; i++) {
      _list.add(Container(
        child: _buildProductionProgress(context,
          order.progresses[i],
            ProductionProgressPhaseLocalizedMap[order.currentPhase],
            order.progresses[i].sequence,_index
        ),
      ));
    }
    return _list;
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index) {
    return Stack(
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(left: 30.0),
            child: _buildProgressTimeLine(context,progress,currentPhase,sequence,_index)),
        Positioned(
          top: 30.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: sequence < _index ? Color(0xFFFFD600) : Colors.black45,
          ),
        ),
        Positioned(
          top: 26.0,
          left: 10.0,
          child: Container(
            height: 16.0,
            width: 16.0,
            child: Container(
              margin: EdgeInsets.all(3.0),
              height: 16.0,
              width: 16.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sequence < _index ? Color(0xFFFFD600) : Colors.black
              ),
            ),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index) {
    phase = ProductionProgressPhaseLocalizedMap[progress.phase];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
//      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('${ProductionProgressPhaseLocalizedMap[progress.phase]} ${sequence == _index ? '（当前进行中）':''}' ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: sequence < _index ? Color(0xFFFFD600) : Colors.black54,
                          fontSize: 18)
                  ),
                ),
                Text(
                  '${progress.delayedDays >0 ? '已延期${progress.delayedDays}天': '' }',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    sequence > _index || phase == currentPhase ?
                    _buildEstimatedDate(context,progress,currentPhase,sequence,_index):
                    _buildFinishDate(context,progress,currentPhase,sequence,_index),
                    _buildQuantity(context,progress,currentPhase,sequence,_index),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image:  progress.medias == null || progress.medias.isEmpty?
                        AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        ):
                        NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${progress.medias[0].url}'),
                        fit: BoxFit.fill,
                      )),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PicturePickPreviewWidget(
                        medias: progress.medias,
                        isUpload: true,
                      ))
                  ).then((value){
                    if(value != null){
                      progress.medias = value;
                      progress.updateOnly = true;
                      uploadPicture(progress);
                    }
                  });
                },
              ),
            ],
          ),
          _buildRemarks(context,progress,currentPhase,sequence,_index),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: phase == currentPhase && progress.finishDate == null && userType != null && userType == 'factory'
                  ? RaisedButton(
                color: Color(0xFFFFD600),
                child: Text('${ProductionProgressPhaseLocalizedMap[progress.phase]}完成',
                  style: TextStyle(color: Colors.black),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  _showTipsDialog(progress);
                },
              )
                  : null)
        ],
      ),
    );
  }

  Widget _buildEstimatedDate(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                child: Text('预计完成时间',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  userType != null && userType == 'factory' && (sequence >= _index || phase == currentPhase) ?
                  _showDatePicker(progress) : null;
                }),
          ),
          GestureDetector(
              child:Align(
                alignment: Alignment.centerRight,
                child:
                progress.estimatedDate == null? Container():
                Text('${DateFormatUtil.formatYMD(
                    progress.estimatedDate)}',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              onTap: () {
                userType != null && userType == 'factory' && (sequence >= _index || phase == currentPhase) ?
                _showDatePicker(progress) : null;
              }),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  userType != null && userType == 'factory' && (sequence >= _index || phase == currentPhase) ?
                  _showDatePicker(progress) : null;
                }
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFinishDate(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('实际完成时间', style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child:
            progress.finishDate == null ? Container() :
            Text('${DateFormatUtil.formatYMD(progress.finishDate)}',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      child: Container(
            height: 35,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      child: Text('数量',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      onTap: () {
                        userType != null && userType == 'factory' && (sequence >= _index || phase == currentPhase) ?
                        _showDialog(progress,'数量'): null;
                      }),
                ),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${progress.quantity}',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    onTap: () {
                      userType != null && userType == 'factory' && (sequence >= _index || phase == currentPhase) ?
                      _showDialog(progress,'数量')
                          : null;
                    }
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: (){
                        userType != null && userType == 'factory' && (sequence >= _index || phase == currentPhase) ?
                        _showDialog(progress,'数量') : null;
                      }
                  ),
                )
              ],
            ),
          ),
    );
  }

  Widget _buildRemarks(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      child: GestureDetector(
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Row(
                children: <Widget>[
                   Text('备注', style: TextStyle(fontWeight: FontWeight.w500)),

                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: progress.remarks == null?
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '填写',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ):
                        Text(
                          '${progress.remarks}',
                          textAlign: TextAlign.start,
                          softWrap: true,
                        )
                    ),
                  )
                ])
        ),
        onTap: () async {
          userType != null && userType == 'factory' && (sequence >= _index || phase == currentPhase) ?
          _showRemarksDialog(progress,'备注') : null;
        },
      )
    );
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context,ProductionProgressModel model) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999)
    );

    if(_picked != null){
      model.estimatedDate = _picked;
      try{
        model.updateOnly = true;
        await PurchaseOrderRepository().productionProgressUpload(order.code,model.id.toString(),model);
      }catch(e){
        print(e);
      }
      setState(() {
        _blDate = _picked;
      });
    }
  }


  //确认完成按钮方法
  Future<void> _neverComplete(BuildContext context,ProductionProgressModel model) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('当前阶段是否完成？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                bool result;
                try {
                  model.updateOnly = false;
                  result = await PurchaseOrderRepository().productionProgressUpload(
                  order.code, model.id.toString(), model);
                } catch (e) {
                print(e);
                }
                Navigator.of(context).pop();
                _showMessage(context,result);
              },
            ),
          ],
        );
      },
    );
  }


//生成Dialog控件
  Future<void> _neverSatisfied(BuildContext context,ProductionProgressModel model,String type) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入${type}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller:dialogText,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                bool result = false;
                if(dialogText.text != null){
                  print(dialogText.text);
                  if(dialogText != null && dialogText.text != '') {
                    model.quantity = int.parse(dialogText.text);
                  }
                  try {
                    model.updateOnly = true;
                   result =  await PurchaseOrderRepository().productionProgressUpload(
                        order.code, model.id.toString(), model);
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    _blNumber = dialogText.text;
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

  Future<void> _neverRemarks(BuildContext context,ProductionProgressModel model,String type) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入${type}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller:dialogText,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                bool result = false;
                if(dialogText.text != null){
                  model.remarks = dialogText.text;
                  try {
                    model.updateOnly = true;
                    result =  await PurchaseOrderRepository().productionProgressUpload(
                        order.code, model.id.toString(), model);
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    _blNumber = dialogText.text;
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

//打开日期选择器
  void _showDatePicker(ProductionProgressModel model) {
    _selectDate(context,model);
  }
//打开数量输入弹框
  void _showDialog(ProductionProgressModel model,String type){
    _neverSatisfied(context,model,type);
  }

  void uploadPicture(ProductionProgressModel model) async{
    await PurchaseOrderRepository().productionProgressUpload(order.code,model.id.toString(),model);
  }

  //备注输入框
  void _showRemarksDialog(ProductionProgressModel model,String type){
    _neverRemarks(context,model,type);
  }

//确认是否完成动作
  void _showTipsDialog(ProductionProgressModel model){
    _neverComplete(context,model);
  }

  void _showMessage(BuildContext context,bool result) async{
    if(result){
      _requestMessage(context,'修改成功');
    }else{
      _requestMessage(context,'修改失败');
    }
    ProductionBLoC.instance.refreshData();
  }

//  Future<void> _requestMessage(BuildContext context,String message) async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: true, // user must tap button!
//      builder: (context) {
//        return SimpleDialog(
//          title: const Text('提示'),
//          children: <Widget>[
//            SimpleDialogOption(
//              child: Text('${message}'),
//            ),
//          ],
//        );
//      },
//    );
//  }

  Future<void> _requestMessage(BuildContext context,String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
              child: Text(
                '${message}',
                style: TextStyle(
                  fontSize: 22,
                ),
              )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                order = await PurchaseOrderRepository().getPurchaseOrderDetail(order.code);
                setState(() {
                  phase = ProductionProgressPhaseLocalizedMap[order.currentPhase];
                });
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        ProductionProgressesPage(order: order)
                    ), ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

}

