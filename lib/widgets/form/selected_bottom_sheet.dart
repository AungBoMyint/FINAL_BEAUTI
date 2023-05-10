import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedBottomSheet extends StatelessWidget {
  final String hint;
  final bool isEmpty;
  final String selectedValue;
  final bool isError;
  final List<String> list;
  final void Function(String value) setSelectedId;
  final void Function(String value) setSelectedIdError;
  const SelectedBottomSheet({
    Key? key,
    required this.setSelectedId,
    required this.setSelectedIdError,
    required this.hint,
    required this.isEmpty,
    required this.selectedValue,
    required this.list,
    required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          Container(
            color: Colors.grey.shade300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final shop = list[index];
                return TextButton(
                  onPressed: () {
                    setSelectedId(shop);
                    setSelectedIdError("");
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    color: selectedValue == shop
                        ? Colors.blue
                        : Colors.grey.shade300,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      shop,
                      style: TextStyle(
                        color:
                            selectedValue == shop ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: UpDownChoice(
        items: const [],
        hint: hint,
        isError: isError,
        increase: () {},
        decrease: () {},
        isEmpty: isEmpty,
        selectedValue: selectedValue,
      ),
    );
  }
}

class UpDownChoice<T> extends StatelessWidget {
  const UpDownChoice({
    Key? key,
    required this.items,
    required this.hint,
    required this.increase,
    required this.decrease,
    required this.isEmpty,
    required this.selectedValue,
    required this.isError,
  }) : super(key: key);

  final List<T> items;
  final String selectedValue;
  final void Function() increase;
  final void Function() decrease;
  final String hint;
  final bool isEmpty;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 0,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: isError ? Colors.red : Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            //Text
            Expanded(
              child: Text(isEmpty ? hint : selectedValue,
                  style: isEmpty
                      ? const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        )),
            ),
            /* SizedBox(
              height: 50,
              child: Column(
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: decrease,
                      icon: const Icon(
                        FontAwesomeIcons.chevronUp,
                        size: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: increase,
                      icon: const Icon(
                        FontAwesomeIcons.chevronDown,
                        size: 15,
                      ),
                    ),
                  )
                ],
              ),
            ) */
            //Up & Down button
          ],
        ),
      ),
    );
  }
}
