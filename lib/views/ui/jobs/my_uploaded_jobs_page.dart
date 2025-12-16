import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/models/response/jobs/get_job.dart';
import 'package:jobhubv2_0/services/helpers/jobs_helper.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:jobhubv2_0/views/ui/jobs/job_page.dart';
import 'package:jobhubv2_0/views/ui/jobs/edit_jobs.dart';
import 'package:jobhubv2_0/views/ui/jobs/job_applicants_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyUploadedJobsPage extends StatefulWidget {
  const MyUploadedJobsPage({super.key});

  @override
  State<MyUploadedJobsPage> createState() => _MyUploadedJobsPageState();
}

class _MyUploadedJobsPageState extends State<MyUploadedJobsPage> {
  Future<List<dynamic>>? jobsWithApplicants;
  String? agentId;

  @override
  void initState() {
    super.initState();
    loadJobsWithApplicants();
  }

  Future<void> loadJobsWithApplicants() async {
    final prefs = await SharedPreferences.getInstance();
    // Use the same key used during login (uid), fall back to userId for safety
    agentId = prefs.getString('uid') ?? prefs.getString('userId');

    if (agentId != null) {
      setState(() {
        jobsWithApplicants = JobsHelper.getAgentJobsWithApplicants(agentId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: "My Uploaded Jobs",
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(color: Colors.black),
          ),
        ),
      ),
      body: loginNotifier.loggedIn == false
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: Color(kDarkGrey.value)),
                  const HeightSpacer(size: 20),
                  ReusableText(
                    text: "Please login to view your uploaded jobs",
                    style: appStyle(16, Color(kDark.value), FontWeight.w600),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<dynamic>>(
              future: jobsWithApplicants,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 80, color: Colors.red),
                        const HeightSpacer(size: 20),
                        ReusableText(
                          text: "Error loading jobs",
                          style: appStyle(16, Color(kDark.value), FontWeight.w600),
                        ),
                        const HeightSpacer(size: 10),
                        Text(
                          "${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: appStyle(12, Color(kDarkGrey.value), FontWeight.normal),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_off_outlined, size: 80, color: Color(kDarkGrey.value)),
                        const HeightSpacer(size: 20),
                        ReusableText(
                          text: "No jobs uploaded yet",
                          style: appStyle(16, Color(kDark.value), FontWeight.w600),
                        ),
                        const HeightSpacer(size: 10),
                        Text(
                          "Start by uploading your first job!",
                          style: appStyle(12, Color(kDarkGrey.value), FontWeight.normal),
                        ),
                      ],
                    ),
                  );
                } else {
                  final jobs = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final jobData = jobs[index];
                      final applicantCount = jobData['applicantCount'] ?? 0;
                      final isActive = jobData['hiring'] ?? true;
                      final jobId = jobData['_id'] ?? '';
                      
                      return GestureDetector(
                        onTap: () async {
                          // Navigate to job details page
                          if (jobId.isNotEmpty) {
                            try {
                              GetJobRes job = await JobsHelper.getJob(jobId);
                              Get.to(() => JobPage(
                                title: job.title,
                                id: job.id,
                                agentName: jobData['agentName'] ?? name,
                              ));
                            } catch (e) {
                              Get.snackbar(
                                "Error",
                                "Failed to load job details",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          height: 150.h,
                          decoration: BoxDecoration(
                            color: Color(kLightGrey.value),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage("assets/images/jobLoader.gif"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.92),
                                  Colors.white.withOpacity(0.88),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: jobData['imageUrl'] != null && jobData['imageUrl'].toString().isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(
                                                    jobData['imageUrl'],
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Icon(Icons.business, 
                                                        color: Color(kDarkGrey.value), size: 18);
                                                    },
                                                  ),
                                                )
                                              : Icon(Icons.business, 
                                                  color: Color(kDarkGrey.value), size: 18),
                                        ),
                                        SizedBox(width: 10.w),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ReusableText(
                                              text: jobData['company'] ?? 'No Company',
                                              style: appStyle(14, Color(Color.fromARGB(255, 48, 43, 43).value), FontWeight.normal),
                                            ),
                                            SizedBox(height: 2.h),
                                            SizedBox(
                                              width: 160.w,
                                              child: ReusableText(
                                                text: jobData['title'] ?? 'No Title',
                                                style: appStyle(15, Color(kDark.value), FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        // Navigate to edit page
                                        if (jobId.isNotEmpty) {
                                          try {
                                            GetJobRes job = await JobsHelper.getJob(jobId);
                                            editable = job;
                                            Get.to(() => const EditJobs());
                                          } catch (e) {
                                            Get.snackbar(
                                              "Error",
                                              "Failed to load job for editing",
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Color(kOrange.value).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                          color: Color(kOrange.value),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 14, color: Color(kDarkGrey.value)),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        jobData['location'] ?? 'No Location',
                                        style: appStyle(12, Color(kDarkGrey.value), FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: Color(Color.fromARGB(255, 233, 229, 229).value),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              ReusableText(
                                                text: "${jobData['salary'] ?? 'N/A'}/",
                                                style: appStyle(13, const Color.fromARGB(255, 27, 23, 23), FontWeight.w600),
                                              ),
                                              ReusableText(
                                                text: jobData['period'] ?? 'Monthly',
                                                style: appStyle(13, const Color.fromARGB(179, 49, 40, 40), FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: isActive 
                                                ? Colors.green.withOpacity(0.15)
                                                : Colors.red.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            isActive ? "Active" : "Closed",
                                            style: appStyle(
                                              11,
                                              isActive ? Colors.green : Colors.red,
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to applicants page
                                        Get.to(() => JobApplicantsPage(
                                          jobId: jobId,
                                          jobTitle: jobData['title'] ?? 'Job',
                                          company: jobData['company'] ?? 'Company',
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: Color(kOrange.value).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.people, size: 16, color: Color(kOrange.value)),
                                            SizedBox(width: 4.w),
                                            ReusableText(
                                              text: "$applicantCount",
                                              style: appStyle(13, Color(kOrange.value), FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
