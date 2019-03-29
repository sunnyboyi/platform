import 'package:flutter/material.dart';

class B2BIcons {
  static const IconData bool =
      const IconData(0xe656, fontFamily: 'b2bIcons', matchTextDirection: true);
  static const IconData eye_not_see =
      const IconData(0xe652, fontFamily: 'b2bIcons', matchTextDirection: true);
  static const IconData publish_requirement_success =
      const IconData(0xe69e, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData factory_map =
      const IconData(0xe6b8, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData industrial_cluster =
      const IconData(0xe698, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData factory_brand =
      const IconData(0xe699, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData free_proofing =
      const IconData(0xe69c, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData factory_all =
      const IconData(0xe69a, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData message =
      const IconData(0xe653, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData left_quotation =
      const IconData(0xe6a5, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData right_quotation =
      const IconData(0xe6a6, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData delay =
      const IconData(0xe6a8, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData brand =
      const IconData(0xe6ad, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData factory =
      const IconData(0xe6ac, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData purchase =
      const IconData(0xe6ab, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData calendar =
      const IconData(0xe6ae, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData search =
      const IconData(0xe684, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData star =
      const IconData(0xe686, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData menu =
      const IconData(0xe6af, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData add =
      const IconData(0xe68d, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData noPicture =
      const IconData(0xe6c7, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData condition =
      const IconData(0xe6b1, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData more =
      const IconData(0xe6b0, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData right =
      const IconData(0xe657, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData location =
      const IconData(0xe647, fontFamily: 'b2bIcons', matchTextDirection: true);
  static const IconData ICBC =
      const IconData(0xe6bc, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData del_blank_card =
      const IconData(0xe6ba, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData arrow_left_bottom =
      const IconData(0xeb0c, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData arrow_right =
      const IconData(0xe681, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData hot =
      const IconData(0xe6a9, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData production =
      const IconData(0xe6be, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData production_active =
      const IconData(0xe6bd, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData home =
      const IconData(0xe6c2, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData home_active =
      const IconData(0xe6c0, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData business_active =
      const IconData(0xe6c5, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData business =
      const IconData(0xe6c4, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData my =
      const IconData(0xe6bf, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData my_active =
      const IconData(0xe6c3, fontFamily: 'b2bIcons2', matchTextDirection: true);
}

class CommonImage {
  static String _package = 'assets';

  static Image pdf({double width, double height}) {
    return Image.asset(
      'temp/pdf.png',
      package: _package,
      width: width,
      height: height,
    );
  }

  static Image word({double width, double height}) {
    return Image.asset(
      'temp/word.png',
      package: _package,
      width: width,
      height: height,
    );
  }

  static Image excel({double width, double height}) {
    return Image.asset(
      'temp/excel.png',
      package: _package,
      width: width,
      height: height,
    );
  }
}
