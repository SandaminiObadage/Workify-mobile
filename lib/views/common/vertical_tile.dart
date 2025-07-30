import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';

class VerticalTile extends StatelessWidget {
  const VerticalTile({super.key, this.onTap, required this.job});

  final JobsResponse? job;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          height: hieght * 0.15,
          width: width,
          decoration: BoxDecoration(
            color: Color(kLightGrey.value),
            borderRadius: const BorderRadius.all(Radius.circular(9))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(kLightGrey.value),
                          radius: 25,
                          backgroundImage:
                               NetworkImage(job!.imageUrl),
                        ),
                        const WidthSpacer(width: 25),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job!.company,
                                style: appStyle(
                                    18, Color(kDark.value), FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                job!.title,
                                style: appStyle(
                                    16, Color(kDarkGrey.value), FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(kLight.value),
                    child: const Icon(Ionicons.chevron_forward),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Row(
                  children: [
                    ReusableText(
                        text: job!.salary,
                        style:
                            appStyle(20, Color(kDark.value), FontWeight.w600)),
                    ReusableText(
                        text: "/${job!.period}",
                        style: appStyle(
                            20, Color(kDarkGrey.value), FontWeight.w600))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
