// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/jobs_provider.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/loader.dart';
import 'package:jobhubv2_0/views/ui/jobs/PopularJobsList.dart';
import 'package:jobhubv2_0/views/ui/jobs/widgets/job_tile.dart';
import 'package:provider/provider.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
            text: "Jobs",
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(AntDesign.leftcircleo),
            )),
      ),
      body: const PopularJobList(),
    );
  }
}
