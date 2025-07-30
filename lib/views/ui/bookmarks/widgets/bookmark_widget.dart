import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';
import 'package:jobhubv2_0/views/ui/jobs/job_page.dart';

class BookMarkTileWidget extends StatelessWidget {
  const BookMarkTileWidget({super.key, required this.job});
  final AllBookMarks job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Get.to(() => JobPage(title: job.job.company, id: job.job.id, agentName: job.job.agentName ,));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          height: hieght * 0.1,
          width: width,
          decoration: BoxDecoration(
              color: Color(kLightGrey.value),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
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
                          radius: 25,
                          backgroundImage: job.job.imageUrl.isNotEmpty && job.job.imageUrl != "file:///" 
                            ? NetworkImage(job.job.imageUrl)
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
                                  job.job.company,
                                  style: appStyle(
                                      12, Color(kDark.value), FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  job.job.title,
                                  style: appStyle(12, Color(kDarkGrey.value),
                                      FontWeight.normal),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  "${job.job.salary}  ${job.job.period}",
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
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(kLight.value),
                    child: Icon(
                      Ionicons.chevron_forward,
                      color: Color(kOrange.value),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
