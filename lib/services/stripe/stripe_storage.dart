

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StripeStorage {
  final FirebaseFirestore _firebaseFirestore =FirebaseFirestore.instance;

  Future<void> storeSubscripitionDetails({
    required String customerId,
    required String email,
    required String userName,
    required String subscriptionId,
    required String paymentStatus,
    required String startDate,
    required String endDate,
    required String planId,
    required String amountPaid,
    required String currency,
    String? paymentMethod,
    String? subscriptionType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? autoRenewal,
    String? cancellationReason,
    String?promoCode,
    Map<String, dynamic>? metadata,
  })async{

    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
  await _firebaseFirestore.collection("PremiumUserData").doc(customerId).set({
    "userId":userId,
    'customerId':customerId,
    'email':email,
    'userName':userName,
    'subscriptionId':subscriptionId,
    'paymentStatus':paymentStatus,
    'startDate':startDate,
    'endDate':endDate,
    'planId':planId,
    'amountPaid':amountPaid,
    'currency':currency,
    'paymentMethod':paymentMethod ?? '',
    'subscriptionType':subscriptionType ?? 'premium',
    'createdAt':createdAt ?? DateTime.now(),
    'updatedAt':updatedAt ?? DateTime.now(),
    'autoRenewal':autoRenewal ?? true,
    'cancellationReason':cancellationReason ?? '',
    'promoCode':promoCode ?? '',
    ' metadata': metadata ?? {},
  });
  print('Subscription details stored successfully');
}  catch (error) {
  print(error);
}

  }
   // check weather the uid is premium
   Future<bool> checkIfPremium() async {
    try {
      final  userId = FirebaseAuth.instance.currentUser!.uid;

       final snapshot = await _firebaseFirestore.collection("PremiumUserData").where("userId", isEqualTo: userId).get();
       return snapshot.docs.isNotEmpty;
    } catch (error)
{
  print(error);
  return false;

   } 
  } 
}