import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/utils/globals.dart';

class ManageOrdersScreen extends StatefulWidget {
  ManageOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  bool isLoading = false;

  Widget getTableRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                'Phone Number',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'Delivery',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'Status',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey),
              )),
          Expanded(flex: 2, child: Container()),
          Expanded(flex: 2, child: Container()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // getTableRow(),
              const Text(
                'Orders',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              getTableRow(),
              Container(
                color: AppColors.baseBackgroundColor,
                child: StreamBuilder(
                  stream: orderRepo.getAllOrdersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot qs = snapshot.data as QuerySnapshot;
                      // print(snapshot);
                      if (qs.docs.isNotEmpty) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: qs.docs.length,
                            itemBuilder: (context, index) {
                              print(qs.docs[index].data());
                              Order _order = Order.fromJson(qs.docs[index]
                                  .data() as Map<String, dynamic>);

                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(_order.phoneNumber!)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(_order.deliveryAddress!)),
                                    Expanded(
                                        flex: 2, child: Text(_order.status!)),
                                    Expanded(
                                      flex: 2,
                                      child: _order.status == 'inProcess'
                                          ? ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green)),
                                              onPressed: () async{
                                                await orderRepo.updateStatus(
                                                    _order, 'completed');
                                              },
                                              child: !isLoading
                                                  ? const SizedBox(
                                                      width: 400,
                                                      child: Center(
                                                          child: Text(
                                                              'Complete order')))
                                                  : const SizedBox(
                                                      height: 15,
                                                      width: 15,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          : Container(),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _order.status == 'inProcess'
                                          ? ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red)),
                                              onPressed: () async{
                                                await orderRepo.updateStatus(
                                                    _order, 'canceled');
                                              },
                                              child: !isLoading
                                                  ? const SizedBox(
                                                      width: 400,
                                                      child: Center(
                                                          child: Text(
                                                              'Cancel Order')))
                                                  : const SizedBox(
                                                      height: 15,
                                                      width: 15,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          : Container(),
                                    )
                                  ],
                                ),
                              );
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
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
