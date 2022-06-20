// ignore_for_file: implementation_imports, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase_android/src/in_app_purchase_android_platform_addition.dart'
    show InAppPurchaseAndroidPlatformAddition;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/contants/appContants.dart';
import 'package:success_airline/controllers/auth_controller.dart';
import 'package:success_airline/screens/auth_screens/address_screen.dart';
import 'package:success_airline/widgets/bigTexT.dart';
import 'package:success_airline/widgets/roundedButton.dart';
import 'package:success_airline/widgets/smallText.dart';
import '../controllers/test_purchase.dart';
import 'auth_screens/components/loading_screen.dart';

String PURCHASE_ID = '';
DateTime? expiryDate;

class PremiumPlanScreen extends StatefulWidget {
  final userDetails = Get.arguments as Map<String, dynamic>;
  PremiumPlanScreen({Key? key}) : super(key: key);

  @override
  State<PremiumPlanScreen> createState() => _PremiumPlanScreenState();
}

class _PremiumPlanScreenState extends State<PremiumPlanScreen> {
  final AuthController auth = Get.find();
  final _ipa = InAppPurchase.instance;
  bool isAvailable = true;

  List<String> productIds = Platform.isAndroid
      ? ['monthly_599', 'yearly_6299_1y']
      : ['success_599_1m', 'yearly_6299_1y'];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _purchasePending = false;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  String? purchasedProdID;
  final RxBool isYearlyPlan = true.obs;
  bool isLoading = true;
  @override
  void initState() {
    final Stream<List<PurchaseDetails>> _purchaseStream = _ipa.purchaseStream;
    _subscription = _purchaseStream.listen((purchases) {
      setState(() {
        _purchases = purchases;

        _listenToPurchaseUpdated(purchases);
      });
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (err) {
      _subscription!.cancel();
    });

    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  void _initialize() async {
    isAvailable = await _ipa.isAvailable();
    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];

        _purchasePending = false;
        isLoading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _ipa.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _ipa.queryProductDetails(productIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _purchasePending = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _purchasePending = false;
        isLoading = false;
      });
      return;
    }
    setState(() {
      _products = productDetailResponse.productDetails;

      _purchasePending = false;
      isLoading = false;
    });

