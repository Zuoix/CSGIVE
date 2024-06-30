import 'dart:convert';

import 'package:cs_give/app.dart';
import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/models/donation_type_data.dart';
import 'package:cs_give/models/request/initpayment_request.dart';
import 'package:cs_give/models/response/initpayment_response.dart';
import 'package:cs_give/models/stock_request.dart';
import 'package:cs_give/screens/home_screen.dart';
import 'package:cs_give/screens/payments/mobile_money_payment.dart';
import 'package:cs_give/screens/payments/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../config/string_config.dart';
import '../models/request/updatepayment_request.dart';
import '../models/response/donationhistory_response.dart';



final donationAmounts = [10, 20, 50, 100, 500, 1000];
final paymentMethods = ['Paypal', 'Card', 'ACH', 'MoMo'];
final frequencies = [
  'One Time',
  'Weekly',
  'Monthly',
  'Semi Annually',
  'Annually'
];

class DonationController extends GetxController {
  WebViewController? controller;

  @override
  void onInit() {
    super.onInit();
    amountCont.addListener(() {
      update();
    });
    getDonationTypes();
    getDonationHistory();
    amountCont.clear();
  }
  final stripePaymentHandle = StripePaymentHandle();
  final amountCont = TextEditingController();
  late TextEditingController paymentController;
  late GlobalKey<FormState> paymentForm;
  Map<String, dynamic>? paymentIntentData;

  String? selectedPaymentMethod;
  String? selectedFrequency;
  DonationType? selectedDonationType;

  List<InitPaymentResponse> donationPayment = [];

  String? donationRef;
  List<DonationType> donationTypes = [];

  List<DonationhistoryResponse> donationHistory = [];
  var donationsThisMonth = <DonationhistoryResponse>[].obs;
  var donationsLastMonth = <DonationhistoryResponse>[].obs;



  @override
  void onClose() {
    amountCont.clear();
    amountCont.dispose();
    super.onClose();
  }
  void resetSelection() {
    amountCont.clear();
    update();
  }

  void chooseAmount(int val) {
    if (amountCont.text == val.toString()) {
      amountCont.clear(); // Unselect the item if it is already selected
    } else {
      amountCont.text = val.toString(); // Select the new item
    }
    update();
  }

  void selectPaymentMethod(String? val) {
    selectedPaymentMethod = val.validate();
    update();
  }

  void selectFrequency(String? val) {
    selectedFrequency = val.validate();
    update();
  }

  void selectDonationType(DonationType? val) {
    if(val != null){
      selectedDonationType = val;
      update();
    }
  }


  void donate() {
    checkLogin(() async {
      final amount = parseCurrency(amountCont.text);


      if (amount <= 0) {
        showError('The amount must be greater than 0');
        return;
      }
      if (selectedPaymentMethod == null) {
        showError('Please select a payment method');
        return;
      }
      if (selectedFrequency == null) {
        showError('Please select a frequency');
        return;
      }

        if (selectedDonationType == null) {
          showError('Please select a donation type');
          return;
        }else if (selectedPaymentMethod == 'Paypal'){
          if(await initPayment()){
            Get.to(() => UsePaypal(
              sandboxMode: true,
              clientId: StringConfig.clientId,
              secretKey: StringConfig.secretKey,
              returnURL: StringConfig.returnURL,
              cancelURL: StringConfig.cancelURL,
              transactions:  [
                {
                  StringConfig.amountText: {
                    StringConfig.totalText: amountCont.text,
                    StringConfig.currency: StringConfig.currencyCode,
                  },
                  StringConfig.des: selectedDonationType?.donationType,
                  StringConfig.itemList: {
                    StringConfig.items: [
                      {
                        StringConfig.name: StringConfig.demoProduct,
                        StringConfig.quantity: 1,
                        StringConfig.price: amountCont.text,
                        StringConfig.currency: StringConfig.currencyCode
                      }
                    ],
                  }
                }
              ],
              note: StringConfig.contactUsFor,
              onSuccess: (Map params) async {
                if (donationRef == null) {
                  throw Exception('Donation reference is not set');
                }

                showError(donationRef!);
                String status = 'COMPLETED';
                String data = json.encode({});
                String statusMessage = 'completed';

                bool isUpdated = await updatePaymentStatus(donationRef, status, data, statusMessage);

                if (isUpdated) {
                  await checkPaymentPaypalStatus(donationRef);
                } else {
                  Fluttertoast.showToast(msg: 'Payment completed but failed to update status');
                }
              },
              onError: (error) {

                showSuccess('paypal error');

              },
              onCancel: (params) {


                showSuccess('paypal cancelled');
              },
            ));
          }
        } else if (selectedPaymentMethod == 'Card')  {
          if(await initPayment()){
            stripePaymentHandle.stripeMakePayment(parseCurrencyString(amountCont.text), "USD");
          }
        }else if (selectedPaymentMethod == 'ACH') {
          final accountNumberController = TextEditingController();
          final routingNumberController = TextEditingController();
          final formKey = GlobalKey<FormState>();

          bool? result = await showDialog<bool>(
            context: Get.context!,
            builder: (context) {
              return ACHDetailsPopup(
                accountNumberController: accountNumberController,
                routingNumberController: routingNumberController,
                formKey: formKey,
              );
            },
          );

          if (result == true) {
            // Proceed with ACH payment using the collected details
            final accountNumber = accountNumberController.text;
            final routingNumber = routingNumberController.text;
            final paymentIntent = await stripePaymentHandle.createACHPaymentIntent(amountCont.text, "USD");
            if (paymentIntent != null && paymentIntent['client_secret'] != null) {
              // Confirm payment intent with ACH payment method
              try {
                /*await Stripe.instance.confirmPayment(paymentIntentClientSecret: paymentIntent['client_secret'], data:
                    PaymentMethodParams.achDebit(
                      accountNumber: accountNumber,
                      routingNumber: routingNumber,
                    ));*/
                // Payment successful
                showSuccess('Payment completed successfully');
              } catch (e) {
                // Payment failed
                Fluttertoast.showToast(msg: 'Error processing ACH payment: $e');
              }
            } else {
              Fluttertoast.showToast(msg: 'Error creating payment intent');
            }

            // Implement your ACH payment logic here using the account number and routing number
            showSuccess('ACH payment initiated successfully.');
          }else {
            showError('Please enter valid ACH details');
          }

        }else if (selectedPaymentMethod == 'MoMo'){
          if(await initPayment()){
            createRequest();
            Get.to(() => const MobileMoneyPayment());
          }
        } else {
          showError('Selected payment method is not supported yet');
        }

    });
  }


