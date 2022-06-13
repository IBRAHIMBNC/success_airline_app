import 'dart:async';
import 'dart:io';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_android/src/in_app_purchase_android_platform_addition.dart'
    show InAppPurchaseAndroidPlatformAddition;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/constants.dart';
import 'package:success_airline/controllers/auth_controller.dart';
import 'package:success_airline/screens/auth_screens/address_screen.dart';
import 'package:success_airline/widgets/bigTexT.dart';
import 'package:success_airline/widgets/roundedButton.dart';
import 'package:success_airline/widgets/smallText.dart';
import '../controllers/consumable_store.dart';
import '../controllers/test_purchase.dart';

String PURCHASE_ID = '';

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
  bool _isAvailable = false;
  bool _purchasePending = false;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  String? purchasedProdID;
  DateTime expiryDate = DateTime.now();
  final RxBool isYearlyPlan = true.obs;
  bool isLoading = true;
  String? _queryProductError;
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
        _isAvailable = isAvailable;
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
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _purchasePending = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _purchasePending = false;
        isLoading = false;
      });
      return;
    }
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;

      _purchasePending = false;
      isLoading = false;
    });

    setState(() {
      isLoading = false;
    });
  }

  // Future<void> initStoreInfo() async {
  //   final bool isAvailable = await _ipa.isAvailable();
  //   if (!isAvailable) {
  //     setState(() {
  //       _isAvailable = isAvailable;
  //       _products = <ProductDetails>[];
  //       _purchases = <PurchaseDetails>[];
  //       _purchasePending = false;
  //       isLoading = false;
  //     });
  //     return;
  //   }
  // }

  // getProducts() async {
  //   Set<String> ids = Set.from(productIds);
  //   ProductDetailsResponse response = await _ipa.queryProductDetails(ids);
  //   setState(() {
  //     _products = response.productDetails;
  //   });
  // }

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
                        // BigText(
                        //   text: 'Prices',
                        //   color: Colors.black,
                        //   size: 16,
                        // ),
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        // _Feature(
                        //   text: 'Lorem ipsum doctor  sit aimt',
                        // ),
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        // _Feature(
                        //   text: 'Lorem ipsum doctor  sit aimt',
                        // ),
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        // _Feature(
                        //   text: 'Lorem ipsum doctor  sit aimt',
                        // ),
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        // _Feature(
                        //   text: 'Lorem ipsum doctor  sit aimt',
                        // ),
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
                                ]
                                    // trailing: SizedBox(width: 10.w),
                                    // trailing: BigText(
                                    //   text: '\$ 71.88',
                                    //   color: !isYearlyPlan.value
                                    //       ? Colors.white
                                    //       : Colors.black,
                                    //   size: 12,
                                    // ),
                                    ),
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
                            ProductDetails prod;
                            if (isYearlyPlan.value) {
                              prod = _products[1];
                            } else {
                              prod = _products[0];
                            }
                            buyProduct(prod);
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
                        // RoundedButton(
                        //   label: 'Log out',
                        //   size: Size(50, 7.5),
                        //   radius: 2,
                        //   onPressed: () async {
                        //     // print(_purchases.first.error);
                        //     // final platformAddition = _ipa.getPlatformAddition<
                        //     //     InAppPurchaseAndroidPlatformAddition>();
                        //     // platformAddition
                        //     //     .consumePurchase(_purchases.first)
                        //     //     .then((value) => print(value.responseCode));
                        //
                        //   },
                        // )
                      ]),
                )),
    );
  }

  void newPurchase(PurchaseDetails purchaseDetails) {
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
    Get.off(() => AddressScreen(), arguments: widget.userDetails);
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
