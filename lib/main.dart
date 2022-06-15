import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:success_airline/controllers/audio_controller.dart';
import 'package:success_airline/controllers/idrees_controller.dart';
import 'package:success_airline/screens/admin_screens/adminHome_screen.dart';
import 'package:success_airline/screens/auth_screens/signIn_screen.dart';
import 'package:success_airline/screens/home_screen.dart';
import 'package:success_airline/screens/loadingScreen.dart';
import 'package:success_airline/widgets/bigTexT.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'widgets/splas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.lazyPut(() => AuthController(), fenix: true);
  // Get.put(PurchasesApi());
  Get.put(IdreesController());
  Get.put(AudioController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Sizer(
        builder: (context, orientation, deviceType) =>
            GetBuilder<AuthController>(
                builder: (controller) => GetMaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Flutter Demo',
                      theme: ThemeData(
                        fontFamily: 'avenir',
                        primarySwatch: Colors.blue,
                      ),
                      home: SplashScreen(
                        splashTransition: SplashTransition.fadeTransition,
                        height: 60,
                        splash: Column(
                          children: [
                            const BigText(
                                text: 'Success Airlines',
                                color: Colors.white,
                                size: 30),
                            Image.asset(
                              'assets/pngs/planeLoop.gif',
                              width: 100.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        backgroundColor: const Color(0xffCBE4FE),
                        nextScreen: StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, AsyncSnapshot<User?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LoadingScreen();
                            }

                            if (snapshot.hasData) {
                              if (snapshot.data!.email == 'admin@gmail.com') {
                                Get.find<IdreesController>().isAdmin = true;
                                return AdminHomeScreen();
                              } else {
                                Get.find<IdreesController>().isAdmin = false;
                              }
                              return HomeScreen();
                            }
                            return SignInScreen();
                          },
                        ),
                      ),
                    )));
  }
}
