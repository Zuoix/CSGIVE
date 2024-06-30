import 'dart:convert';

import 'package:cs_give/controller/donation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/common.dart';
import '../../env.dart';


class StripePaymentHandle {
  Map<String, dynamic>? paymentIntent;


  Future<void> stripeMakePayment(String amount, String currency) async {
    final userEmail = getStringAsync(LocalKeys.kUserEmail);
    try {
      paymentIntent = await createPaymentIntent(amount, currency);
      var customer = await createCustomer(userEmail); // Create Stripe Customer
      if (customer == null || customer['id'] == null) {
        throw Exception('Failed to create customer');
      }
      var ephemeralKey = await createEphemeralKey(customer['id']); // Create Ephemeral Key
      if (ephemeralKey == null || ephemeralKey['secret'] == null) {
        throw Exception('Failed to create ephemeral key');
      }
      var setupIntent = await createSetupIntent(customer['id']); // Create SetupIntent with customer ID
      if (setupIntent == null) {
        throw Exception('Failed to create SetupIntent');
      }

      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: BillingDetails(
                  email: userEmail,
              ),
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              setupIntentClientSecret: setupIntent['client_secret'],
              style: ThemeMode.dark,
              customerId: customer['id'], // Customer ID
              customerEphemeralKeySecret: ephemeralKey['secret'],
              merchantDisplayName: 'CS Give'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
     // Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<Map<String, dynamic>?> createEphemeralKey(String customerId) async {
    try {
      var response = await post(
        Uri.parse('https://us-central1-csgive-360fc.cloudfunctions.net/createEphemeralKey'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'customer_id': customerId,
          'api_version': '2022-11-15' // Use the Stripe API version you are using
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to create ephemeral key: ${response.body}');
        showError('Failed to create ephemeral key: ${response.body}');
        return null;
      }
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error creating ephemeral key: $err');
      return null;
    }
  }


  Future<Map<String, dynamic>?> createCustomer(String email) async {
    try {
      var response = await post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization': 'Bearer ${getSecretKey()}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'email': email,
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to create customer: ${response.body}');
        showError('Failed to create customer: ${response.body}');
        return null;
      }
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error creating customer: $err');
      return null;
    }
  }
  displayPaymentSheet() async {

    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();// Call updatePaymentStatus here
        String status = 'COMPLETED';
        String data = json.encode(paymentIntent);
        String statusMessage = 'completed';

        var donationController = Get.find<DonationController>();
      if (donationController.donationRef == null) {
        throw Exception('Donation reference is not set');
      }
        bool isUpdated = await donationController.updatePaymentStatus(donationController.donationRef, status, data, statusMessage);
        if (isUpdated) {
          await donationController.checkPaymentStatus(donationController.donationRef);
        } else {
          Fluttertoast.showToast(msg: 'Payment completed but failed to update status');
        }

    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

  // Inside createPaymentIntent method in StripePaymentHandle class
  Future<Map<String, dynamic>?> createACHPaymentIntent(String amount, String currency) async {
    try {
      // Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': ['ach_credit_transfer'],
      };
      var response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${getSecretKey()}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error creating payment intent: $err');
      return null;
    }
  }
  Future<Map<String, dynamic>?> createSetupIntent(String customerId) async {
    try {
      var response = await post(
        Uri.parse('https://api.stripe.com/v1/setup_intents'),
        headers: {
          'Authorization': 'Bearer ${getSecretKey()}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'customer': customerId,
        },
      );
      return json.decode(response.body);
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error creating setup intent: $err');
      return null;
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };
      var response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${getSecretKey()}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      //throw Exception(err.toString());
      Fluttertoast.showToast(msg: 'Error creating ACH payment intent: $err');
      return null;
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
