import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kDarkBlue.value),
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
                    const HeightSpacer(size: 50),

                    Flexible(
                      flex: 3,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.h),
                          child: Image.asset(
                            "assets/images/page2.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const HeightSpacer(size: 30),

                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Stable Yourself \n With Your Ability",
                              textAlign: TextAlign.center,
                              style: appStyle(28, Color(kLight.value), FontWeight.w500),
                            ),

                            const HeightSpacer(size: 15),
                            
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                              child: Text(
                                "We help you find your dream job according to your skillset, location and preference to build your career",
                                textAlign: TextAlign.center,
                                style: appStyle(14, Color(kLight.value), FontWeight.normal),
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
