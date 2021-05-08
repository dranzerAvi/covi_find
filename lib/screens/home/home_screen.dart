import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covi_find/components/default_button.dart';
import 'package:covi_find/models/Requirement.dart';
import 'package:covi_find/services/authentification/authentification_service.dart';
import 'package:covi_find/services/database/user_database_helper.dart';
import 'package:flutter/material.dart';

import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../../utils.dart';

PersistentTabController _controllerTab =
    PersistentTabController(initialIndex: 0);

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> getall = [];
  bool showIndicator = false;
  bool dataLoaded = false;
  int index, length2;
  TextEditingController quantityController = TextEditingController();
  void alldata2(BuildContext ctx) async {
    // final ProgressDialog pr = await ProgressDialog(ctx);
    // pr.style(
    //     message: 'Loading...',
    //     backgroundColor: Colors.white,
    //     progressWidget: GFLoader(
    //       type: GFLoaderType.ios,
    //     ),
    //     elevation: 10.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     progress: 0.0,
    //     maxProgress: 100.0,
    //     progressTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    //     messageTextStyle: TextStyle(
    //         color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    // await pr.show();
    // setState(() {
    //   showIndicator = true;
    // });

    cities.clear();
    await cities.add('All Cities');

    await Firestore.instance.collection('Cities').snapshots().listen((event) {
      for (int i = 0; i < event.documents.length; i++) {
        print('%%%%${event.documents[i]['cityName']}');
        cities.add(event.documents[i]['cityName']);
        if (i == event.documents.length - 1) cities.add('Other');
      }
    });

    setState(() {
      // showIndicator = false;
      dataLoaded = true;
    });
    // await pr.hide();
  }

  String city = 'All Cities';
  String addCitySelected = 'All Cities';
  String required = 'Injection';
  String addRequiredSelected = 'Injection';
  List<String> cities = List();
  @override
  void initState() {
    alldata2(context);
    UserDatabaseHelper().reqList;
    quantity = new TextEditingController();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController quantity;
  TextEditingController notes = new TextEditingController();

  TextEditingController pName = new TextEditingController();
  TextEditingController hospital = new TextEditingController();
  TextEditingController pNumber = new TextEditingController();
  TextEditingController address = new TextEditingController();
  List<Requirement> raisedRequirements = List<Requirement>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                showSignOutDialog(context, 'Do you want to sign out?');
              },
            )
          ],
          backgroundColor: kPrimaryColor,
          title: Text(
            'Requirements',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontFamily: 'Muli'),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      dataLoaded == true
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: DropdownButtonHideUnderline(
                                child: new DropdownButtonFormField<String>(
                                  validator: (value) =>
                                      value == null ? 'field required' : null,
                                  hint: Text('City'),
                                  value: city,
                                  items: cities.map((String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      city = newValue;
                                    });
                                  },
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: DropdownButtonHideUnderline(
                          child: new DropdownButtonFormField<String>(
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            hint: Text('Injection'),
                            value: required,
                            items: [
                              DropdownMenuItem<String>(
                                value: 'Injection',
                                child: new Text('Injection'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Plasma',
                                child: new Text('Plasma'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Oxygen',
                                child: new Text('Oxygen'),
                              )
                            ],
                            onChanged: (String newValue) {
                              setState(() {
                                required = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: DefaultButton(
                    press: () async {
                      List<String> tempCities = await cities;

                      await _scaffoldkey.currentState
                          .showBottomSheet<void>((BuildContext context) {
                        return StatefulBuilder(
                            builder: (BuildContext context, StateSetter state) {
                          return Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 30.0, // soften the shadow
                                    spreadRadius: 3.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      0.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 40),
                            padding: EdgeInsets.all(15),
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                dataLoaded == true
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: DropdownButtonHideUnderline(
                                          child: new DropdownButtonFormField<
                                              String>(
                                            validator: (value) => value == null
                                                ? 'field required'
                                                : null,
                                            hint: Text('City'),
                                            value: addCitySelected,
                                            items:
                                                tempCities.map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                addCitySelected = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: DropdownButtonHideUnderline(
                                    child: new DropdownButtonFormField<String>(
                                      validator: (value) => value == null
                                          ? 'field required'
                                          : null,
                                      hint: Text('Injection'),
                                      value: addRequiredSelected,
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: 'Injection',
                                          child: new Text('Injection'),
                                        ),
                                        DropdownMenuItem<String>(
                                          value: 'Plasma',
                                          child: new Text('Plasma'),
                                        ),
                                        DropdownMenuItem<String>(
                                          value: 'Oxygen',
                                          child: new Text('Oxygen'),
                                        )
                                      ],
                                      onChanged: (String newValue) {
                                        setState(() {
                                          addRequiredSelected = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Container(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.75,
                                //   child: TextFormField(
                                //     controller: quantity,
                                //     decoration: InputDecoration(
                                //       labelText: "City *",
                                //       enabled: addCitySelected == 'Other'
                                //           ? true
                                //           : false,
                                //       floatingLabelBehavior:
                                //           FloatingLabelBehavior.always,
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextFormField(
                                    controller: quantity,
                                    decoration: InputDecoration(
                                      labelText: "Quantity *",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextFormField(
                                    controller: pName,
                                    decoration: InputDecoration(
                                      labelText: "Patient Name *",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextFormField(
                                    controller: hospital,
                                    decoration: InputDecoration(
                                      labelText: "Hospital",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextFormField(
                                    controller: pNumber,
                                    decoration: InputDecoration(
                                      labelText: "Phone Number *",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextFormField(
                                    controller: address,
                                    decoration: InputDecoration(
                                      labelText: "Address",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextFormField(
                                    controller: notes,
                                    decoration: InputDecoration(
                                      labelText: "Additional Info",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                DefaultButton(
                                  press: () async {
                                    print("Raising Requirement");
                                    String userID =
                                        await AuthentificationService()
                                            .currentUser
                                            .uid;
                                    String username;
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(userID)
                                        .get()
                                        .then((value) {
                                      username = value.data()['name'];
                                    });
                                    // print(userName);
                                    Timestamp stamp = Timestamp.now();
                                    UserDatabaseHelper()
                                        .addRequirementForCurrentUser(
                                            Requirement(
                                                id: '',
                                                userName: username,
                                                raisedTime: stamp,
                                                userID:
                                                    AuthentificationService()
                                                        .currentUser
                                                        .uid,
                                                name: pName.text,
                                                quantity: quantity.text,
                                                address: address.text,
                                                item: addRequiredSelected,
                                                city: addCitySelected,
                                                hospitalAdmittedIn:
                                                    hospital.text,
                                                phoneNumber: pNumber.text,
                                                additionalInfo: notes.text),
                                            stamp);
                                    quantity.clear();
                                    pNumber.clear();
                                    pName.clear();
                                    hospital.clear();
                                    address.clear();
                                    notes.clear();
                                    Navigator.pop(context);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          Text('Requirement has been raised.'),
                                    ));
                                  },
                                  color: Colors.red,
                                  text: 'Done',
                                ),
                              ],
                            ),
                          );
                        });
                        // ignore: unnecessary_statements
                      });
                    },
                    text: 'Raise Requirement',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('RaisedReq')
                        .snapshots(),
                    builder:
                        (BuildContext context, AsyncSnapshot<dynamic> snap) {
                      if (snap.hasData && !snap.hasError && snap.data != null) {
                        // snap.data.documents.forEach((doc) {
                        //   print(doc);
                        //   raisedRequirements
                        //       .add(Requirement.fromMap(doc.data(), id: doc.id));
                        // });
                        // print(snap.data.documents);
                        UserDatabaseHelper()
                            .allReqList(required, city)
                            .then((value) {
                          setState(() {
                            raisedRequirements = value;
                          });
                        });
                      }

                      return raisedRequirements.length != 0
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: ListView.builder(
                                  itemCount: raisedRequirements.length,
                                  itemBuilder: (BuildContext context, int j) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Card(
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Raised on ${raisedRequirements[j].raisedTime.toDate().day.toString()}/${raisedRequirements[j].raisedTime.toDate().month.toString()}/21'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: Container(
                                                  height: 1,
                                                  width: double.infinity,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                  'Raised by: ${raisedRequirements[j].userName}'),
                                              Text(
                                                  'Need ${raisedRequirements[j].quantity} units ${raisedRequirements[j].item} '),
                                              Text(
                                                  'Patient Name: ${raisedRequirements[j].name}'),
                                              raisedRequirements[j]
                                                          .hospitalAdmittedIn !=
                                                      'N/A'
                                                  ? Text(
                                                      'Hospital: ${raisedRequirements[j].hospitalAdmittedIn}')
                                                  : null,
                                              Text(
                                                  'Phone Number: ${raisedRequirements[j].phoneNumber}'),
                                              raisedRequirements[j].address !=
                                                      'N/A'
                                                  ? Text(
                                                      'Address: ${raisedRequirements[j].address}')
                                                  : null,
                                              raisedRequirements[j]
                                                          .additionalInfo !=
                                                      'N/A'
                                                  ? Text(
                                                      'Notes: ${raisedRequirements[j].additionalInfo}')
                                                  : null
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(child: Text('No Requirements')),
                            );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }

  DateTime date;
  DateTime selectedDate = DateTime.now();
  List<Map> items = List();
  _pickTime() async {
    var today = DateTime.now();
    DateTime t = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year + 1, today.month, today.day),
      firstDate: DateTime(today.year, DateTime.now().month, today.day),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (t != null)
      setState(() {
        date = t;
      });
    return date;
  }

  _add() {
    if (quantityController.text.length > 0 && selectedDate != null) {
      setState(() {
        items.add({
          // 'id': subcategory,
          'billCopyURL': 'N/A',
          // 'itemID': subcategory,
          'po': 'N/A',
          'qty': quantityController.text,
          'receivedQty': 'N/A',
          'status': 'Pending',
          'supplier': 'N/A',
          'weightSlipURL': 'N/A',
          'date': selectedDate,
          'receivedDate': null,
          'received': false,
          'rate': 'N/A',
        });
      });
    }
  }
}
