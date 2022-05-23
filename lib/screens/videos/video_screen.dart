import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorials'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (kIsWeb)
                Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () {
                        loadVideosWeb();
                      },
                      child: const Text('Add Video')),
                ),
              if (kIsWeb)
                const SizedBox(
                  height: 10,
                ),
              StreamBuilder(
                  stream: videoRepo.getAllVideosStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot qs = snapshot.data as QuerySnapshot;
                      // print(snapshot);
                      if (qs.docs.isNotEmpty) {
                        return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: kIsWeb ? 6 : 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: kIsWeb ? 300 : 220),
                            itemCount: qs.docs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: GridTile(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: const [
                                      // ClipOval(
                                      //   child: Container(
                                      //       height: 100,
                                      //       width: 100,
                                      //       color: Colors.blueGrey.shade100,
                                      //       child: _product.productPhoto !=
                                      //                   null &&
                                      //               _product.productPhoto!
                                      //                   .isNotEmpty
                                      //           ? CachedNetworkImage(
                                      //               imageUrl:
                                      //                   _product.productPhoto!,
                                      //             )
                                      //           : const Icon(
                                      //               Icons.shopping_bag_outlined,
                                      //             )),
                                      // ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // Text(_product.title!),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // if(kIsWeb)
                                      // Text(_product.articleId!),
                                      // if(kIsWeb)
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // Text('Rs. ${_product.price!}'),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // if(kIsWeb)
                                      // Text('Remaining: ${_product.quantity!}'),
                                      // if(kIsWeb)
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // ElevatedButton(
                                      //     onPressed: () {

                                      //     },
                                      //     child: Center(
                                      //       child: Text(kIsWeb
                                      //           ? 'Edit'
                                      //           : _product.quantity! < 1
                                      //               ? 'Out of stock'
                                      //               : 'Add to cart'),
                                      //     ))
                                    ],
                                  ),
                                )),
                              );
                            });
                      } else {
                        print('emtyyyyyy');
                        return SizedBox(
                          height: constraints.maxHeight - 80,
                          child: const Center(
                            child: Text('Sorry! No Video availabe right now'),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                        child: Text('Sorry! Error occured'),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        );
      }),
    );
  }
}
