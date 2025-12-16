import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/services/helpers/applied_helper.dart';
import 'package:jobhubv2_0/services/helpers/resume_helper.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/app_style.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/reusable_text.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class JobApplicantsPage extends StatefulWidget {
  final String jobId;
  final String jobTitle;
  final String company;

  const JobApplicantsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.company,
  });

  @override
  State<JobApplicantsPage> createState() => _JobApplicantsPageState();
}

class _JobApplicantsPageState extends State<JobApplicantsPage> {
  Future<List<dynamic>>? _applicants;

  @override
  void initState() {
    super.initState();
    _loadApplicants();
  }

  void _loadApplicants() {
    setState(() {
      _applicants = AppliedHelper.getJobApplicants(widget.jobId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: "Applicants",
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Wallpaper background
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'assets/images/jobs.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content with slight scrim for readability
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Info Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          text: widget.jobTitle,
                          style: appStyle(16, Color(kDark.value), FontWeight.w600),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.business, size: 14, color: Color(kDarkGrey.value)),
                            SizedBox(width: 4.w),
                            Text(
                              widget.company,
                              style: appStyle(13, Color(kDarkGrey.value), FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ReusableText(
                      text: "Applications",
                      style: appStyle(15, Color(kDark.value), FontWeight.w600),
                    ),
                  ),
                  const HeightSpacer(size: 10),

                  // Applicants List
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: _applicants,
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
                                Icon(Icons.error_outline, size: 60, color: Colors.red),
                                const HeightSpacer(size: 20),
                                Text(
                                  "Error loading applicants",
                                  style: appStyle(16, Color(kDark.value), FontWeight.w600),
                                ),
                                const HeightSpacer(size: 8),
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
                                Icon(Icons.people_outline, 
                                  size: 80, 
                                  color: Color(kDarkGrey.value)),
                                const HeightSpacer(size: 20),
                                ReusableText(
                                  text: "No applicants yet",
                                  style: appStyle(16, Color(kDark.value), FontWeight.w600),
                                ),
                                const HeightSpacer(size: 8),
                                Text(
                                  "Applications will appear here when someone applies",
                                  textAlign: TextAlign.center,
                                  style: appStyle(12, Color(kDarkGrey.value), FontWeight.normal),
                                ),
                              ],
                            ),
                          );
                        }