  Future<bool> initPayment() async {
    final request = InitPaymentRequest(
      amount: amountCont.text,
      donationType: selectedDonationType!.id.toString(),
      paymentMode: selectedPaymentMethod ?? 'Card',
    );
    var donationPayment = await donationServices.initiatePaymentIntent(request);
    if(donationPayment.paymentUrl.isNotEmpty){
      donationRef = donationPayment.reference;
      update();
      return true;
    }else{
      showError('Could not initialise payment.');
      return false;
    }
  }


  Future<bool> updatePaymentStatus(String? reference, String status, String data, String statusMessage) async {
    if (reference == null) {
      showError('Donation reference is not set');
      return false;
    }
    final request = UpdatePaymentRequest(
      status: status,
      data: data,
      statusMessage: statusMessage,
    );
    var donationPaymentStatus = await donationServices.updatePaymentIntent(request, reference: reference);
    if(donationPaymentStatus.message != "Not found"){
      return true;
    }else{
      showError('Payment not found for update.');
      return false;
    }
  }



  Future<void> checkPaymentStatus(String? reference) async {
    try {
      final status = await donationServices.checkPaymentStatus(reference: reference);
      //removeKey(LocalKeys.kDonateTo);
      if (status.status == 'COMPLETED') {
        controller = null;
        showSuccess('Congratulations! Your payment has been completed.');
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      controller = null;
      Get.back();
    }
  }

  Future<void> checkPaymentPaypalStatus(String? reference) async {
    try {
      final status = await donationServices.checkPaymentStatus(reference: reference);
      //removeKey(LocalKeys.kDonateTo);
      if (status.status == 'COMPLETED') {
        controller = null;
        showSuccess('Congratulations! Your payment has been completed.');
      }
    } catch (e) {
      controller = null;
      Get.back();
    }
  }


  Future<void> getDonationTypes() async {
    donationTypes = await donationServices.getDonationTypes();
    update();
  }


  Future<void> getDonationHistory() async {
    try {
      var donations = await donationServices.getDonationHistory();
      var now = DateTime.now();
      var firstDayOfThisMonth = DateTime(now.year, now.month, 1);
      var firstDayOfLastMonth = (now.month == 1)
          ? DateTime(now.year - 1, 12, 1)
          : DateTime(now.year, now.month - 1, 1);
      var lastDayOfLastMonth = (now.month == 1)
          ? DateTime(now.year - 1, 12, 31)
          : DateTime(now.year, now.month, 0);

      donationsThisMonth.assignAll(donations.where((donation) {
        return donation.createdAt.isAfter(firstDayOfThisMonth) || donation.createdAt.isAtSameMomentAs(firstDayOfThisMonth);
      }).toList());

      donationsLastMonth.assignAll(donations.where((donation) {
        return (donation.createdAt.isAfter(firstDayOfLastMonth) || donation.createdAt.isAtSameMomentAs(firstDayOfLastMonth))
            && donation.createdAt.isBefore(firstDayOfThisMonth);
      }).toList());
      donationHistory.assignAll(donations);

    } catch (e) {
      print("Error fetching donation history: $e");
      showError("$e");
    }
  }

  Future<void> createRequest() async {
    try {
      final request = MobileMoneyRequest(
        depositId: const Uuid().v4(),
        statementDescription: 'Donation', // TODO: Change to Church Name
        returnUrl: ApiRoutes.baseUrl,
        reason: selectedDonationType?.donationType ?? 'Donation',
        amount: amountCont.text,
      );

      final url = await pawaPayServices.createRequest(request);
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              log(request.url);
              if (request.url.contains(ApiRoutes.baseUrl)) {
                _checkDepositStatus(request.url.split('depositId=').last);
              }
              return NavigationDecision.navigate;
            },
          ),
        );
      if (url != null) {
        controller!.loadRequest(Uri.parse(url)).then((value) {
          update();
        });
      }
      update();
    } catch (e) {
      log(e.toString());
      //showError(e.toString());
    }
  }

  Future<void> _checkDepositStatus(String id) async {
    try {
      final status = await pawaPayServices.checkDepositStatus(id);
      removeKey(LocalKeys.kDonateTo);

      if (status != null && status.status == 'COMPLETED') {
        controller = null;
        showSuccess('Congratulations! Your payment has been completed.');
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      controller = null;
      Get.back();
    }
  }
}




class ACHDetailsPopup extends StatelessWidget {
  final TextEditingController accountNumberController;
  final TextEditingController routingNumberController;
  final GlobalKey<FormState> formKey;

  ACHDetailsPopup({
    required this.accountNumberController,
    required this.routingNumberController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ACH Payment Details'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: accountNumberController,
              decoration: InputDecoration(labelText: 'Account Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your account number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: routingNumberController,
              decoration: InputDecoration(labelText: 'Routing Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your routing number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop(true); // Return true to indicate validation success
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