    setState(() {
      isLoading = false;
    });
  }

  PurchaseDetails _hasPurchase(String id) {
    return _purchases.firstWhere((item) => item.productID == id);
  }

  bool verifyPurchase(String id) {
    PurchaseDetails purchase = _hasPurchase(id);
    return purchase.status == PurchaseStatus.purchased;
  }

  Future<void> buyProduct(ProductDetails prod) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: prod,
    );

    if (Platform.isAndroid) {
      await _ipa
          .buyConsumable(purchaseParam: purchaseParam, autoConsume: false)
          .catchError((err) {
        print(err);
      });
    }
    if (Platform.isIOS) {
      await _ipa
          .buyConsumable(purchaseParam: purchaseParam, autoConsume: true)
          .catchError((err) {
        print(err);

        //this wil be the temp code
        //TODO : We have to remove this Snakcbar once the error is solved aboit purchases
        Get.snackbar('Error', err.message,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red);
      });
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (widget.userDetails.containsKey('oldPurchaseId')) {
            if (widget.userDetails['oldPurchaseId'] ==
                purchaseDetails.purchaseID) {
              PurchaseDetails oldPurchase = purchaseDetails;
              if (Platform.isAndroid) {
                InAppPurchaseAndroidPlatformAddition platformAddition =
                    _ipa.getPlatformAddition<
                        InAppPurchaseAndroidPlatformAddition>();
                platformAddition.consumePurchase(oldPurchase);
              } else {
                _ipa.completePurchase(purchaseDetails);
              }
            } else if (purchaseDetails.status == PurchaseStatus.purchased) {
              updatePurchase(purchaseDetails);
            }
          } else {
            newPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          if (purchaseDetails.error != null) {
            handleError(purchaseDetails.error!);
          }

          await _ipa.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> onWillpopScope() async {
    if (Platform.isAndroid) {
      return !widget.userDetails.containsKey('oldPurchaseId');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillpopScope,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme:
                IconTheme.of(context).copyWith(color: Colors.transparent),
            leading: GestureDetector(
              onTap: widget.userDetails.containsKey('oldPurchaseId') ||
                      isLoading ||
                      _purchasePending
                  ? () {}
                  : () {
                      Get.back();
                    },
              child: Icon(
                Icons.arrow_back_ios,
                size: 3.h,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.grey[100],
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  height: 100.h,
                  width: 100.w,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                          child: Image.asset('assets/pngs/diamond 1.png'),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        const BigText(
                          size: 22,
                          text: 'Select a Plan',
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Obx(
                          () => InkWell(
                            onTap: () {
                              isYearlyPlan.value = false;
                            },
                            child: Container(
                              height: 10.h,
                              width: 90.w,
                              decoration: BoxDecoration(
                                boxShadow: isYearlyPlan.value
                                    ? null
                                    : [
                                        BoxShadow(
                                            offset: const Offset(0, 3),
                                            blurRadius: 5,
                                            color:
                                                kprimaryColor.withOpacity(0.5))
                                      ],
                                borderRadius: BorderRadius.circular(1.5.h),
                                color: isYearlyPlan.value
                                    ? Colors.white
                                    : kprimaryColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(children: [
                                  Container(
                                    height: 8.h,
                                    width: 9.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.5.h),
                                        color: isYearlyPlan.value
                                            ? Colors.blue.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.7)),
                                    child: Image.asset(
                                      'assets/pngs/crown.png',
                                    ),
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Column(
                                      children: [
                                        SmallText(
                                          color: !isYearlyPlan.value
                                              ? Colors.white
                                              : Colors.black,
                                          size: 14,
                                          text: 'Monthly',
                                        ),
                                        Spacer(),
                                        SmallText(
                                          text: '\$ 5.99',
                                          color: !isYearlyPlan.value
                                              ? Colors.white.withOpacity(0.7)
                                              : Colors.black45,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 3,
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Obx(
                          () => InkWell(
                            onTap: () {
                              isYearlyPlan.value = true;
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 10.h,
                              width: 90.w,
                              decoration: BoxDecoration(
                                  boxShadow: !isYearlyPlan.value
                                      ? null
                                      : [
                                          BoxShadow(
                                              offset: const Offset(0, 3),
                                              blurRadius: 5,
                                              color: kprimaryColor
                                                  .withOpacity(0.5))
                                        ],
                                  borderRadius: BorderRadius.circular(1.5.h),
                                  color: isYearlyPlan.value
                                      ? kprimaryColor
                                      : Colors.white),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Row(children: [
                                  Container(
                                    height: 8.h,
                                    width: 9.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.5.h),
                                        color: isYearlyPlan.value
                                            ? Colors.blue.withOpacity(0.7)
                                            : Colors.blue.withOpacity(0.2)),
                                    child: Image.asset(
                                        'assets/pngs/explosive.png'),
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Column(children: [
                                      SmallText(
                                        color: isYearlyPlan.value
                                            ? Colors.white
                                            : Colors.black,
                                        size: 14,
                                        text: 'Yearly',
                                      ),
                                      Spacer(),
                                      SmallText(
                                        text: '\$ 62.99',
                                        color: isYearlyPlan.value
                                            ? Colors.white
                                            : Colors.black45,
                                      ),
                                    ]),
                                  ),
                                  Spacer(
                                    flex: 3,
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        RoundedButton(
                          isLoading: _purchasePending,
                          onPressed: () async {
                            if (isPurchaesTest) {
                              //print(widget.userDetails);
                              expiryDate =
                                  DateTime.now().add(const Duration(days: 30));
                              //this code is for bypasing the purchases in Test mode
                              widget.userDetails['expiryDate'] = expiryDate;
                              PURCHASE_ID = "testIDfor-30-Days";
                              widget.userDetails['purchaseId'] = PURCHASE_ID;

                              Get.off(() => AddressScreen(),
                                  arguments: widget.userDetails);
                            } else {
                              ProductDetails prod;
                              if (isYearlyPlan.value) {
                                prod = _products[1];
                              } else {
                                prod = _products[0];
                              }
                              buyProduct(prod);
                            }
                          },
                          label: 'Get Offer',
                          radius: 2,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        if (widget.userDetails.containsKey('oldPurchaseId'))
                          TextButton.icon(
                              onPressed: () {
                                auth.signOut();
                                Get.close(1);
                              },
                              icon: const Icon(
                                Icons.exit_to_app,
                                color: Colors.black38,
                              ),
                              label: const BigText(
                                size: 14,
                                text: 'Log out',
                                color: Colors.black38,
                              ))
                      ]),
                )),
    );
  }

  Future<void> newPurchase(PurchaseDetails purchaseDetails) async {
    Get.dialog(const ProgressScreen(), barrierDismissible: false);
    purchasedProdID = purchaseDetails.purchaseID;
    if (purchaseDetails.productID == _products[0].id) {
      expiryDate = DateTime.now().add(const Duration(days: 30));
    } else {
      expiryDate = DateTime.now().add(const Duration(days: 365));
    }
    widget.userDetails['expiryDate'] = expiryDate;
    widget.userDetails['purchaseId'] = purchasedProdID;
    if (Platform.isAndroid) {
      final platformAddition =
          _ipa.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      platformAddition.consumePurchase(purchaseDetails);
    }
    _ipa.completePurchase(purchaseDetails);
    print(purchasedProdID);
    PURCHASE_ID = purchaseDetails.productID;
    // Get.off(() => AddressScreen(), arguments: widget.userDetails);
    String name =
        widget.userDetails['firstName'] + ' ' + widget.userDetails['lastName'];
    String email = widget.userDetails['email'];
    String password = widget.userDetails['password'];

    await auth.signUp(name, email, password, widget.userDetails).then((value) {
      PURCHASE_ID = '';
      Get.close(8);
    }).catchError((err) {
      String msg = err.toString();
      if (msg.contains('A network error')) {
        msg = 'Please check your internet connection';
      }
      if (msg.contains('email-already-in-use')) {
        msg = 'The email you entered is already exists';
      }

      Get.dialog(
          CupertinoAlertDialog(
            title: const Text('Sign up failed'),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Get.close(8);
                },
              )
            ],
          ),
          barrierDismissible: false);
    });
  }

  void updatePurchase(PurchaseDetails purchaseDetails) {
    final dbRef = FirebaseFirestore.instance.collection('purchases');

    purchasedProdID = purchaseDetails.purchaseID;

    if (purchaseDetails.productID == _products[0].id) {
      expiryDate = DateTime.now().add(const Duration(days: 30));
    } else {
      expiryDate = DateTime.now().add(const Duration(days: 365));
    }
    if (Platform.isAndroid) {
      final platformAddition =
          _ipa.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      platformAddition.consumePurchase(purchaseDetails);
    }
    _ipa.completePurchase(purchaseDetails);
    Get.close(1);
    dbRef
        .doc(auth.user!.id)
        .set({'purchaseID': purchasedProdID, 'expiryDate': expiryDate});
  }

  void handleError(IAPError err) {
    setState(() {
      _purchasePending = false;
    });
  }
}
