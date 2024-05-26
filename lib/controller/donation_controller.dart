import 'dart:convert';

import 'package:cs_give/app.dart';
import 'package:cs_give/core/constants/api_routes.dart';
import 'package:cs_give/core/constants/app_constants.dart';
import 'package:cs_give/core/utils/common.dart';
import 'package:cs_give/models/donation_history_data.dart';
import 'package:cs_give/models/donation_type_data.dart';
import 'package:cs_give/models/stock_request.dart';
import 'package:cs_give/screens/home_screen.dart';
import 'package:cs_give/screens/payments/mobile_money_payment.dart';
import 'package:cs_give/screens/payments/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../config/string_config.dart';
import '../env.dart';
import '../models/response/donationhistory_response.dart';
import '../services/paypal_services.dart';

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
  String? selectedDonationType;

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

  void selectDonationType(String? val) {
    selectedDonationType = val.validate();
    update();
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
        UsePaypal(
            sandboxMode: true,
            clientId: StringConfig.clientId,
            secretKey: StringConfig.secretKey,
            returnURL: StringConfig.returnURL,
            cancelURL: StringConfig.cancelURL,
            transactions: const [
              {
                StringConfig.amountText: {
                  StringConfig.totalText: StringConfig.ten,
                  StringConfig.currency: StringConfig.currencyCode,
                  StringConfig.details: {
                    StringConfig.subtotal: StringConfig.ten,
                    StringConfig.shipping: StringConfig.zero,
                    StringConfig.shippingDiscount: 0
                  }
                },
                StringConfig.des:
                StringConfig.thePaymentTransactionDescription,
                StringConfig.itemList: {
                  StringConfig.items: [
                    {
                      StringConfig.name: StringConfig.demoProduct,
                      StringConfig.quantity: 1,
                      StringConfig.price: StringConfig.ten,
                      StringConfig.currency: StringConfig.currencyCode
                    }
                  ],
                  StringConfig.shippingAddress: {
                    StringConfig.recipientName: StringConfig.janeFoster,
                    StringConfig.line1: StringConfig.travisCountry,
                    StringConfig.line2: "",
                    StringConfig.city: StringConfig.austin,
                    StringConfig.countryCode: StringConfig.us,
                    StringConfig.postalCode: StringConfig.postalCodeNo,
                    StringConfig.phone: StringConfig.phoneNo,
                    StringConfig.state: StringConfig.texas
                  },
                }
              }
            ],
            note: StringConfig.contactUsFor,
            onSuccess: (Map params) async {},
            onError: (error) {},
            onCancel: (params) {});
      }else if (selectedPaymentMethod == 'Paypals') {
        try {
          final transactions = {
            "intent": "sale",
            "payer": {"payment_method": "paypal"},
            "transactions": [
              {
                "amount": {"total": amount.toString(), "currency": "USD"},
                "description": "Donation",
              }
            ],
            "redirect_urls": {
              "return_url": ApiRoutes.paypalReturnURL,
              "cancel_url": ApiRoutes.paypalCancelURL,
            },
          };

          final payPalService = PaypalServices();
          final accessToken = await payPalService.getAccessToken();
          if (accessToken != null) {
            final res = await payPalService.createPaypalPayment(transactions, accessToken);
            if (res != null && res['approvalUrl'] != null) {
              controller = WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onNavigationRequest: (NavigationRequest request) {
                      // Handle return URL
                      if (request.url.contains(ApiRoutes.paypalReturnURL)) {
                        final uri = Uri.parse(request.url);
                        final payerId = uri.queryParameters['PayerID'];
                        if (payerId != null) {
                          payPalService.executePayment(res['executeUrl']!, payerId, accessToken).then((paymentId) {
                            if (paymentId != null) {
                              showSuccess('Payment completed successfully');
                              Get.offAll(() => const HomeScreen());
                            } else {
                              showError('Payment failed');
                              Get.back();
                            }
                          });
                        }
                      }
                      // Handle cancel URL
                      else if (request.url.contains(ApiRoutes.paypalCancelURL)) {
                        showError('Payment cancelled');
                        Get.back();
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                );
              // Load the approval URL in WebView
              if (res['approvalUrl'] != null) {
                controller!.loadRequest(Uri.parse(res['approvalUrl']!));
                update();
              }
              //Get.to(() => PayPalWebViewScreen(approvalUrl: res['approvalUrl']!, executeUrl: res['executeUrl']!, accessToken: accessToken));

            } else {
              showError('Failed to create PayPal payment');
            }
          } else {
            showError('Failed to get PayPal access token');
          }
        } catch (e) {
          showError('An error occurred: $e');
        }
      } else if (selectedPaymentMethod == 'Card')  {

        stripePaymentHandle.stripeMakePayment(parseCurrencyString(amountCont.text), "USD");
      } else {
        showError('Selected payment method is not supported yet');
      }
    });
  }


  void donater() {
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
      }

      if (selectedPaymentMethod == 'MoMo') {
        createRequest();
        Get.to(() => const MobileMoneyPayment());
      }else if (selectedPaymentMethod == 'Paypal') {
        final payPalService = PaypalServices();
        final accessToken = await payPalService.getAccessToken();
        if (accessToken != null) {
          final transactions = {
            "intent": "sale",
            "payer": {"payment_method": "paypal"},
            "transactions": [
              {
                "amount": {"total": amount.toString(), "currency": "USD"},
                "description": "Donation",
              }
            ],
            "redirect_urls": {
              "return_url": ApiRoutes.paypalReturnURL,
              "cancel_url": ApiRoutes.paypalCancelURL,
            },
          };

          final res = await payPalService.createPaypalPayment(transactions, accessToken);

          if (res != null) {
            final approvalUrl = res['approvalUrl'];
            final executeUrl = res['executeUrl'];
            print('Approval URL: $approvalUrl'); // Debugging statement
            print('Execute URL: $executeUrl'); // Debugging statement
            controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (NavigationRequest request) {
                    if (request.url.contains(ApiRoutes.paypalReturnURL)) {
                      final uri = Uri.parse(request.url);
                      final payerId = uri.queryParameters['PayerID'];
                      if (payerId != null) {
                        payPalService.executePayment(executeUrl, payerId, accessToken).then((paymentId) {
                          if (paymentId != null) {
                            showSuccess('Payment completed successfully');
                            Get.offAll(() => const HomeScreen());
                          } else {
                            showError('Payment failed');
                            Get.back();
                          }
                        });
                      }
                    } else if (request.url.contains(ApiRoutes.paypalCancelURL)) {
                      showError('Payment cancelled');
                      Get.back();
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              );
            if (approvalUrl != null) {
              controller!.loadRequest(Uri.parse(approvalUrl));
              update();
            }
          }
        }
      }  else {
        //showSuccess(parseCurrencyString(amountCont.text));
        stripePaymentHandle.stripeMakePayment(parseCurrencyString(amountCont.text), "USD");
      }
    });
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
     // donationHistory.assignAll(donations);

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
        reason: selectedDonationType ?? 'Donation',
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

