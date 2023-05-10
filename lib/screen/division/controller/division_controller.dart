import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/model/division.dart';
import 'package:kozarni_ecome/model/township.dart';
import 'package:uuid/uuid.dart';

import '../../../data/constant.dart';

class DivisionController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  RxString selectedDivisionId = "".obs;
  TextEditingController textController = TextEditingController();
  TextEditingController townshipController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<FormState> townshipFormKey = GlobalKey();
  void setSelectedDivision(String id) => selectedDivisionId.value = id;

  String? validator(String? value, String key) {
    return (value == null || value.isEmpty) ? "$key is required" : null;
  }

  String? feeValiator(String? value) {
    if (value == null || value.isEmpty) {
      return "Fee is required.";
    }
    String? result;
    try {
      int.parse(value);
      result = null;
    } catch (e) {
      result = "Not number.";
    }
    return result;
  }

  Future<void> add() async {
    final division = Division(
      id: Uuid().v1(),
      name: textController.text,
      townships: [],
      dateTime: DateTime.now(),
    );
    try {
      await _firestore
          .collection(divisionCollection)
          .doc(division.id)
          .set(division.toJson());
      textController.clear();
    } catch (e) {
      log("Error Adding Division: $e");
    }
  }

  ///[id] = Division's id
  Future<void> deleteDivision(String id) async {
    try {
      await _firestore.collection(divisionCollection).doc(id).delete();
    } catch (e) {
      log("Error Deleting Division: $e");
    }
  }

  ///[id] is Division's id and [value] is value that is edited.
  Future<void> updateDivision(String id, String value) async {
    try {
      await _firestore.collection(divisionCollection).doc(id).update(
        {
          "name": value,
        },
      );
    } catch (e) {
      log("Error Editing Division Name: $e");
    }
  }

  Future<void> addTonship() async {
    if (selectedDivisionId.value.isEmpty) {
      return;
    }
    final township = Township(
      fee: int.parse(feeController.text),
      name: townshipController.text,
    );
    try {
      await _firestore
          .collection(divisionCollection)
          .doc(selectedDivisionId.value)
          .update({
        "townships": FieldValue.arrayUnion([township.toJson()])
      });
      selectedDivisionId.value = "";
      townshipController.clear();
      feeController.clear();
    } catch (e) {
      log("Error Adding Township: $e");
    }
  }

  ///[id] is Division id,[townships] is Division's township List
  ///[currentTownship] is a township want to delete.
  Future<bool> deleteTownship(
    String id,
    List<Township> townships,
    Township currentTownship,
  ) async {
    Completer<bool> completer = Completer<bool>();
    //First,we remove currentTownship from townships's list
    List<Township> townList = List.from(townships);
    townList.removeWhere((element) => element.name == currentTownship.name);
    try {
      await _firestore.collection(divisionCollection).doc(id).set({
        "townships": townList.map((e) => e.toJson()).toList(),
      }, SetOptions(merge: true));
      completer.complete(true);
    } catch (e) {
      completer.complete(false);
      log("Error Deleting Township: $e");
    }
    return completer.future;
  }
}
