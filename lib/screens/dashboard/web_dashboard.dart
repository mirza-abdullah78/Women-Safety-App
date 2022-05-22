// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_web_drwer.dart';
import 'package:women_safety_app/utils/globals.dart';

class WebDashboard extends StatefulWidget {
  final String? userId;
  const WebDashboard({Key? key, this.userId}) : super(key: key);

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  Widget getTableRow(String name, String phoneNumber, String lastLocation,) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name)),
          Expanded(flex: 2, child: Text(phoneNumber)),
          Expanded(flex: 2, child: Text(lastLocation)),
        ],
      ),
    );
  }

  String getLocationString(Map location) {
    return '${location['street']}, ${location['subLocality']}, ${location['locality']}, ${location['postalCode']}, ${location['country']}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userRepo.getUserStream(widget.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            User currentUser = User.fromJson(snapshot.data!.data()!);
            print(currentUser.toJson());
            return currentUser.isAdmin
                ? Scaffold(
                    // appBar: AppBar(title: Text('Dashboard'),),
                    // drawer: CustomWebDrawer(currentUser: currentUser,),
                    body: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 240,
                              child: CustomWebDrawer(currentUser: currentUser),
                            ),
                            Container(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth - 240,
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Row(
                                  //   children: [
                                  //     Card()
                                  //   ],
                                  // )
                                  const Text('Users',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueGrey),),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: 400,
                                    // padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.baseBackgroundColor,
                                      border: Border.all(
                                          width: 2, color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration:  BoxDecoration(
                                            color: Colors.blueGrey.shade100,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              topRight: Radius.circular(24)
                                            )
                                          ),
                                          
                                          child: getTableRow('Name', 'Phone number',
                                              'Last location'),
                                        ),
                                        StreamBuilder(
                                          stream: userRepo.getAllUserStream(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              QuerySnapshot qs = snapshot.data
                                                  as QuerySnapshot;
                                              // print(snapshot);
                                              if (qs.docs.isNotEmpty) {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                    itemCount: qs.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      print(qs.docs[index]
                                                          .data());
                                                      User _user =
                                                          User.fromJson(qs
                                                                  .docs[index]
                                                                  .data()
                                                              as Map<String,
                                                                  dynamic>);

                                                      return getTableRow(
                                                          _user.firstName! +
                                                              ' ' +
                                                              _user.lastName!,
                                                          _user.phoneNumber!,
                                                          getLocationString(_user
                                                              .lastLocation!));
                                                    });
                                              } else {
                                                print('emtyyyyyy');
                                                return Container();
                                              }
                                            } else if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return const Center(
                                                child: Text('Error'),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : Scaffold(
                    body: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          height: constraints.maxHeight,
                          width: constraints.maxWidth,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 100,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Sorry you are not authorized to use this portal',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Please contact admin. Thank you',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      authRepo.logOut();
                                    },
                                    child: Text(
                                      'Log out',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Error loading user')
                  ],
                ),
              ),
            );
          }
        });
  }
}
