// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:women_safety_app/models/product.dart';

class ProductRepo {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllProductsStream() {
    return _firestore.collection('products').snapshots();
  }

  Future<bool> addNewProduct(StoreProduct product) async {
    print('-------- add new product function ---------');
    DocumentReference docRef = _firestore.collection('products').doc();

    return await _firestore.collection('products').doc(docRef.id).set(product.toJson(), SetOptions(merge: true))
        .then((value) {
      print('-------- product added ---------');
      return true;
    }).catchError((e, s) {
      print('-------- product not added ---------');
      print(e);
      print(s);
      return false;
    });
  }

  Future<String> uploadPicture(Uint8List file,) async {
    // PickedFile pickedFile = file;
    // Uint8List imageFile = await pickedFile.readAsBytes();
    Random random = Random();
    String currPath = 'public/images/products/${random.nextInt(10000)}/';
    Reference storageRef = FirebaseStorage.instance.ref().child(currPath);
    final UploadTask uploadTask =
        storageRef.child('profilePhoto').putData(file);
    // uploadTask.snapshotEvents.forEach((element) {

    // });

    // String newURL;

    return await uploadTask.whenComplete(() {}).then((value) async {
      String newURL = await value.ref.getDownloadURL();
      print('--------- newUrl ------> $newURL');
      Fluttertoast.showToast(msg: 'Profile Photo Upload Completed');
      return newURL;
    }).catchError((e, s) {
      print(e);
      print(s);
      return '';
    });
  }
}
