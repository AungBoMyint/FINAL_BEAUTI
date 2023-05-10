import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:kozarni_ecome/model/hive_purchase.dart';
import 'package:kozarni_ecome/widgets/home_appbar/home_app_bar.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black,),
        backgroundColor: appBarColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            "Order History",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              // fontStyle: FontStyle.italic,
              wordSpacing: 2,
              letterSpacing: 1,
            ),
          ),
        ),),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<HivePurchase>(purchaseBox).listenable(),
        builder: (context, Box<HivePurchase> box, widget) {
          return box.isNotEmpty
              ? SizedBox(
            height: size.height,
            width: size.width,
            child: ListView(
              children: box.values.map((purchase) {
                return Obx(() {
                  return Dismissible(
                    key: Key(purchase.id),
                    background: Container(
                      color: Colors.black12,
                    ),
                    onDismissed: (direction) {
                      box.delete(purchase.id);
                    },
                    direction: DismissDirection.startToEnd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionPanelList(
                          expansionCallback: (index, isExpanded) =>
                              controller.setPurchaseId(purchase.id),
                          children: [
                            ExpansionPanel(
                              isExpanded:
                              controller.purchaseId == purchase.id,
                              canTapOnHeader: true,
                              headerBuilder: (context, isExpand) {

                                return ListTile(
                                  title: Text(
                                    "မှာယူခဲ့သောအရေအတွက် = ${purchase.items.length}",
                                    style: TextStyle(fontSize: 12),),
                                  subtitle: Text(
                                    "${purchase.totalPrice} ကျပ် "
                                        "(ပို့ခ ${purchase.deliveryTownshipInfo[1]}ကျပ် ပေါင်းပြီး)",
                                    style: TextStyle(fontSize: 12, color: Colors.black),),


                                  trailing: Text(
                                    "${purchase.dateTime.day}/"
                                        "${purchase.dateTime.month}/"
                                        "${purchase.dateTime.year}",
                                    style: TextStyle(fontSize: 12),),

                                );
                              },
                              body: SizedBox(
                                height: purchase.items.length * 50,
                                width: size.width * 0.8,
                                child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    itemCount: purchase.items.length,
                                    itemBuilder: (_, o) {
                                      final purchaseItem = purchase.items[o];
                                      final itemPrice = purchaseItem.requirePoint! > 0 ? 0
                                          : purchaseItem.discountPrice! > 0 ? purchaseItem.discountPrice : purchaseItem.price;
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${o + 1}. ${purchase.items[o].itemName}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  // Text(
                                                  //   "${purchase.items[o].color  ?? "no color"}",
                                                  //   style:
                                                  //   TextStyle(fontSize: 10),
                                                  // ),
                                                  Text(
                                                    "${purchase.items[o].size ?? "no size"}",
                                                    style:
                                                    TextStyle(fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "$itemPrice x  ${purchase.items[o].count}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ),
                          ]),
                    ),
                  );
                });
              }).toList(),
            ),
          )
              : Center(
            child: Text("No order history."),
          );
        },
      ),
    );
  }
}