                        final applicants = snapshot.data!;
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          itemCount: applicants.length,
                          itemBuilder: (context, index) {
                            final application = applicants[index];
                            final Map<String, dynamic> user =
                                (application['user'] is Map<String, dynamic>)
                                    ? application['user'] as Map<String, dynamic>
                                    : <String, dynamic>{};
                            final appliedDate = application['createdAt'];
                            
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    _showApplicantDetails(context, user, appliedDate);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        _avatar(user, radius: 28, fontSize: 20),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ReusableText(
                                                text: user['username'] ?? 'Unknown',
                                                style: appStyle(15, Color(kDark.value), FontWeight.w600),
                                              ),
                                              SizedBox(height: 4.h),
                                              if (user['email'] != null)
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.email_outlined,
                                                      size: 14,
                                                      color: Color(kDarkGrey.value),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Expanded(
                                                      child: Text(
                                                        user['email'],
                                                        style: appStyle(
                                                          12,
                                                          Color(kDarkGrey.value),
                                                          FontWeight.normal,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 2.h),
                                              if (user['location'] != null)
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_outlined,
                                                      size: 14,
                                                      color: Color(kDarkGrey.value),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Expanded(
                                                      child: Text(
                                                        user['location'],
                                                        style: appStyle(
                                                          12,
                                                          Color(kDarkGrey.value),
                                                          FontWeight.normal,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Color(kDarkGrey.value),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicantDetails(BuildContext context, Map<String, dynamic> user, String? appliedDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          _avatar(user, radius: 50, fontSize: 32),
                          const HeightSpacer(size: 12),
                          ReusableText(
                            text: user['username'] ?? 'Unknown',
                            style: appStyle(20, Color(kDark.value), FontWeight.w600),
                          ),
                          if (user['isAgent'] == true)
                            Container(
                              margin: EdgeInsets.only(top: 6.h),
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Color(kOrange.value).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Agent",
                                style: appStyle(11, Color(kOrange.value), FontWeight.w600),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const HeightSpacer(size: 24),
                    
                    // Contact Information
                    ReusableText(
                      text: "Contact Information",
                      style: appStyle(16, Color(kDark.value), FontWeight.w600),
                    ),
                    const HeightSpacer(size: 12),
                    
                    if (user['email'] != null)
                      _buildInfoRow(Icons.email, "Email", user['email']),
                    if (user['phone'] != null)
                      _buildInfoRow(Icons.phone, "Phone", user['phone']),
                    if (user['location'] != null)
                      _buildInfoRow(Icons.location_on, "Location", user['location']),
                    
                    const HeightSpacer(size: 20),
                    
                    // Skills
                    if (user['skills'] != null && user['skills'] is List && (user['skills'] as List).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Skills",
                            style: appStyle(16, Color(kDark.value), FontWeight.w600),
                          ),
                          const HeightSpacer(size: 12),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: (user['skills'] as List).where((skill) => 
                              skill != null && skill.toString().trim().isNotEmpty
                            ).map((skill) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, 
                                  vertical: 6.h
                                ),
                                decoration: BoxDecoration(
                                  color: Color(kLightBlue.value).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  skill.toString(),
                                  style: appStyle(12, Color(kDark.value), FontWeight.w500),
                                ),
                              );
                            }).toList(),
                          ),
                          const HeightSpacer(size: 20),
                        ],
                      ),
                    
                    // Resume
                    if (user['resume'] != null && user['resume'].toString().isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Resume",
                            style: appStyle(16, Color(kDark.value), FontWeight.w600),
                          ),
                          const HeightSpacer(size: 12),
                          InkWell(
                            onTap: () {
                              _downloadResume(user['resume']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesome5Regular.file_pdf,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Resume Available",
                                          style: appStyle(14, Color(kDark.value), 
                                            FontWeight.w600),
                                        ),
                                        Text(
                                          "Tap to download",
                                          style: appStyle(11, Color(kDarkGrey.value), 
                                            FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.download,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const HeightSpacer(size: 20),
                        ],
                      ),
                    
                    // Applied Date
                    if (appliedDate != null)
                      _buildInfoRow(
                        Icons.calendar_today,
                        "Applied",
                        _formatDate(appliedDate),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Color(kLightBlue.value).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Color(kLightBlue.value)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: appStyle(11, Color(kDarkGrey.value), FontWeight.normal),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: appStyle(14, Color(kDark.value), FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "Today";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _downloadResume(dynamic resumePath) async {
    final path = resumePath?.toString() ?? '';
    if (path.isEmpty) {
      Get.snackbar(
        "Resume",
        "No resume available",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Extract filename from path (/resumes/<fileName>)
    final fileName = path.split('/').isNotEmpty ? path.split('/').last : path;

    try {
      await ResumeHelper.downloadResume(fileName);
      Get.snackbar(
        "Downloading",
        "Resume download started...",
        backgroundColor: Color(kLightBlue.value),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to download resume",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _avatar(Map<String, dynamic> user, {double radius = 28, double fontSize = 20}) {
    final profileUrl = user['profile']?.toString() ?? '';
    final initials = (user['username']?.toString().isNotEmpty == true)
        ? user['username'].toString()[0].toUpperCase()
        : 'U';

    // If URL is empty, render initials immediately
    if (profileUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Color(kLightBlue.value),
        child: Text(initials, style: appStyle(fontSize, Colors.white, FontWeight.w600)),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(kLightBlue.value),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileUrl,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          httpHeaders: const {'Accept': 'image/svg+xml'},
          errorWidget: (context, url, error) {
            return Center(
              child: Text(initials, style: appStyle(fontSize, Colors.white, FontWeight.w600)),
            );
          },
          placeholder: (context, url) {
            return Center(
              child: Text(initials, style: appStyle(fontSize, Colors.white, FontWeight.w600)),
            );
          },
        ),
      ),
    );
  }
}
