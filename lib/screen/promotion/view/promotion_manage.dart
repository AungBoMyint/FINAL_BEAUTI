import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/model/category.dart';
import 'package:kozarni_ecome/model/promotion.dart';
import 'package:kozarni_ecome/widgets/shimmer/image_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/home_controller.dart';
import '../../../data/constant.dart';
import '../../../model/advertisement.dart';
import '../../../utils/utils.dart';
import '../../../widgets/home_category.dart';

class PromotionManager extends StatefulWidget {
  final Promotion? promotion;
  const PromotionManager(this.promotion, {Key? key}) : super(key: key);

  @override
  State<PromotionManager> createState() => _PromotionManagerState();
}

class _PromotionManagerState extends State<PromotionManager> {
  late Input input;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    input = Input(input: {
      "code": TextEditingController()..text = widget.promotion?.code ?? "",
      "promotionValue": TextEditingController()
        ..text = "${widget.promotion?.promotionValue ?? ""}",
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeController _homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Promotion Form",
          style: appBarTitleStyle,
        )),
        actions: [
          if (!(widget.promotion == null)) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 12.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: homeIndicatorColor,
                ),
                child: Text("Delete"),
                onPressed: () =>
                    _homeController.deletePromotion(widget.promotion?.id ?? ""),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: homeIndicatorColor,
              ),
              child: Text("Save"),
              onPressed: () => _homeController.addPromotion(
                Promotion(
                  code: input.input["code"]?.value.text ?? "",
                  promotionValue:
                      input.input["promotionValue"]?.value.text ?? "0",
                  id: widget.promotion?.id ?? Uuid().v1(),
                  dateTime: DateTime.now(),
                ),
              ),
            ),
          ),
        ],
        elevation: 5,
        backgroundColor: detailBackgroundColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            //Image Url
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Hint Text
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Code",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: input.input.values.first,
                    keyboardType: TextInputType.text,
                    validator: input.validateInput,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            //Description
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Hint Text
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Value: __ks (or) __%",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: input.input["promotionValue"],
                    /*  keyboardType: TextInputType., */
                    validator: input.validateInput,
                    decoration: InputDecoration(
                      hintText: "100ks (or) 1%",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
