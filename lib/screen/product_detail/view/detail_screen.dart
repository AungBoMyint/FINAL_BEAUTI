import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kozarni_ecome/controller/home_controller.dart';
import 'package:kozarni_ecome/data/constant.dart';
import 'package:get/get.dart';
import 'package:kozarni_ecome/expaned_widget.dart';
import 'package:kozarni_ecome/model/hive_item.dart';
import 'package:kozarni_ecome/routes/routes.dart';
import '../../../widgets/product_review/product_review.dart';
import '../../home_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kozarni_ecome/model/size.dart' as own;

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final currentProduct = controller.editItem.value;
    return Scaffold(
      backgroundColor: detailTextBackgroundColor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ValueListenableBuilder(
              valueListenable: Hive.box<HiveItem>(boxName).listenable(),
              builder: (context, Box<HiveItem> box, widget) {
                final currentObj = box.get(currentProduct!.id);

                if (!(currentObj == null)) {
                  return IconButton(
                      onPressed: () {
                        box.delete(currentObj.id);
                      },
                      icon: Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.red,
                        size: 25,
                      ));
                }
                return IconButton(
                    onPressed: () {
                      box.put(currentProduct.id,
                          controller.changeHiveItem(currentProduct));
                    },
                    icon: Icon(
                      Icons.favorite_outline,
                      color: Colors.red,
                      size: 25,
                    ));
              },
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          currentProduct!.name,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Hero(
                tag: currentProduct.photo1,
                child: CarouselSlider(
                  items: [
                    CachedNetworkImage(
                      imageUrl: currentProduct.photo1,
                      // "$baseUrl$itemUrl${currentProduct.photo}/get",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    CachedNetworkImage(
                      imageUrl: currentProduct.photo2,
                      // "$baseUrl$itemUrl${currentProduct.photo}/get",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    CachedNetworkImage(
                      imageUrl: currentProduct.photo3,
                      // "$baseUrl$itemUrl${currentProduct.photo}/get",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                  options: CarouselOptions(
                    height: 250,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: detailTextBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Product Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      //Star
                      Text(
                        currentProduct.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      //Favourite Icon
                    ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Brand Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      //Star
                      Text(
                        currentProduct.brandName ?? '',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      //Favourite Icon
                    ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      //Star
                      Text(
                        currentProduct.category,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      //Favourite Icon
                    ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      "${currentProduct.price} Kyats",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Discount Price",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      (currentProduct.discountPrice ?? 0) > 0
                          ? "${currentProduct.discountPrice} Kyats"
                          : "no discount price",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ExpandedWidget(
                  text: currentProduct.description,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: currentProduct.photo2,
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: currentProduct.photo3,
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text(
                //       "🏠 Shop Address",
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.grey,
                //       ),
                //     ),
                //     SizedBox(
                //       height: 5,
                //     ),
                //     Text(
                //       'ဥက္ကာလမ်း ၊ ဥက္ကာ ၅x၆ လမ်း ၊ မြောက်ဥက္ကလာပမြို့နယ် ၊ ရန်ကုန်မြို့။',
                //       style: TextStyle(
                //         fontSize: 15,
                //         color: Colors.black,
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
          //--------------Review------//
          ProductReviewWidget(
            product: currentProduct,
          ),
          //-----------------------//
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 65,
        // decoration: BoxDecoration(
        //   color: detailBackgroundColor,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(20),
        //     topRight: Radius.circular(20),
        //   ),
        // ),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: !(currentProduct.remainQuantity == null) &&
                (currentProduct.remainQuantity! == 0)
            ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade300),
                ),
                onPressed: null,
                child: Text("Out of stock"),
              )
            : ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  if ((currentProduct.color == null) &&
                      (currentProduct.size == null ||
                          (currentProduct.size?.isEmpty == true))) {
                    //------Add to Cart-------//
                    controller.addToCart(currentProduct,
                        price: currentProduct.price);
                    Get.back();
                  } else {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      builder: (context) {
                        return AddToCart(
                          sizePriceList: currentProduct.size ?? [],
                          imageUrl: currentProduct.photo1,
                          color: currentProduct.color ?? "No Color",
                        );
                      },
                    );
                  }
                },
                child: Text("၀ယ်ယူရန်"),
              ),
      ),
    );
  }
}

class AddToCart extends StatefulWidget {
  final String imageUrl;
  final List<own.Size> sizePriceList;
  final String color;
  const AddToCart({
    Key? key,
    required this.imageUrl,
    required this.sizePriceList,
    required this.color,
  }) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  String? colorValue;
  String? discountPercentage;
  own.Size? sizePrice;
  final HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          //Default Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: 100,
                  height: 100,
                  progressIndicatorBuilder: (context, url, status) {
                    return Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          value: status.progress,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Text(
                sizePrice?.size ?? "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              //
              SizedBox(
                height: widget.sizePriceList.length * 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var element in widget.sizePriceList) ...[
                      Text(
                        "${element.price}",
                        textAlign: sizePrice == element
                            ? TextAlign.right
                            : TextAlign.center,
                        style: TextStyle(
                          decoration: sizePrice == element
                              ? TextDecoration.none
                              : TextDecoration.lineThrough,
                          fontSize: sizePrice == element ? 20 : 12,
                          color: sizePrice == element
                              ? homeIndicatorColor
                              : Colors.black,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          //SizePrice
          SizedBox(
            height: 80,
            child: Wrap(
              children: widget.sizePriceList.map((element) {
                return Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: sizePrice?.id == element.id
                            ? homeIndicatorColor
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      //TODO: CHANGE SIZEPRICE
                      setState(() {
                        sizePrice = element;
                      });
                    },
                    child: Text(
                      element.size,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          //
          // SizedBox(
          //   width: 120,
          //   child: DropdownButtonFormField(
          //     value: colorValue,
          //     hint: Text(
          //       'Color',
          //       style: TextStyle(fontSize: 12),
          //     ),
          //     onChanged: (String? e) {
          //       colorValue = e;
          //     },
          //     items: widget.color
          //         .split(',')
          //         .map((e) => DropdownMenuItem(
          //               value: e,
          //               child: Text(
          //                 e,
          //                 style: TextStyle(fontSize: 12),
          //               ),
          //             ))
          //         .toList(),
          //   ),
          // ),

          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                debugPrint("************PRICE: ${sizePrice!.price}");
                if (!(sizePrice == null)) {
                  controller.addToCart(controller.editItem.value!,
                      color: "",
                      size: [sizePrice!.size, sizePrice!.price],
                      price: int.parse(sizePrice!.price));
                  Get.toNamed(homeScreen);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text("၀ယ်ယူရန်"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
