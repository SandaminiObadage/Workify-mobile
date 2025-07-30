import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/controllers/login_provider.dart';
import 'package:jobhubv2_0/controllers/profile_provider.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/response/auth/profile_model.dart';
import 'package:jobhubv2_0/services/helpers/auth_helper.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/drawer/drawer_widget.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/common/styled_container.dart';
import 'package:jobhubv2_0/views/common/width_spacer.dart';
import 'package:jobhubv2_0/views/ui/agent/agency_application.dart';
import 'package:jobhubv2_0/views/ui/auth/NonUser.dart';
import 'package:jobhubv2_0/views/ui/auth/profile_update.dart';
import 'package:jobhubv2_0/views/ui/auth/widgets/agent_tile.dart';
import 'package:jobhubv2_0/views/ui/auth/widgets/edit_button.dart';
import 'package:jobhubv2_0/views/ui/auth/widgets/skills.dart';
import 'package:jobhubv2_0/views/ui/jobs/upload_jobs.dart';
import 'package:jobhubv2_0/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final bool drawer;

  const ProfilePage({super.key, required this.drawer});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<ProfileRes>? userProfile;
  bool? loggedIn;

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  getUserProfile() async {
    var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    loginNotifier.getStatus();

    if (widget.drawer == false && loginNotifier.loggedIn == true) {
      userProfile = AuthHelper.getProfile();
    } else {}
  }

  refreshProfile() {
    setState(() {
      getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var loginNotifier = Provider.of<LoginNotifier>(context);
    bool loggedIn = loginNotifier.loggedIn;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            text: !loggedIn ? "" : "Profile",
            child: Padding(
              padding: EdgeInsets.all(12.0.h),
              child: widget.drawer == false
                  ? const BackBtn()
                  : const DrawerWidget(color: Colors.black),
            ),
          ),
        ),
        body: loggedIn == false
            ? const NonUser()
            : Consumer<ProfileNotifier>(
                builder: (context, profileNitifier, child) {
                  if (loggedIn == true && widget.drawer == true) {
                    // Always refresh profile data when accessed from drawer
                    userProfile = profileNitifier.getProfile(forceRefresh: true);
                  }
                  return FutureBuilder<ProfileRes>(
                      future: userProfile,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Image.asset("assets/images/jobLoader.gif"),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Error ${snapshot.error}");
                        } else {
                          final userData = snapshot.data;
                          return buildStyleContainer(
                            context,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Container(
                                    width: width,
                                    height: hieght * 0.12,
                                    color: Color(kLight.value),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const CircularAvata(
                                                w: 50,
                                                h: 50,
                                                image:
                                                    "https://ui-avatars.com/api/?name=Profile&background=0D8ABC&color=fff&size=128",
                                              ),
                                              const WidthSpacer(width: 20),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        userData?.username ??
                                                            "username",
                                                        style: appStyle(
                                                            18,
                                                            Color(kDark.value),
                                                            FontWeight.w600),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis),
                                                    const WidthSpacer(width: 5),
                                                    Text(
                                                        userData?.email ??
                                                            "email",
                                                        style: appStyle(
                                                            14,
                                                            Color(kDarkGrey.value),
                                                            FontWeight.normal),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => const ProfileUpdate());
                                          },
                                          child: const Icon(
                                            Feather.edit,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const HeightSpacer(size: 20),
                                  Stack(
                                    children: [
                                      Container(
                                        width: width,
                                        height: hieght * 0.12,
                                        decoration: BoxDecoration(
                                            color: Color(kLightGrey.value),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 12.w),
                                              width: 60.w,
                                              height: 70.h,
                                              decoration: BoxDecoration(
                                                  color: Color(kLight.value),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: const Icon(
                                                  FontAwesome5Regular.file_pdf,
                                                  color: Colors.red,
                                                  size: 40),
                                            ),
                                            const WidthSpacer(width: 20),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "Upload Your Resume",
                                                      style: appStyle(
                                                          16,
                                                          Color(kDark.value),
                                                          FontWeight.w500),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis),
                                                  Text(
                                                      "Please make sure to upload your resume in PDF format",
                                                      style: appStyle(
                                                          8,
                                                          Color(
                                                              kDarkGrey.value),
                                                          FontWeight.w500),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis),
                                                ],
                                              ),
                                            ),
                                            const WidthSpacer(width: 1)
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          right: 0.w,
                                          child: EditButton(
                                            onTap: () {},
                                          ))
                                    ],
                                  ),
                                  const HeightSpacer(size: 20),
                                  ReusableText(
                                      text: "Agent Information",
                                      style: appStyle(
                                          15, Colors.black, FontWeight.w600)),
                                  const HeightSpacer(size: 10),

                                  userData!.isAgent == true
                                      ? const AgentTile()
                                      : const SizedBox.shrink(),
                                  const HeightSpacer(size: 20),
                                  userData.skills == true
                                      ? const SkillsWidget()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ReusableText(
                                                text: "Add Skills",
                                                style: appStyle(
                                                    15,
                                                    Colors.black,
                                                    FontWeight.w600)),
                                            const Icon(
                                                MaterialCommunityIcons
                                                    .plus_circle_outline,
                                                color: Colors.black,
                                                size: 25),
                                          ],
                                        ),
                                  const HeightSpacer(size: 20),
                                  CustomOutlineBtn(
                                    width: width,
                                    hieght: 40,
                                    onTap: () {
                                      if (userData.isAgent == true) {
                                        Get.to(() => const UploadJobs());
                                      } else if (userData.isAgent == false) {
                                        Get.to(() => const AgencyApplication());
                                      }
                                    },
                                    color: Color(kOrange.value),
                                    text: userData.isAgent == true
                                        ? "Upload Job"
                                        : "Apply To Be an Agent",
                                  ),
                                  
                                  const HeightSpacer(size: 20),
                                  
                                  Consumer<LoginNotifier>(
                                    builder: (context, loginNotifier, child) {
                                      return CustomOutlineBtn(
                                        width: width,
                                        hieght: 40,
                                        onTap: () {
                                          loginNotifier.logout();
                                          zoomNotifier.currentIndex = 0;
                                          Get.offAll(() => const MainScreen());
                                        },
                                        color: Color(kOrange.value),
                                        text: "Logout",
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      });
                },
              ));
  }
}

class CircularAvata extends StatelessWidget {
  final double w;
  final double h;
  final String image;
  const CircularAvata({
    super.key,
    required this.w,
    required this.h,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(99)),
      child: CachedNetworkImage(
        width: w.w,
        height: h.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Image.network(image),
        imageUrl: image,
      ),
    );
  }
}
