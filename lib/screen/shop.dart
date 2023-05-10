import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../model/view_all_model.dart';
import '../routes/routes.dart';

// ignore: camel_case_types
class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop>
    with SingleTickerProviderStateMixin {
  final colorstheme = Color(0xff4b4b87);

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0)
      ..addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     'Shop',
      //     style: TextStyle(fontSize: 20, color: Colors.black),
      //   ),
      //   centerTitle: true,
      //   shadowColor: Colors.transparent,
      // ),
      body: CardWidget(),
    );
  }
}

class CardWidget extends StatelessWidget {
  List data = [
    {"color": Color(0xffff6968)},
    {"color": Color(0xff7a54ff)},
    {"color": Color(0xffff8f61)},
    {"color": Color(0xff2ac3ff)},
    {"color": Color(0xff5a65ff)},
    {"color": Color(0xff96da45)},
    {"color": Color(0xffff6968)},
    {"color": Color(0xff7a54ff)},
    {"color": Color(0xffff8f61)},
    {"color": Color(0xff2ac3ff)},
    {"color": Color(0xff5a65ff)},
    {"color": Color(0xff96da45)},

  ];

  final colorwhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    final HomeController _controller = Get.find();
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: GridView.builder(
        itemCount: _controller.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 3),

          // crossAxisSpacing: 10
        ),
        itemBuilder: (context, index) {
          final cate = _controller.categories[index];
          return InkWell(
            onTap: (){
              _controller.setViewAllProducts(
                                                    ViewAllModel(
                                                      status: "${cate.name} Products", 
                                                      products: _controller.items.where((e) => e.category == cate.name).toList(),
                                                    )
                                                  );
                                                  Get.toNamed(viewAllUrl);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 5,right: 5),
              child: Card(
                elevation: 10,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: 50,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20, top: 10),

                                child: Text(
                                  cate.name,
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right:10),
                          child: Column(
                            children: [
                            cate.image!.isNotEmpty ?
                            CachedNetworkImage(
                            imageUrl: cate.image!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.fitWidth,
                          ) : const SizedBox(),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}