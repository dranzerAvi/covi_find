import 'package:cloud_firestore/cloud_firestore.dart';

import 'Model.dart';

class Availability extends Model {
  Timestamp raisedTime;

  String userID;
  String userName;

  String price;
  String city;
  String item;
  String quantity;
  String address;
  // String hospitalAdmittedIn;
  String phoneNumber;
  String additionalInfo;

  Availability(
      {String id,
      this.raisedTime,
      this.userID,
      this.userName,
      this.city,
      this.price,
      this.quantity,
      this.address,
      // this.hospitalAdmittedIn,
      this.phoneNumber,
      this.item,
      this.additionalInfo})
      : super(id);

  factory Availability.fromMap(Map<String, dynamic> map, {String id}) {
    return Availability(
      id: id,
      raisedTime: map['raisedTime'],
      userID: map['userID'],
      userName: map['userName'],
      price: map['price'],
      quantity: map['quantity'],
      address: map['address'],
      city: map['city'],
      // hospitalAdmittedIn: map['hospitalAdmittedIn'],
      phoneNumber: map['phoneNumber'],
      item: map['item'],
      additionalInfo: map['additionalInfo'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'raisedTime': raisedTime,
      'userID': userID,
      'userName': userName,
      'price': price,
      'city': city,
      'quantity': quantity,
      'address': address,
      'item': item,
      // 'hospitalAdmittedIn': hospitalAdmittedIn,
      'phoneNumber': phoneNumber,
      'additionalInfo': additionalInfo
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};

    if (raisedTime != null) map['raisedTime'] = raisedTime;
    if (item != null) map['item'] = item;

    if (userID != null) map['userID'] = userID;
    if (userName != null) map['userName'] = userName;
    if (price != null) map['name'] = price;
    if (quantity != null) map['quantity'] = quantity;
    if (address != null) map['address'] = address;
    // if (hospitalAdmittedIn != null)
    //   map['hospitalAdmittedIn'] = hospitalAdmittedIn;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (additionalInfo != null) map['additionalInfo'] = additionalInfo;
    return map;
  }
}
