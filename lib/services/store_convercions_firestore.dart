 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/convercion_model.dart';
import 'package:flutter_firebase/services/store_convercions_storrage.dart';

class StoreConvercionsFirestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //methode to store the conversion data in the firestore
  Future<void> storeConversionData({
    required convercionData,
    required convercionDate,
    required imageFile,
  }) async {

    try{
      //if there is no user id then create a new user as a anonymous user from firebase auth
      if (_firebaseAuth.currentUser == null){
         await _firebaseAuth.signInAnonymously();
      }

      final userId = _firebaseAuth.currentUser!.uid;
      
      //store the image in the storage and get the download url
      final String imageUrl = await StoreConvercionsStorage().uploadImage(convercionImage:imageFile, userId: userId,);

      //create a reference to the collection in the firestore
      CollectionReference convercion = _firebaseFirestore.collection("convercions");

      //data
     final ConvercionModel convercionModel = ConvercionModel(
        userId: userId, 
        convercionData: convercionData, 
        convercionDate: convercionDate, 
        imageUrl: imageUrl
      );

      //store the data in the firestore
      await convercion.add(convercionModel.toJson());
      print("data stored");


    }catch(error){
      print("Error from firestore:$error");
    }
  }
  //Method to get all convercion documents for the current user (stream)
  Stream<List<ConvercionModel>> getUserConvercions()  {

    try{
      final userId = _firebaseAuth.currentUser?.uid;

      if(userId == null) {
        throw Exception('No user is currently signed in.');
      }
      return _firebaseFirestore.collection("convercions").where("userId", isEqualTo:userId).snapshots().map((snapshot){
        return snapshot.docs.map((doc) {
         return ConvercionModel.fromJson(doc.data()); 
        },).toList();
      });
    }catch(error){
      print("Error from stream:$error");
      return Stream.empty();
    }
  }
 }