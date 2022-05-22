// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/models/user.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';

class SettingsPage extends StatefulWidget {
  User? user;
  SettingsPage({Key? key, this.user}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Map trusties = {};
  ValueNotifier<Map> trusties = ValueNotifier({});
  ValueNotifier<String> contactNumber = ValueNotifier('');
  Map emergencyNumbers = {};
  User? currentUser;
  GlobalKey<FormState>? formKey;
  GlobalKey<FormState>? trustyFormKey;
  bool isLoading = false;

  @override
  void initState() {
    formKey = GlobalKey();
    trustyFormKey = GlobalKey();
    print('*************** init manage trusties **********');
    currentUser = widget.user;
    if (currentUser?.trusties != null) {
      print('*************** not null **********');
      trusties.value = currentUser!.trusties!;
    }
    if (currentUser?.emergencyContacts != null) {
      print('*************** not null **********');
      emergencyNumbers = currentUser!.emergencyContacts!;
    }
    print('*************** $trusties **********');
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    trusties.notifyListeners();
    super.initState();
  }

  @override
  void dispose() {
    print('*********** dispose **********');
    // trusties.value = [];
    super.dispose();
  }

  showBottomSheet(Map trusty, bool isEditForm) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )),
        builder: (context) {
          String? name, phoneNumber, relation;

          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                  key: trustyFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Trusty',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        initialValue: isEditForm ? trusty['name'] : '',
                        label: 'Name',
                        hint: 'Enter name',
                        onSaved: (v) {
                          if (v != null) {
                            name = v.trim();
                          }
                        },
                        onValitdate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Name cannot be null';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder(
                          valueListenable: contactNumber,
                          builder: (context, number, _) {
                            print('sdjbfkjadbsg');
                            print(number);
                            return CustomTextField(
                              initialValue: contactNumber.value.isNotEmpty
                                  ? contactNumber.value
                                  : isEditForm
                                      ? trusty['phoneNumber']
                                      : '',
                              label: 'Phone Number',
                              hint: 'Enter phone number',
                              trailing: IconButton(
                                onPressed: () async {
                                  final PhoneContact contact =
                                      await FlutterContactPicker
                                              .pickPhoneContact()
                                          .then((value) {
                                    if (value.phoneNumber?.number != null) {
                                      // setContactState(() {
                                      contactNumber.value =
                                          value.phoneNumber!.number!;
                                      contactNumber.notifyListeners();
                                      // });
                                    }
                                    return value;
                                  });

                                  print(contact);
                                },
                                icon: const Icon(
                                  Icons.contact_page,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              onSaved: (v) {
                                if (v != null) {
                                  phoneNumber = v.trim();
                                }
                              },
                              onValitdate: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Phone cannot be null';
                                } else if (v.length < 11) {
                                  return 'Phone number must contains 11 numbers';
                                } else {
                                  return null;
                                }
                              },
                            );
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        initialValue: isEditForm ? trusty['relation'] : '',
                        label: 'Relation',
                        hint: 'Enter relation with this trusty',
                        onSaved: (v) {
                          if (v != null) {
                            relation = v.trim();
                          }
                        },
                        onValitdate: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Relation cannot be null';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                if (trustyFormKey!.currentState!.validate()) {
                                  trustyFormKey!.currentState!.save();
                                  print(trusties.value);
                                  if (isEditForm &&
                                      trusty['phoneNumber'] != phoneNumber) {
                                    trusties.value
                                        .remove(trusty['phoneNumber']);
                                  }

                                  trusties.value[phoneNumber] = {
                                    'name': name,
                                    'phoneNumber': phoneNumber,
                                    'relation': relation
                                  };
                                  print(trusties.value);
                                  trusties.notifyListeners();
                                  Navigator.pop(context);
                                }
                              },
                              child: !isLoading
                                  ? const SizedBox(
                                      width: 400,
                                      child: Center(child: Text('Add')))
                                  : const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          if (isEditForm)
                            SizedBox(
                              width: 5,
                            ),
                          if (isEditForm)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {
                                  trusties.value.remove(trusty['phoneNumber']);
                                  trusties.notifyListeners();
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                    // backgroundColor: Mat
                                    ),
                                child: !isLoading
                                    ? const SizedBox(
                                        width: 400,
                                        child: Center(child: Text('Delete')))
                                    : const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            // trusties.value = [];
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: StatefulBuilder(builder: (context, setBodyState) {
          return ElevatedButton(
            onPressed: () async {
              if (formKey!.currentState!.validate()) {
                formKey!.currentState!.save();
                setBodyState(() {
                  isLoading = true;
                });
                bool response = await userRepo
                    .setTrusties(
                        currentUser!.id!, trusties.value, emergencyNumbers)
                    .then((value) {
                  setBodyState(() {
                    isLoading = false;
                  });
                  return value;
                });
                Fluttertoast.showToast(
                    msg: response ? 'Updated successfully' : 'Failed',
                    backgroundColor: Colors.white,
                    textColor: Colors.blueGrey);
                print(
                    '\n\n ------- trusties -------> ${trusties.value} \n\n\n');
                print(
                    '\n\n ------- emergency numbers -------> $emergencyNumbers \n\n\n');
                setBodyState(() {
                  isLoading = false;
                });
              }
            },
            child: !isLoading
                ? const Text('Save')
                : const SizedBox(
                    height: 15,
                    width: 15,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
          );
        }),
      ),
      body: WillPopScope(
        onWillPop: () {
          // trusties.value = [];
          Navigator.pop(context);
          return Future.delayed(const Duration(milliseconds: 0));
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manage Trusties',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                    valueListenable: trusties,
                    builder: (context, trustiesMap, _) {
                      trustiesMap as Map;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: trustiesMap.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4,
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                trailing: IconButton(
                                    onPressed: () {
                                      showBottomSheet(
                                          trustiesMap[
                                              trustiesMap.keys.toList()[index]],
                                          true);
                                    },
                                    icon: const Icon(Icons.edit)),
                                title: Text(
                                  trustiesMap[trustiesMap.keys.toList()[index]]
                                          ['name']
                                      .toString()
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 16),
                                ),
                              ),
                            );
                          });
                    }),
                ElevatedButton(
                    onPressed: () {
                      print('*************** $trusties **********');
                      // trusties.value.add('');
                      showBottomSheet({}, false);
                      // trusties.notifyListeners();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Add Trusty'),
                      ],
                    )),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manage Emergency Contacts',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          initialValue: emergencyNumbers['police'] ?? '1111',
                          label: 'Police',
                          hint: 'Enter police number',
                          onSaved: (v) {
                            if (v != null) {
                              emergencyNumbers['police'] = v.trim();
                            }
                          },
                          onValitdate: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Number cannot be null';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          initialValue: emergencyNumbers['ambulance'] ?? '1111',
                          label: 'Ambulance',
                          hint: 'Enter ambulance number',
                          onSaved: (v) {
                            if (v != null) {
                              emergencyNumbers['ambulance'] = v.trim();
                            }
                          },
                          onValitdate: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Number cannot be null';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ))
              ],
            ),
          );
        }),
      ),
    );
  }
}
