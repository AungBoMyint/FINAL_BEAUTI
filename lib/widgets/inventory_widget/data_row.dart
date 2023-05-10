import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/model/product.dart';

import '../../../controller/home_controller.dart';
import 'custom_table_cell.dart';

DataRow resuableDataRow({required Product item}) {
  HomeController _homeController = Get.find();
  return DataRow(cells: <DataCell>[
    /* DataCell(Row(
      children: [
        //UpdateButton
        IconButton(
          onPressed: () {
            _homeController.setEditItem(item);
            Get.toNamed(uploadItemScreen);
          },
          icon: const Icon(
            Icons.edit,
          ),
        ),
        //DeleteButton
        IconButton(
          onPressed: () async {
            //await _manageController.delete(item.id!);
          },
          icon: const Icon(
            Icons.delete,
          ),
        )
      ],
    )),*/
    DataCell(customTableCell(item.id)),
    DataCell(customTableCell(item.name)),
    DataCell(customTableCell("${item.originalQuantity}")),
    DataCell(customTableCell("${item.remainQuantity}")),
    DataCell(customTableCell("${item.price}")),
    DataCell(customTableCell("${item.price * (item.remainQuantity ?? 0)}")),
    DataCell(customTableCell("${item.originalPrice}")),
    DataCell(customTableCell(
        "${(item.originalPrice ?? 0) * (item.remainQuantity ?? 0)}")),
  ]);
}
