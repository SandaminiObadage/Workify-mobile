import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: hieght,
        color: Color(kDarkPurple.value),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const HeightSpacer(size: 20),

                  Expanded(
                    flex: 5,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                      ),
                      child: Image.asset(
                        "assets/images/page1.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const HeightSpacer(size: 20),
                  
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReusableText(
                            text: "Find Your Dream Job", 
                            style: appStyle(28, Color(kLight.value), FontWeight.w500)
                          ),
                          const HeightSpacer(size: 15),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                              child: Text(
                                "We help you find your dream job according to your skillset, location and preference to build your career",
                                textAlign: TextAlign.center,
                                style: appStyle(14, Color(kLight.value), FontWeight.normal),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const HeightSpacer(size: 20),
                        ],
                      ),
                    ),
                  ),
                  
                  const HeightSpacer(size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}