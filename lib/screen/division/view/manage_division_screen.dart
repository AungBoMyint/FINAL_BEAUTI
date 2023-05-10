import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/screen/division/controller/division_controller.dart';

import '../../../data/constant.dart';
import '../../../widgets/button/button.dart';

class ManageDivisionScreen extends StatelessWidget {
  const ManageDivisionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DivisionController divisionController = Get.find();
    final HomeController homeController = Get.find();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Manage Divisions",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
            // fontStyle: FontStyle.italic,
            wordSpacing: 2,
            letterSpacing: 3,
          ),
        ),
        elevation: 0,
        backgroundColor: detailBackgroundColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: appBarTitleColor,
          ),
        ),
      ),
      body: Column(
        children: [
          //Top Functions
          Form(
            key: divisionController.formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: divisionController.textController,
                      validator: (value) =>
                          divisionController.validator(value, "Division"),
                      decoration: InputDecoration(
                        //hintText: ,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  ExButton(
                    color: homeIndicatorColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    label: "Add",
                    height: 36.0,
                    onPressed: () {
                      if (divisionController.formKey.currentState!.validate()) {
                        divisionController.add();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          //Body LIst
          Expanded(
            child: Obx(() {
              final divisionList = homeController.divisionList;
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 1,
                    );
                  },
                  itemCount: divisionList.length,
                  itemBuilder: (context, index) {
                    final division = divisionList[index];
                    return Dismissible(
                      key: Key(division.id),
                      background: Container(color: Colors.red),
                      confirmDismiss: (dir) {
                        return Get.defaultDialog(
                          title: "Are yu sure to delete?",
                          confirm: ExButton(
                            color: homeIndicatorColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            label: "OK",
                            height: 36.0,
                            width: 100,
                            onPressed: () {
                              divisionController
                                  .deleteDivision(division.id)
                                  .then((value) => Get.back(result: true))
                                  .onError((error, stackTrace) =>
                                      Get.back(result: false));
                            },
                          ),
                          cancel: ExButton(
                            color: homeIndicatorColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            label: "CANCEL",
                            height: 36.0,
                            width: 100,
                            onPressed: () {
                              Get.back(result: false);
                            },
                          ),
                          content: const SizedBox(),
                        );
                      },
                      direction: DismissDirection.startToEnd,
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            children: [
                              //Division Name
                              Expanded(
                                child: Text(
                                  division.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              //Added Button
                              OutlinedButton(
                                  onPressed: () {
                                    //Need to set division id
                                    divisionController
                                        .setSelectedDivision(division.id);
                                    Get.defaultDialog(
                                      title: "Add Township",
                                      content: Form(
                                          key: divisionController
                                              .townshipFormKey,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: divisionController
                                                      .townshipController,
                                                  validator: (value) =>
                                                      divisionController
                                                          .validator(
                                                              value, "Name"),
                                                  decoration: InputDecoration(
                                                    label:
                                                        Text("Township Name"),
                                                    //hintText: ,
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  controller: divisionController
                                                      .feeController,
                                                  validator: (value) =>
                                                      divisionController
                                                          .feeValiator(value),
                                                  decoration: InputDecoration(
                                                    label: Text("Delivery fee"),
                                                    //hintText: ,
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      confirm: ExButton(
                                        color: homeIndicatorColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        label: "Save",
                                        height: 36.0,
                                        width: 100,
                                        onPressed: () {
                                          if (divisionController
                                                  .townshipFormKey.currentState
                                                  ?.validate() ==
                                              true) {
                                            divisionController.addTonship();
                                            Get.back();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colours.goldenRod,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              //View Button
                              OutlinedButton(
                                  onPressed: () {
                                    Get.bottomSheet(
                                      ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            thickness: 1,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          final township =
                                              division.townships[index];
                                          return Dismissible(
                                              key: Key(township.name),
                                              background:
                                                  Container(color: Colors.red),
                                              direction:
                                                  DismissDirection.startToEnd,
                                              confirmDismiss: (dir) =>
                                                  divisionController
                                                      .deleteTownship(
                                                          division.id,
                                                          division.townships,
                                                          township),
                                              child: SizedBox(
                                                height: 50,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 20,
                                                      right: 20,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        ///Township Name
                                                        Expanded(
                                                          child: Text(
                                                            township.name,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        //Fee
                                                        Text(
                                                          township.fee
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ));
                                        },
                                        itemCount: division.townships.length,
                                      ),
                                      backgroundColor: Colors.white,
                                      elevation: 3,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colours.goldenRod,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "View",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }),
          ),
        ],
      ),
    );
  }
}
