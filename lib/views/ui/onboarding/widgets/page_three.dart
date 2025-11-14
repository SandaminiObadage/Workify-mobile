import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/ui/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kLightBlue.value),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HeightSpacer(size: 30),
                    Flexible(
                      flex: 3,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Image.asset(
                          "assets/images/page3.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const HeightSpacer(size: 20),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReusableText(
                                text: "Welcome To JobHub",
                                style: appStyle(28, Color(kLight.value), FontWeight.w600)),
                            const HeightSpacer(size: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                "We help you find your dream job to your skillset, location and preference to build your career",
                                textAlign: TextAlign.center,
                                style: appStyle(14, Color(kLight.value), FontWeight.normal),
                              ),
                            ),
                            const HeightSpacer(size: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: CustomOutlineBtn(
                                  onTap: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                              
                                    await prefs.setBool('entrypoint', true);
                              
                                    Get.to(() => const MainScreen());
                                  },
                                  text: "Continue as guest",
                                  width: width * 0.8,
                                  hieght: 50.h,
                                  color: Color(kLight.value),
                                ),
                              ),
                            ),
                            const HeightSpacer(size: 20),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
