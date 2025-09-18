import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/auth/login_model.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/custom_btn.dart';
import 'package:jobhubv2_0/views/common/custom_textfield.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/pages_loader.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/ui/auth/signup.dart';
import 'package:jobhubv2_0/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, loginNotifier, child) {
        loginNotifier.getPrefs();
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: CustomAppBar(
                  text: "Login",
                  child: GestureDetector(
                      onTap: () {
                       Get.offAll(() => const MainScreen());
                      },
                      child: const Icon(AntDesign.leftcircleo,))),
            ),
            body: loginNotifier.loader
                ? const PageLoader()
                : buildStyleContainer(
                    context,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Form(
                        key: loginNotifier.loginFormKey,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            const HeightSpacer(size: 50),
                            ReusableText(
                                text: "Welcome Back!",
                                style: appStyle(
                                    30, Color(kDark.value), FontWeight.w600)),
                            ReusableText(
                                text:
                                    "Fill the details to login to your account",
                                style: appStyle(16, Color(kDarkGrey.value),
                                    FontWeight.w500)),
                            const HeightSpacer(size: 50),
                            CustomTextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              hintText: "Email",
                              validator: (email) {
                                if (email!.isEmpty || !email.contains("@")) {
                                  return "Please enter a valid email";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const HeightSpacer(size: 20),
                            CustomTextField(
                              controller: password,
                              keyboardType: TextInputType.text,
                              hintText: "Password",
                              obscureText: loginNotifier.obscureText,
                              validator: (password) {
                                if (password!.isEmpty || password.length < 7) {
                                  return "Please enter a valid password";
                                } else {
                                  return null;
                                }
                              },
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  loginNotifier.obscureText =
                                      !loginNotifier.obscureText;
                                },
                                child: Icon(
                                  loginNotifier.obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(kDark.value),
                                ),
                              ),
                            ),
                            const HeightSpacer(size: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Get.offAll(() => const RegistrationPage());
                                },
                                child: ReusableText(
                                    text: "Register",
                                    style: appStyle(12, Color(kDark.value),
                                        FontWeight.normal)),
                              ),
                            ),
                            const HeightSpacer(size: 50),
                            Consumer<ZoomNotifier>(
                              builder: (context, zoomNotifier, child) {
                                return CustomButton(
                                  onTap: () {
                                    if (loginNotifier.validateAndSave()) {
                                      loginNotifier.setLoader = true;
                                      LoginModel model = LoginModel(
                                          email: email.text,
                                          password: password.text);
                                      String newModel = loginModelToJson(model);
                                      loginNotifier.userLogin(
                                          newModel, zoomNotifier);
                                    } else {
                                      Get.snackbar("Sign Failed",
                                          "Please Check your credentials",
                                          colorText: Color(kLight.value),
                                          backgroundColor: Colors.red,
                                          icon: const Icon(Icons.add_alert));
                                    }
                                  },
                                  text: "Login",
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
      },
    );
  }
}
