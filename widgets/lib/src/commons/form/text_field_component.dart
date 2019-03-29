import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {
  final String leadingText;
  final String hintText;
  final String helperText;
  double leadingWidth;
  TextEditingController controller;
  //必传
  final FocusNode focusNode;
  final TextInputType inputType;
  final Widget trailing;
  ValueChanged<String> onChanged;
  VoidCallback onEditingComplete;
  final bool autofocus;
  EdgeInsets padding;
  EdgeInsets dividerPadding;
  bool enabled;
  TextInputAction textInputAction;
  TextAlign textAlign;
  Color leadingColor;
  bool hideDivider;
  TextStyle style;

//  final FormFieldValidator<String> _validator;

  TextFieldComponent({
    this.leadingText,
    this.hintText,
    this.helperText,
    this.leadingWidth = 75,
    this.controller,
    @required this.focusNode,
    this.inputType,
    this.trailing,
    this.onChanged,
    this.onEditingComplete,
    this.autofocus = false,
    this.padding,
    this.dividerPadding,
    this.enabled,
    this.textInputAction,
    this.textAlign = TextAlign.right,
    this.leadingColor = Colors.black,
    this.hideDivider = false,
    this.style,
  });

  TextFieldComponentState createState() => TextFieldComponentState();
}

class TextFieldComponentState extends State<TextFieldComponent> {
  Color _dividerColor = Colors.grey[400];

  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        setState(() {
          _dividerColor = Color.fromRGBO(255,214,12, 1);
        });
      } else {
        setState(() {
          _dividerColor = Colors.grey[400];
        });
      }
    });

    if (widget.leadingText == null || widget.leadingText == '') {
      widget.leadingWidth = 0.0;
    } else if (widget.leadingWidth != null) {
      widget.leadingWidth = widget.leadingWidth;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      widget.controller.value = TextEditingValue(
        // 设置内容
        text: widget.controller.text,
        // 保持光标在最后
        selection: TextSelection.fromPosition(
          TextPosition(
              affinity: TextAffinity.upstream,
              offset: widget.controller.text.length,
          ),
        ),
      );
    return Column(
      children: <Widget>[
        Container(
          padding: widget.padding ??
              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: <Widget>[
              Offstage(
                offstage: widget.leadingText == null,
                child: Container(
                  width: widget.leadingWidth,
                  child: Text(widget.leadingText ?? '',style: TextStyle(fontSize: 16,color: widget.leadingColor),),
                ),
              ),
              Expanded(
                child: TextField(
                  style: widget.style,
                  controller: widget.controller,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  autofocus: widget.autofocus,
                  focusNode: widget.focusNode,
                  onChanged: widget.onChanged,
                  enabled: widget.enabled,
                  onEditingComplete: widget.onEditingComplete,
                  textInputAction: widget.textInputAction,
                  textAlign: widget.textAlign,
                ),
              ),
              Offstage(
                offstage: widget.trailing == null,
                child: widget.trailing,
              )
            ],
          ),
        ),
        Offstage(
          offstage: widget.hideDivider,
          child: Padding(
            padding: widget.dividerPadding ?? widget.dividerPadding ?? EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  height: 0,
                  color: _dividerColor,
                ),
                Offstage(
                  offstage: widget.helperText == null,
                  child: Text(
                    widget.helperText ?? '',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
