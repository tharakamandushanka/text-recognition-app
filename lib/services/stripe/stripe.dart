import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/stripe/stripe_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'stripe_api_services.dart';
// init methode 

Future <void> init({required String name ,required String email,
}) async{
  // create new customer
  Map<String ,dynamic>? customer = await CreateCustomer(email: email, name: name);

  if (customer == null || customer["id"] == null) {
    throw Exception('Faild to create customer');
  }

// Create a payment intent
Map<String, dynamic>? paymentIntent =await createPaymentIntent(
  customerId: customer["id"],
  );
  if(paymentIntent == null || paymentIntent["client_secret"] == null){
    throw Exception('Faild to create payment intent');
  }

  // Create a credit card
  await crateCreditCard(
    customerId: customer["id"],
    clientSecret: paymentIntent["client_secret"],

  );

  //Retrieve customer payment methods

  Map<String, dynamic>? CustomerPaymentMethodes =
  await getCustomerPaymentMethodes(
    customerId: customer["id"],
    );
    if(CustomerPaymentMethodes == null ||
    CustomerPaymentMethodes['data'].isEmpty){
      throw Exception('Faild to get customer payment methods.');
    }

  // create subscription  
  Map<String, dynamic>? subscription = await createSubscription(
    customerId:customer["id"], 
    paymentId: CustomerPaymentMethodes["data"][0]["id"],
    );
    if(subscription == null || subscription['id'] == null){
      throw Exception('Faild to create subcription.');
    }
    // store the data in firestore
    StripeStorage().storeSubscripitionDetails(
      customerId: customer["id"], 
      email: email, 
      userName: name, 
      subscriptionId: subscription["id"], 
      paymentStatus: "active", 
      startDate: DateTime.now().toString(), 
      endDate:  DateTime.now().add(const Duration(days: 30)).toString(), 
      planId: "price_1Q3CDKP3nqIH8laymVsk47M1", 
      amountPaid: "4.99", 
      currency: "USD",
      paymentMethod: "Credit Card"
    );

   

}

// create customer
Future<Map<String ,dynamic>?> CreateCustomer({
  required String email,
  required String name,
}) async {
  final customerCreatingResponce = await stripeApiService(
    requestMethode: ApiServiceMethodeType.post,
    endpoint: "customers",
    requestBody: {
      "name":name,
      "email":email,
      "description": 'Text Extractor Pro Plan',
    },
   

  );
  return customerCreatingResponce;
}

// Create payment intent 
Future<Map<String, dynamic>?> createPaymentIntent(
  {required String customerId,}
)async{
  final paymentIntentCreationResponce = await stripeApiService(
    requestMethode: ApiServiceMethodeType.post, 
    requestBody:{
      'customer':customerId,
    'automatic_payment_methods[enabled]':'true'
    }, 
    endpoint: "setup_intents",);
    return paymentIntentCreationResponce;
}

// create credit card
Future<void> crateCreditCard({
  required String customerId,
  required String clientSecret,
})async {
  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters:SetupPaymentSheetParameters(
      primaryButtonLabel: 'Subscribe \$4.99 monthly',
      style: ThemeMode.light,
      merchantDisplayName: 'Text Extractor Pro Plan',
      customerId:customerId,
      setupIntentClientSecret: clientSecret,
    ),);
    await Stripe.instance.presentPaymentSheet();
}

 //get customer payment methods
 Future<Map<String, dynamic>?> getCustomerPaymentMethodes({
  required String customerId,
 }) async{
  final customerPaymentMethodsResponse = await stripeApiService(
    requestMethode: ApiServiceMethodeType.get,
    endpoint: 'customers/$customerId/payment_methods', 
    );
    return customerPaymentMethodsResponse;
 }

 //create subscription
  Future<Map<String, dynamic>?> createSubscription({
    required String customerId,
    required String paymentId,
  })async{
    final subscriptionCreationResponse = await stripeApiService(
      requestMethode: ApiServiceMethodeType.post, 
      requestBody: {
        'customer':customerId,
        'default_payment_method':paymentId,
        'items[0][price]':"price_1Q3CDKP3nqIH8laymVsk47M1",
      }, 
      endpoint: "subscriptions");
      return subscriptionCreationResponse;
  }

