import 'package:flutter/material.dart';
import 'package:models/models.dart';

class IsProofingField extends StatefulWidget {
  final RequirementOrderModel item;

  IsProofingField(this.item);

  IsProofingFieldState createState() => IsProofingFieldState();
}

class IsProofingFieldState extends State<IsProofingField> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '是否需要打样',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: Text(
              widget.item.details?.proofingNeeded == null ? '选取' : widget.item.details?.proofingNeeded ? '需要打样':'不需要打样',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('需要打样'),
                        onTap: () async {
                          setState(() {
                            widget.item.details.proofingNeeded = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('不需要打样'),
                        onTap: () async {
                          setState(() {
                            widget.item.details.proofingNeeded = false;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ));
            },
          );
        });
  }
}
