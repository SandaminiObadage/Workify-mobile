import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/ui/auth/login.dart';

class NonUser extends StatelessWidget {
  const NonUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildStyleContainer(
      context,
      Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(99)),
            child: CachedNetworkImage(
              width: 70.w,
              height: 70.h,
              fit: BoxFit.cover,
              imageUrl:
                  "https://ui-avatars.com/api/?name=Guest&background=0D8ABC&color=fff&size=128",
            ),
          ),
          const HeightSpacer(
            size: 20,
          ),
          ReusableText(
              text: 'To access contents of this page proceed to login  ',
              style: appStyle(12, Color(kDarkGrey.value), FontWeight.normal)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: CustomOutlineBtn(
              width: width,
              hieght: 40,
              color: Color(kOrange.value),
              onTap: () {
                Get.to(() => const LoginPage());
              },
              text: "Proceed to Login",
            ),
          )
        ],
      ),
    );
  }
}
