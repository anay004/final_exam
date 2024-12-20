import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import 'api service/api.dart';
import 'model/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  //get all products from server
  Future<List<Product>> getAllProducts() async {
    List<Product> productList = [];

    try {
      final url = Uri.parse(Api.getAllProducts);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        for (var eachRecord in (responseData as List)) {
          productList.add(Product.fromJson(eachRecord));
        }
      } else {
        Fluttertoast.showToast(msg: "error");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "error");
    }

    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text(
            'Product List',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: FutureBuilder(
        future: getAllProducts(),
        builder: (context, AsyncSnapshot<List<Product>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return Center(
              child: Text(
                "Empty. No data found!",
              ),
            );
          }
          if (dataSnapShot.data!.isNotEmpty) {
            return GridView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true, // Allow GridView to be shrinkable
              physics: const AlwaysScrollableScrollPhysics(), // Use this for scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 1.8,
              ),
              itemBuilder: (context, index) {
                Product eachProduct = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: () {
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 2,
                          color: Colors.blueGrey,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0))),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: eachProduct.image!,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fadeInDuration: const Duration(milliseconds: 500),
                                  fadeOutDuration: const Duration(milliseconds: 200),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 8),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          eachProduct.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          "Tk " + eachProduct.price.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("empty_no_data_found"),
            );
          }
        },
      ),
    );
  }


}
