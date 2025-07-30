import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/models/response/applied/applied.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';
import 'package:jobhubv2_0/views/ui/jobs/job_page.dart';

class AppliedTile extends StatelessWidget {
  const AppliedTile({super.key, required this.job, required this.text});
  final Job job;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: GestureDetector(
          onTap: () {
            Get.to(() => JobPage(title: job.company, id: job.id, agentName: job.agentName,));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            height: hieght * 0.1,
            width: width,
            decoration: const BoxDecoration(
                color: Color(0x09000000),
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: job.imageUrl.isNotEmpty && job.imageUrl != "file:///" 
                              ? NetworkImage(job.imageUrl)
                              : const AssetImage('assets/images/user.png') as ImageProvider,
                            onBackgroundImageError: (exception, stackTrace) {
                              // Handle image loading error silently
                            },
                          ),
                          const WidthSpacer(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    job.company,
                                    style: appStyle(
                                        12, Color(kDark.value), FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                    job.title,
                                    style: appStyle(12, Color(kDarkGrey.value),
                                        FontWeight.normal),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                    "${job.salary} per ${job.period}",
                                    style: appStyle(
                                        12, Color(kDarkGrey.value), FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomOutlineBtn(
                        width: 90,
                        hieght: 36,
                        text: 'View',
                        color: Color(kLightBlue.value))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
