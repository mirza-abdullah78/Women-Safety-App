import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class NewProductForm extends StatefulWidget {
  StoreProduct? product;
  bool isEditForm;
  NewProductForm({Key? key, this.product, this.isEditForm = false})
      : super(key: key);

  @override
  State<NewProductForm> createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  StoreProduct? product;
  StoreProduct? newProduct;
  String? articleId, category, title, photo;
  int? quantity;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    product = widget.product;
    newProduct = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 700,
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            StatefulBuilder(builder: (context, setBodyState) {
              return Container(
                height: 150,
                width: 150,
                alignment: Alignment.center,
                child: newProduct?.productPhoto != null &&
                        newProduct!.productPhoto != ''
                    ? InkWell(
                        onTap: () {
                          loadAssetsWeb();
                        },
                        child: ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                              imageUrl: newProduct!.productPhoto!,
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          // loadAssets();
                          String? url = await loadAssetsWeb();
                          print('-------- url -------->>> $url');
                          if (url != null && url.isNotEmpty) {
                            setBodyState(() {
                              newProduct!.productPhoto = url;
                              photo = url;
                            });
                          }
                        },
                        child: ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: AppColors.boxHighlight,
                            ),
                            child: Center(
                              child: Stack(
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 80,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      // margin: EdgeInsets.only(bottom: 9),
                                      decoration: const BoxDecoration(
                                        // borderRadius: BorderRadius.only(
                                        //   bottomLeft: Radius.circular(40),
                                        //   bottomRight: Radius.circular(40),
                                        // ),
                                        color: AppColors.primaryColor,
                                      ),
                                      // alignment: Alignment.bottomCenter,
                                      child: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.white,
                                      ),

                                      height: 30,
                                      width: 100,
                                    ),
                                  ),
                                  // Align(
                                  //     alignment: Alignment.bottomCenter,
                                  //     child: Container(
                                  //       height: 20,
                                  //       color: Colors.white,
                                  //       alignment: Alignment.bottomCenter,
                                  //       child: Text('ADD'),
                                  //     ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            }),
            CustomTextField(
              label: 'Article Id',
              hint: 'Enter article id',
              onSaved: (v) {
                if (v != null) {
                  articleId = v.trim();
                }
              },
              onValitdate: (v) {
                if (v == null || v.isEmpty) {
                  return 'Field cannot be null';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              label: 'Title',
              hint: 'Enter article id',
              onSaved: (v) {
                if (v != null) {
                  title = v.trim();
                }
              },
              onValitdate: (v) {
                if (v == null || v.isEmpty) {
                  return 'Field cannot be null';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              label: 'Category',
              hint: 'Enter category',
              onSaved: (v) {
                if (v != null) {
                  category = v.trim();
                }
              },
              onValitdate: (v) {
                if (v == null || v.isEmpty) {
                  return 'Field cannot be null';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              label: 'Quantity',
              hint: 'Enter quantity',
              onSaved: (v) {
                if (v != null) {
                  quantity = int.parse(v.trim());
                }
              },
              onValitdate: (v) {
                if (v == null || v.isEmpty) {
                  return 'Field cannot be null';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  // loginUser();
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    productRepo
                        .addNewProduct(StoreProduct(
                            title, category, articleId, photo, quantity, true))
                        .then((value) {
                      if (value) {
                        showSnackBar(context, 'Image Uploaded');
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    child: const Center(child: Text('Add')),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
