import 'package:firebase_storage/firebase_storage.dart';

 class StoreConvercionsStorage {

  //Firebase storage instance
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // upload image
  Future<String> uploadImage({
    required convercionImage,
    required userId,

  })async{
    //storage ref

   Reference ref =  _firebaseStorage
         .ref()
         .child("conversion")
         .child("$userId/${DateTime.now()}");

     try{

     UploadTask task = ref.putFile(convercionImage, SettableMetadata(contentType: 'image/jpeg'),); 

     TaskSnapshot snapshot = await task;
     String url = await snapshot.ref.getDownloadURL();

     return url;

     }catch(error){
      print("Storage service:$error");
      return "";
     }    
  }
 }