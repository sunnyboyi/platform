import 'dart:async';

import 'package:b2b_commerce/src/my/account/register_info.dart';
import 'package:b2b_commerce/src/my/account/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isAgree = true;
  String _userType = "brand";
  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;
  bool validate = false;

  void _handleUserTypeChanged(String value) {
    setState(() {
      _userType = value;
    });
  }

  _startTimer() {
    _seconds = 60;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        iconTheme: IconThemeData(color: Color.fromRGBO(36, 38, 41, 1)),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '注册',
          style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 50),
            padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
            child: Column(
              children: <Widget>[
                InputRow(
                  label: '手机号',
                  field: TextField(
                    autofocus: false,
                    onChanged: (value) {
                      formValidate();
                    },
                    keyboardType: TextInputType.phone,
                    //只能输入数字
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    controller: _phoneController,
                    decoration: InputDecoration(
                        hintText: '请输入', border: InputBorder.none),
                  ),
                ),
                InputRow(
                  label: '验证码',
                  field: TextField(
                    autofocus: false,
                    onChanged: (value) {
                      formValidate();
                    },
                    keyboardType: TextInputType.phone,
                    //只能输入数字
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    controller: _captchaController,
                    decoration: InputDecoration(
                        hintText: '请输入', border: InputBorder.none),
                  ),
                  surfix: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Color.fromRGBO(255, 214, 12, 1),
                    onPressed: (_seconds == 0)
                        ? () {
                            setState(() {
                              _startTimer();
                            });
                          }
                        : null,
                    child: Text(
                      '$_verifyStr',
                      style: TextStyle(
                          color:
                              (_seconds == 0) ? Colors.white : Colors.black45),
                    ),
                  ),
                ),
                InputRow(
                    label: '设置密码',
                    field: TextField(
                      autofocus: false,
                      obscureText: true,
                      onChanged: (value) {
                        formValidate();
                      },
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: '请输入', border: InputBorder.none),
                    )),
              ],
            ),
          ),
          RaisedButton(
            onPressed: validate ? onNext : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Color.fromRGBO(255, 214, 12, 1),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '下一步',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  onChanged: (v) {
                    setState(() {
                      _isAgree = v;
                      formValidate();
                    });
                  },
                  value: _isAgree,
                ),
                Text(
                  '已经阅读或同意《衣加衣协议》',
                  style: TextStyle(
                      color: _isAgree
                          ? Color.fromRGBO(255, 214, 12, 1)
                          : Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void formValidate() {
    setState(() {
      validate = _phoneController.text.trim().length > 0 &&
          _captchaController.text.trim().length > 0 &&
          _passwordController.text.trim().length > 0 &&
          _isAgree;
    });
  }

  void onNext() {
    //TODOS验证验证码
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RegisterInfoPage(
              phone: _phoneController.text,
              password: _passwordController.text,
            )));
  }
}

class UserTypeEntry {
  final String label;
  final String value;
  final Icon icon;

  UserTypeEntry({this.label, this.value, this.icon});
}

class UserTypeSelector extends StatelessWidget {
  const UserTypeSelector(
      {Key key, @required this.value, this.userTypeEntries, this.onChanged})
      : super(key: key);

  final String value;
  final List<UserTypeEntry> userTypeEntries;

  final ValueChanged<String> onChanged;

  void _handleTap(String v) {
    onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = userTypeEntries
        .map((v) => GestureDetector(
              onTap: () {
                _handleTap(v.value);
              },
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: v.icon,
                    ),
                    Text(
                      v.label,
                      style: TextStyle(
                          color: v.value == value
                              ? Color.fromRGBO(255, 214, 12, 1)
                              : Colors.black54),
                    )
                  ],
                ),
              ),
            ))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgetList,
    );
  }
}

class RegisterInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String remind;
  final bool validate;

  const RegisterInput(
      {Key key,
      @required this.controller,
      @required this.labelText,
      @required this.remind,
      this.validate = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText, hintText: '请输入', border: InputBorder.none),
          // 校验用户名
          validator: (v) {
            if (validate) {
              return v.trim().length > 0 ? null : remind;
            } else {
              return null;
            }
          }),
    );
  }
}
