import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covi_find/models/Availability.dart';
import 'package:covi_find/models/Requirement.dart';
import 'package:covi_find/services/authentification/authentification_service.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "Users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";

  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "display_picture";
  static const String FAV_PRODUCTS_KEY = "favourite_products";

  UserDatabaseHelper._privateConstructor();
  static UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<void> createNewUser(String uid, phoneNumber, displayName) async {
    await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(AuthentificationService().currentUser.uid)
        .set({
      'email': AuthentificationService().currentUser.email,
      'phone': phoneNumber,
      'name': displayName,
    });
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
    final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
    final ordersCollectionRef =
        docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);

    final cartDocs = await cartCollectionRef.get();
    for (final cartDoc in cartDocs.docs) {
      await cartCollectionRef.doc(cartDoc.id).delete();
    }
    final addressesDocs = await addressCollectionRef.get();
    for (final addressDoc in addressesDocs.docs) {
      await addressCollectionRef.doc(addressDoc.id).delete();
    }
    final ordersDoc = await ordersCollectionRef.get();
    for (final orderDoc in ordersDoc.docs) {
      await ordersCollectionRef.doc(orderDoc.id).delete();
    }

    await docRef.delete();
  }

  Future<bool> isProductFavourite(String productId) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
    if (favList.contains(productId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List> get usersFavouriteProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = userDocData[FAV_PRODUCTS_KEY];
    return favList;
  }

  Future<bool> switchProductFavouriteStatus(
      String productId, bool newState) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);

    if (newState == true) {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
      });
    } else {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
      });
    }
    return true;
  }

  Future<List<String>> get addressesList async {
    String uid = AuthentificationService().currentUser.uid;
    final snapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(ADDRESSES_COLLECTION_NAME)
        .get();
    final addresses = List<String>();
    snapshot.docs.forEach((doc) {
      addresses.add(doc.id);
    });

    return addresses;
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  Future<bool> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
    return true;
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {DP_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
        await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()[DP_KEY];
  }

//N
  Future<bool> addAvailabilityForCurrentUser(
      Availability availability, time) async {
    String uid = AuthentificationService().currentUser.uid;
    final availabilityCollectionReference =
        firestore.collection('Users').doc(uid).collection('Availabilities');
    await availabilityCollectionReference.add(availability.toMap());

    return true;
  }

  Future<bool> addRequirementForCurrentUser(
      Requirement requirement, time) async {
    String uid = AuthentificationService().currentUser.uid;
    final reqCollectionReference =
        firestore.collection('Users').doc(uid).collection('RaisedReq');
    await reqCollectionReference.add(requirement.toMap());

    return true;
  }

  Future<Requirement> getReqFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final doc = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection('RaisedReq')
        .doc(id)
        .get();
    final req = Requirement.fromMap(doc.data(), id: doc.id);
    return req;
  }

  Future<List<Requirement>> get reqList async {
    String uid = AuthentificationService().currentUser.uid;
    final snapshot = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection('RaisedReq')
        .orderBy('raiseTime', descending: true)
        .get();
    final req = List<Requirement>();
    snapshot.docs.forEach((doc) {
      if (doc.data()["Items"].length != 0)
        req.add(Requirement.fromMap(doc.data(), id: doc.id));
    });
    return req;
  }

  Future<List<Availability>> allAvailabilitiesList(
      String type, String city) async {
    final req = List<Availability>();
    if (city == 'All Cities') {
      final snapshot = await firestore
          .collectionGroup('Availabilities')
          .where('item', isEqualTo: type)
          // .orderBy('raiseTime', descending: true)
          .get();

      snapshot.docs.forEach((doc) {
        req.add(Availability.fromMap(doc.data(), id: doc.id));
      });
    } else {
      final snapshot = await firestore
          .collectionGroup('Availabilities')
          .where('item', isEqualTo: type)
          .where('city', isEqualTo: city)
          // .orderBy('raiseTime', descending: true)
          .get();

      snapshot.docs.forEach((doc) {
        req.add(Availability.fromMap(doc.data(), id: doc.id));
      });
    }

    return req;
  }

  Future<List<Requirement>> allReqList(String type, String city) async {
    final req = List<Requirement>();
    if (city == 'All Cities') {
      final snapshot = await firestore
          .collectionGroup('RaisedReq')
          .where('item', isEqualTo: type)
          // .orderBy('raiseTime', descending: false)
          .get();

      snapshot.docs.forEach((doc) {
        req.add(Requirement.fromMap(doc.data(), id: doc.id));
      });
    } else {
      final snapshot = await firestore
          .collectionGroup('RaisedReq')
          .where('item', isEqualTo: type)
          .where('city', isEqualTo: city)
          // .orderBy('raiseTime', descending: true)
          .get();

      snapshot.docs.forEach((doc) {
        req.add(Requirement.fromMap(doc.data(), id: doc.id));
      });
    }

    return req;
  }
}
