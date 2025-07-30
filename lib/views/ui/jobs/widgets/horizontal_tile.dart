import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhubv2_0/models/response/jobs/jobs_response.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';

class JobHorizontalTile extends StatelessWidget {
  const JobHorizontalTile({super.key, this.onTap, required this.job});

  final void Function()? onTap;
  final JobsResponse job;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            width: width * 0.7,
            height: hieght * 0.27,
            decoration: BoxDecoration(
            color: Color(kLightGrey.value),
            image: const DecorationImage(image: AssetImage('assets/images/jobs.png'), fit: BoxFit.contain, opacity: 0.35)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                     CircleAvatar(
                      radius: 20,
                      backgroundImage: job.imageUrl.isNotEmpty && job.imageUrl != "file:///" 
                        ? NetworkImage(job.imageUrl)
                        : const AssetImage('assets/images/user.png') as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle image loading error silently
                      },
                    ),
                    const WidthSpacer(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: ReusableText(
                            text: job.company,
                            style: appStyle(16, Color(kDark.value), FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                const HeightSpacer(size: 10),
                Flexible(
                  child: Text(
                      job.title,
                      style: appStyle(18, Color(kDark.value), FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                const HeightSpacer(size: 5),
                Flexible(
                  child: Text(
                      job.location,
                      style: appStyle(14, Color(kDarkGrey.value), FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                                job.salary,
                                style: appStyle(
                                    18, Color(kDark.value), FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                          ReusableText(
                              text: "/${job.period}",
                              style: appStyle(
                                  16, Color(kDarkGrey.value), FontWeight.w600)),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(kLight.value),
                      child: const Icon(Ionicons.chevron_forward, size: 16),
                    )
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
