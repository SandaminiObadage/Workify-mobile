import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/jobs_provider.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/services/helpers/matching_helper.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/common/vertical_shimmer.dart';
import 'package:jobhubv2_0/views/ui/jobs/job_page.dart';
import 'package:provider/provider.dart';

class RecommendedJobsPage extends StatefulWidget {
  const RecommendedJobsPage({super.key});

  @override
  State<RecommendedJobsPage> createState() => _RecommendedJobsPageState();
}

class _RecommendedJobsPageState extends State<RecommendedJobsPage> {
  @override
  void initState() {
    super.initState();
    _fetchRecommendedJobs();
  }

  void _fetchRecommendedJobs() {
    final loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    loginNotifier.getPrefs();
    
    // Fetch recommended jobs after a short delay to ensure user data is loaded
    Future.delayed(const Duration(milliseconds: 500), () {
      if (loginNotifier.userUid.isNotEmpty) {
        Provider.of<JobsNotifier>(context, listen: false)
            .getRecommendedJobs(loginNotifier.userUid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);

    if (loginNotifier.userUid.isEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            actions: const [],
            child: Padding(
              padding: EdgeInsets.all(12.0.h),
              child: const DrawerWidget(color: Colors.black),
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Please login to view recommended jobs',
            style: appStyle(14, Color(kDark.value), FontWeight.w500),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          actions: const [],
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                ReusableText(
                  text: "Recommended Jobs",
                  style: appStyle(24, Color(kDark.value), FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                ReusableText(
                  text: "Jobs matched based on your skills and preferences",
                  style: appStyle(12, Color(kDarkGrey.value), FontWeight.w500),
                ),
                SizedBox(height: 20.h),
                Consumer<JobsNotifier>(
                  builder: (context, jobsNotifier, child) {
                    if (jobsNotifier.isLoadingRecommended) {
                      return const VerticalShimmer();
                    }

                    if (jobsNotifier.recommendedJobs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 50.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              ReusableText(
                                text: "No recommended jobs found",
                                style: appStyle(
                                    14, Color(kDarkGrey.value), FontWeight.w500),
                              ),
                              SizedBox(height: 8.h),
                              ReusableText(
                                text:
                                    "Update your profile and skills to get better recommendations",
                                style: appStyle(
                                    12, Color(kDarkGrey.value), FontWeight.w400),
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: _fetchRecommendedJobs,
                                child: const Text('Refresh'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: jobsNotifier.recommendedJobs.length,
                      itemBuilder: (context, index) {
                        final job = jobsNotifier.recommendedJobs[index];
                        final matchScore = jobsNotifier
                            .recommendedJobsScores[index]
                            .toStringAsFixed(0);

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => JobPage(
                                  title: job.company,
                                  id: job.id,
                                  agentName: job.agentName,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ReusableText(
                                                    text: job.title,
                                                    style: appStyle(
                                                        14,
                                                        Color(kDark.value),
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  ReusableText(
                                                    text: job.company,
                                                    style: appStyle(
                                                        12,
                                                        Color(kDarkGrey.value),
                                                        FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getMatchScoreColor(
                                                    double.parse(matchScore)),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: ReusableText(
                                                text: "$matchScore%",
                                                style: appStyle(
                                                    11,
                                                    Colors.white,
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 16.sp,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 4.w),
                                            ReusableText(
                                              text: job.location,
                                              style: appStyle(11,
                                                  Color(kDarkGrey.value),
                                                  FontWeight.w400),
                                            ),
                                            SizedBox(width: 16.w),
                                            Icon(
                                              Icons.attach_money,
                                              size: 16.sp,
                                              color: Colors.grey,
                                            ),
                                            ReusableText(
                                              text: job.salary,
                                              style: appStyle(11,
                                                  Color(kDarkGrey.value),
                                                  FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: ReusableText(
                                                text: job.period,
                                                style: appStyle(10,
                                                    Colors.blue, FontWeight.w500),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: ReusableText(
                                                text: job.contract,
                                                style: appStyle(
                                                    10,
                                                    Colors.orange,
                                                    FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12.r),
                                          bottomLeft: Radius.circular(12.r),
                                        ),
                                      ),
                                      child: ReusableText(
                                        text: "⭐ Match",
                                        style: appStyle(
                                            10, Colors.white, FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getMatchScoreColor(double score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.blue;
    } else if (score >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
