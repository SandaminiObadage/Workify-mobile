import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/onboarding_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/main.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/ui/auth/login.dart';
import 'package:jobhubv2_0/views/ui/device_mgt/widgets/device_info.dart';
import 'package:provider/provider.dart';

class DeviceManagement extends StatelessWidget {
  const DeviceManagement({super.key});

  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    // var loginNotifier = Provider.of<LoginNotifier>(context);
    var onBoarding = Provider.of<OnBoardNotifier>(context);
    String date = DateTime.now().toString();
    var loginDate = date.substring(0, 11);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: "Device Management",
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeightSpacer(size: 50),
                  Text(
                    "You are logged in into your account on these devices",
                    style: appStyle(16, Color(kDark.value), FontWeight.normal),
                  ),
                  const HeightSpacer(size: 50),
                  DevicesInfo(
                    date: loginDate,
                    device: "MacBook M2",
                    ipAdress: '10.0.12.000',
                    location: 'Washington DC',
                    platform: 'Apple Webkit',
                  ),
                  const HeightSpacer(size: 50),
                  DevicesInfo(
                    date: loginDate,
                    device: "iPhone 14",
                    ipAdress: '10.0.12.000',
                    location: 'Brooklyn',
                    platform: 'Mobile App',
                  )
                ],
              ),
            ),
            Consumer<LoginNotifier>(
              builder: (context, loginNotifier, child) {
                return Padding(
                  padding: EdgeInsets.all(8.0.h),
                  child: GestureDetector(
                    onTap: () {
                      zoomNotifier.currentIndex = 0;
                      loginNotifier.logout();
                      onBoarding.isLastPage = false;
                      defaultHome = const LoginPage();
                      Get.to(() => defaultHome);
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ReusableText(
                          text: "Sign out from all devices",
                          style: appStyle(
                              16, Color(kOrange.value), FontWeight.w600)),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
