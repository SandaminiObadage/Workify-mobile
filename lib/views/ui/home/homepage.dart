// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/chat_provider.dart';
import 'package:jobhubv2_0/controllers/exports.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/heading_widget.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/search.dart';
import 'package:jobhubv2_0/views/common/vertical_shimmer.dart';
import 'package:jobhubv2_0/views/common/vertical_tile.dart';
import 'package:jobhubv2_0/views/ui/auth/profile.dart';
import 'package:jobhubv2_0/views/ui/chat/chat_list.dart';
import 'package:jobhubv2_0/views/ui/chat/chat_page.dart';
import 'package:jobhubv2_0/views/ui/home/widgets/PopularJobs.dart';
import 'package:jobhubv2_0/views/ui/home/widgets/RecentJobs.dart';
import 'package:jobhubv2_0/views/ui/jobs/job_page.dart';
import 'package:jobhubv2_0/views/ui/jobs/jobs_list.dart';
import 'package:jobhubv2_0/views/ui/jobs/widgets/horizontal_shimmer.dart';
import 'package:jobhubv2_0/views/ui/jobs/widgets/horizontal_tile.dart';
import 'package:jobhubv2_0/views/ui/search/searchpage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    loginNotifier.getPrefs();
   
      
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            actions: [
              Padding(
                padding: EdgeInsets.all(12.h),
                child: GestureDetector(
                    onTap: () {
                      Get.to(() => const ProfilePage(
                            drawer: false,
                          ));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        width: 25.w,
                        height: 25.h,
                        fit: BoxFit.cover,
                        imageUrl:
                            "https://ui-avatars.com/api/?name=User&background=0D8ABC&color=fff&size=128",
                      ),
                    )),
              )
            ],
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
                Text(
                  "Search \nFind & Apply",
                  style: appStyle(38, Color(kDark.value), FontWeight.bold),
                ),
                const HeightSpacer(size: 30),
                SearchWidget(
                  onTap: () {
                    Get.to(() => const SearchPage());
                  },
                ),
                const HeightSpacer(size: 25),
                HeadingWidget(
                  text: "Popular Jobs",
                  onTap: () {
                    Get.to(() => const JobListPage());
                  },
                ),
                const HeightSpacer(size: 15),
                const PopularJobs(),
                const HeightSpacer(size: 15),
                HeadingWidget(
                  text: "Recently Posted",
                  onTap: () {
                    Get.to(() => const JobListPage());
                  },
                ),
                const HeightSpacer(size: 15),
                const RecentJobs(),
              ],
            ),
          ),
        )));
  }
}
