import 'package:cloud_firestore/cloud_firestore.dart';

class ConvercionModel {
   
   final String userId;
   final String convercionData;
   final DateTime convercionDate;
   final String imageUrl;

  ConvercionModel({
     required this.userId,
     required this.convercionData,
     required this.convercionDate,
     required this.imageUrl
     });
    // json > convercionModel
   factory ConvercionModel.fromJson(Map<String, dynamic> json) {
    return ConvercionModel(
      userId: json["userId"], 
      convercionData: json["convercionData"], 
      convercionDate: (json["convercionDate"] as Timestamp).toDate(), 
      imageUrl: json["imageUrl"],
    );
   }   

  //convercionModel > json
  Map<String, dynamic> toJson(){
    return {
     "userId":userId,
     "convercionData":convercionData,
     "convercionDate":convercionDate,
     "imageUrl":imageUrl,

    };
  }
}