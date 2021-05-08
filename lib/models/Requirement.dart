import 'package:cloud_firestore/cloud_firestore.dart';

import 'Model.dart';

class Requirement extends Model {
  Timestamp raisedTime;

  String userID;
  String userName;

  String name;
  String city;
  String item;
  String quantity;
  String address;
  String hospitalAdmittedIn;
  String phoneNumber;
  String additionalInfo;

  Requirement(
      {String id,
      this.raisedTime,
      this.userID,
      this.userName,
      this.city,
      this.name,
      this.quantity,
      this.address,
      this.hospitalAdmittedIn,
      this.phoneNumber,
      this.item,
      this.additionalInfo})
      : super(id);

  factory Requirement.fromMap(Map<String, dynamic> map, {String id}) {
    return Requirement(
      id: id,
      raisedTime: map['raisedTime'],
      userID: map['userID'],
      userName: map['userName'],
      name: map['name'],
      quantity: map['quantity'],
      address: map['address'],
      city: map['city'],
      hospitalAdmittedIn: map['hospitalAdmittedIn'],
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
      'name': name,
      'city': city,
      'quantity': quantity,
      'address': address,
      'item': item,
      'hospitalAdmittedIn': hospitalAdmittedIn,
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
    if (name != null) map['name'] = name;
    if (quantity != null) map['quantity'] = quantity;
    if (address != null) map['address'] = address;
    if (hospitalAdmittedIn != null)
      map['hospitalAdmittedIn'] = hospitalAdmittedIn;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (additionalInfo != null) map['additionalInfo'] = additionalInfo;
    return map;
  }
}
