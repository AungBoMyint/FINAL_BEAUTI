import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../purchase_dialog_box/purchase_dialog_box.dart';

class CashOnDelivery extends StatelessWidget {
  const CashOnDelivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find();
    return ListView.builder(
      itemCount: controller.purchcasesCashOn().length,
      itemBuilder: (_, i) {
        List town = controller.purchcasesCashOn()[i].deliveryTownshipInfo;
        final shipping = town[1];
        final townName = town[0];
        return ListTile(
          title: Text(
              "${controller.purchcasesCashOn()[i].name} 0${controller.purchcasesCashOn()[i].phone}"),
          subtitle: Text(
              "${DateTime.parse(controller.purchcasesCashOn()[i].dateTime).day}/${DateTime.parse(controller.purchcasesCashOn()[i].dateTime).month}/${DateTime.parse(controller.purchcasesCashOn()[i].dateTime).year}"),
          trailing: IconButton(
            onPressed: () {

              print(controller.purchcasesCashOn()[i].items.length);

              Get.defaultDialog(
                title: "Customer ၀ယ်ယူခဲ့သော အချက်အလက်များ",
                titleStyle: TextStyle(fontSize: 12),
                radius: 5,
                content: purchaseDialogBox(
                  context: context,
                  purchaseModel: controller.purchcasesCashOn()[i]),
              );
            },
            icon: Icon(Icons.info),
          ),
        );
      },
    );
  }
}
