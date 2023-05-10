import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/product.dart';

class SelectableBottomSheet extends StatelessWidget {
  const SelectableBottomSheet({
    Key? key,
    required this.list,
    required this.selectedObxMap,
    required this.pressedCancelButton,
    required this.pressedSaveButton,
    required this.selectedProduct,
  }) : super(key: key);

  final List<Product> list;
  final RxMap<String, Product> selectedObxMap;
  final void Function(Product product) selectedProduct;
  final void Function() pressedCancelButton;
  final void Function() pressedSaveButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final product = list[index];

                return Obx(() {
                  final map = selectedObxMap;
                  final isSelected = map.containsKey(product.id);
                  return InkWell(
                    onTap: () => selectedProduct(product),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              //Text
                              Expanded(
                                child: Text(product.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              //CheckBox
                              Checkbox(
                                activeColor: Colors.orangeAccent,
                                value: isSelected,
                                onChanged: (b) => selectedProduct(product),
                                checkColor: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          SizedBox(
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                      ),
                      onPressed: () {
                        Get.back();
                        pressedCancelButton();
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                      ),
                      onPressed: () => pressedSaveButton(),
                      child: const Text("Save"),
                    ),
                  ])),
        ],
      ),
    );
  }
}
