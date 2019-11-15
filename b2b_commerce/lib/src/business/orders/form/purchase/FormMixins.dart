import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'ColorSizeEntry.dart';

///发货，收货单表单控件变量Mixins
class DeliverAndShippingFormMixins {
  FocusNode consignorNameFocusNode;
  TextEditingController consignorNameController;

  FocusNode consignorPhoneFocusNode;
  TextEditingController consignorPhoneController;

  FocusNode trackingIDFocusNode;
  TextEditingController trackingIDController;

  FocusNode brandFocusNode;
  TextEditingController brandController;

  FocusNode skuIDFocusNode;
  TextEditingController skuIDController;

  FocusNode withdrawalQualityFocusNode;
  TextEditingController withdrawalQualityController;

  FocusNode defectiveQualityFocusNode;
  TextEditingController defectiveQualityController;

  FocusNode consigneeNameFocusNode;
  TextEditingController consigneeNameController;

  FocusNode consigneePhoneFocusNode;
  TextEditingController consigneePhoneController;

  FocusNode consigneeAddressFocusNode;
  TextEditingController consigneeAddressController;

  ///是否线下物流
  bool isOfflineConsignment;

  ///物流信息
  ConsignmentModel consignment;

  void initForm() {
    consignorNameFocusNode = FocusNode();
    consignorNameController = TextEditingController();

    consignorPhoneFocusNode = FocusNode();
    consignorPhoneController = TextEditingController();

    trackingIDFocusNode = FocusNode();
    trackingIDController = TextEditingController();

    brandFocusNode = FocusNode();
    brandController = TextEditingController();

    skuIDFocusNode = FocusNode();
    skuIDController = TextEditingController();

    withdrawalQualityFocusNode = FocusNode();
    withdrawalQualityController = TextEditingController();

    defectiveQualityFocusNode = FocusNode();
    defectiveQualityController = TextEditingController();

    consigneeNameFocusNode = FocusNode();
    consigneeNameController = TextEditingController();

    consigneePhoneFocusNode = FocusNode();
    consigneePhoneController = TextEditingController();

    consigneeAddressFocusNode = FocusNode();
    consigneeAddressController = TextEditingController();

    isOfflineConsignment = false;
  }

  void initDeliveryUpdate(DeliveryOrderNoteModel order) {
    consignorNameController.text = order.consignorName;
    consignorPhoneController.text = order.consignorPhone;
    if (!order.isOfflineConsignment) {
      trackingIDController.text = order.consignment.trackingID;
    }
    brandController.text = order.brand;
    skuIDController.text = order.skuID;
    withdrawalQualityController.text = order.withdrawalQuality;
    defectiveQualityController.text = order.defectiveQuality;
    consigneeNameController.text = order.consigneeName;
    consigneePhoneController.text = order.consigneePhone;
    consigneeAddressController.text = order.consigneeAddress;
    isOfflineConsignment = order.isOfflineConsignment;
    consignment = order.consignment;
  }

  void initShippingUpdate(ShippingOrderNoteModel order) {
    consignorNameController.text = order.consignorName;
    consignorPhoneController.text = order.consignorPhone;
    if (!order.isOfflineConsignment) {
      trackingIDController.text = order.consignment.trackingID;
    }
    brandController.text = order.brand;
    skuIDController.text = order.skuID;
    withdrawalQualityController.text = order.withdrawalQuality;
    defectiveQualityController.text = order.defectiveQuality;
    consigneeNameController.text = order.consigneeName;
    consigneePhoneController.text = order.consigneePhone;
    consigneeAddressController.text = order.consigneeAddress;
    isOfflineConsignment = order.isOfflineConsignment;
    consignment = order.consignment;
  }

  DeliveryOrderNoteModel getDeliveryForCreate(
      List<ColorSizeEntry> colorSizeEntries) {
    DeliveryOrderNoteModel order = DeliveryOrderNoteModel(
        consignorName: consignorNameController.text,
        consignorPhone: consignorPhoneController.text,
        brand: brandController.text,
        skuID: skuIDController.text,
        withdrawalQuality: withdrawalQualityController.text,
        defectiveQuality: defectiveQualityController.text,
        consigneeName: consigneeNameController.text,
        consigneePhone: consigneePhoneController.text,
        consigneeAddress: consigneeAddressController.text,
        isOfflineConsignment: isOfflineConsignment,
        consignment: consignment);
    if (!order.isOfflineConsignment) {
      order.consignment.trackingID = trackingIDController.text;
    }

    List<OrderNoteEntryModel> entries = colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .map((entry) =>
        OrderNoteEntryModel(
            color: entry.color,
            size: entry.size,
            quantity: int.parse(entry.controller.text)))
        .toList();

    order.entries = entries;
    return order;
  }

  DeliveryOrderNoteModel getDeliveryForUpdate(DeliveryOrderNoteModel order,
      List<ColorSizeEntry> colorSizeEntries) {
    order
      ..consignorName = consignorNameController.text
      ..brand = brandController.text
      ..skuID = skuIDController.text
      ..withdrawalQuality = withdrawalQualityController.text
      ..defectiveQuality = defectiveQualityController.text
      ..consigneeName = consigneeNameController.text
      ..consigneePhone = consigneePhoneController.text
      ..consigneeAddress = consigneeAddressController.text
      ..isOfflineConsignment = isOfflineConsignment
      ..consignorPhone = consignorPhoneController.text;
    if (!order.isOfflineConsignment) {
      order.consignment.trackingID = trackingIDController.text;
    }

    List<OrderNoteEntryModel> entries = colorSizeEntries
        .where((entry) => entry.controller.text != '')
        .map((entry) {
      print(entry.id);
      return OrderNoteEntryModel(
          color: entry.color,
          size: entry.size,
          id: entry.id,
          quantity: int.parse(entry.controller.text));
    }).toList();

    order.entries = entries;
    return order;
  }
}
