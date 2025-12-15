import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/jobs_provider.dart';
import 'package:jobhubv2_0/models/request/jobs/create_job.dart';
import 'package:jobhubv2_0/services/helpers/jobs_helper.dart';
import 'package:jobhubv2_0/services/helpers/image_upload_helper.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/ui/auth/profile.dart';
import 'package:jobhubv2_0/views/ui/jobs/widgets/hiring_switcher.dart';
import 'package:jobhubv2_0/views/ui/jobs/widgets/textfield.dart';
import 'package:jobhubv2_0/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class UploadJobs extends StatefulWidget {
  const UploadJobs({super.key});

  @override
  State<UploadJobs> createState() => _UploadJobsState();
}

class _UploadJobsState extends State<UploadJobs> {
  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController contract = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController imageUrl = TextEditingController();
  TextEditingController requirements1 = TextEditingController();
  TextEditingController requirements2 = TextEditingController();
  TextEditingController requirements3 = TextEditingController();
  TextEditingController requirements4 = TextEditingController();
  TextEditingController requirements5 = TextEditingController();

  late final List<TextEditingController> _reqControllers;

  @override
  void initState() {
    _reqControllers = [
      requirements1,
      requirements2,
      requirements3,
      requirements4,
      requirements5,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var jobsNotifier = Provider.of<JobsNotifier>(context);
    Widget sectionCard({required String title, required IconData icon, required Widget child}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Color(kOrange.value)),
                const SizedBox(width: 8),
                ReusableText(
                  text: title,
                  style: appStyle(14, Color(kDark.value), FontWeight.w700),
                ),
              ],
            ),
            const HeightSpacer(size: 12),
            child,
          ],
        ),
      );
    }

    Widget requirementField(TextEditingController controller, int index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: buildtextfield(
            hintText: "Requirement ${index + 1}",
            maxLines: 2,
            controller: controller,
            onSubmitted: (value) {
              if (value!.isEmpty && value.length < 50) {
                return "Please add more detail";
              } else {
                return null;
              }
            }),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(text: "", child: BackBtn()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(kOrange.value), Color(kLightBlue.value)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: "Create a Job",
                        style: appStyle(18, Colors.white, FontWeight.w700)),
                    const HeightSpacer(size: 4),
                    ReusableText(
                        text: "Publish openings to your talent pool",
                        style: appStyle(12, Colors.white70, FontWeight.w500)),
                  ],
                ),
                if (imageUrl.text.isNotEmpty && imageUrl.text.contains('https://'))
                  Consumer<JobsNotifier>(
                    builder: (context, jobsNotifier, child) {
                      return CircularAvata(w: 36, h: 36, image: jobsNotifier.logo);
                    },
                  )
                else
                  const Icon(Icons.work_outline, color: Colors.white, size: 28)
              ],
            ),
          ),

          const HeightSpacer(size: 16),

          sectionCard(
            title: "Company & Role",
            icon: Icons.business_center_outlined,
            child: Column(
              children: [
                buildtextfield(
                    hintText: "Job Title",
                    controller: title,
                    onSubmitted: (value) => value!.isEmpty ? "Please fill this field" : null),
                buildtextfield(
                    hintText: "Company",
                    controller: company,
                    onSubmitted: (value) => value!.isEmpty ? "Please fill this field" : null),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Consumer<JobsNotifier>(
                        builder: (context, jobsNotifier, child) {
                          return buildtextfield(
                              hintText: "Logo URL (or use upload)",
                              controller: imageUrl,
                              onChanged: (value) => jobsNotifier.setLogo(imageUrl.text),
                              onSubmitted: (value) {
                                if (value!.isEmpty && imageUrl.text.contains('https://')) {
                                  return "Please fill this field";
                                } else {
                                  return null;
                                }
                              });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 110,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Get.snackbar(
                            "Uploading",
                            "Uploading your image...",
                            backgroundColor: Color(kOrange.value),
                            colorText: Colors.white,
                          );

                          String? uploadedUrl = await ImageUploadHelper.pickAndUploadImage('company_logos');

                          if (uploadedUrl != null) {
                            imageUrl.text = uploadedUrl;
                            Get.snackbar(
                              "Success",
                              "Image uploaded successfully!",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              "Error",
                              "Failed to upload image. Please try again.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        icon: const Icon(Icons.upload_file, size: 14),
                        label: const Text("Upload", style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(kOrange.value),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                buildtextfield(
                    hintText: "Location",
                    controller: location,
                    onSubmitted: (value) => value!.isEmpty ? "Please fill this field" : null),
                buildtextfield(
                    hintText: "Contract (e.g. Full-time)",
                    controller: contract,
                    onSubmitted: (value) => value!.isEmpty ? "Please fill this field" : null),
              ],
            ),
          ),

          sectionCard(
            title: "Compensation",
            icon: Icons.payments_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                    text: "Salary cadence",
                    style: appStyle(12, Color(kDarkGrey.value), FontWeight.w600)),
                const HeightSpacer(size: 8),
                SizedBox(
                    height: 34,
                    child: Consumer<JobsNotifier>(
                      builder: (context, jobsNotifier, child) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: jobsNotifier.salaries.length,
                          itemBuilder: (context, index) {
                            var data = jobsNotifier.salaries[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                labelPadding: const EdgeInsets.symmetric(horizontal: 14),
                                visualDensity: VisualDensity.compact,
                                label: Text(
                                  data['title'],
                                  style: appStyle(11, Colors.black, FontWeight.w600),
                                ),
                                selected: data['isSelected'],
                                selectedColor: Color(kOrange.value).withOpacity(0.14),
                                onSelected: (newState) {
                                  jobsNotifier.toggleCheck(index);
                                  jobsNotifier.selectedSalary = data['title'];
                                },
                                side: BorderSide(
                                  color: data['isSelected'] ? Color(kOrange.value) : Color(kLightGrey.value),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )),
                const HeightSpacer(size: 12),
                buildtextfield(
                    hintText: "Salary range (e.g. 45000 - 65000)",
                    controller: salary,
                    onSubmitted: (value) => value!.isEmpty ? "Please fill this field" : null),
                const HeightSpacer(size: 12),
                const HiringSwitcher(text: "Hiring Status"),
              ],
            ),
          ),

          sectionCard(
            title: "Job Story",
            icon: Icons.description_outlined,
            child: buildtextfield(
                hintText: "Describe the role, team, and impact",
                maxLines: 4,
                controller: description,
                onSubmitted: (value) {
                  if (value!.isEmpty && value.length < 50) {
                    return "Description should have more than 50 characters";
                  } else {
                    return null;
                  }
                }),
          ),

          sectionCard(
            title: "Requirements",
            icon: Icons.checklist_outlined,
            child: Column(
              children: List.generate(
                  _reqControllers.length,
                  (index) => requirementField(_reqControllers[index], index)),
            ),
          ),

          const HeightSpacer(size: 8),
          CustomOutlineBtn(
            width: width,
            hieght: 48,
            onTap: () async {
              CreateJobsRequest model = CreateJobsRequest(
                  title: title.text,
                  location: location.text,
                  company: company.text,
                  hiring: jobsNotifier.isSwitched,
                  description: description.text,
                  salary: salary.text,
                  period: jobsNotifier.selectedSalary,
                  contract: contract.text,
                  imageUrl: imageUrl.text,
                  agentId: userUid,
                  agentName: name,
                  requirements: _reqControllers.map((c) => c.text).toList());

              var newModel = createJobsRequestToJson(model);

              bool success = await JobsHelper.createJob(newModel);
              
              if (success) {
                Get.snackbar(
                  "Success", 
                  "Job uploaded successfully!",
                  colorText: Color(kLight.value),
                  backgroundColor: Color(kLightBlue.value),
                  icon: const Icon(Icons.check_circle)
                );
                Get.to(() => const MainScreen());
              } else {
                Get.snackbar(
                  "Error", 
                  "Failed to upload job. Please try again.",
                  colorText: Color(kLight.value),
                  backgroundColor: Colors.red,
                  icon: const Icon(Icons.error)
                );
              }
            },
            color: Color(kOrange.value),
            color2: Colors.white,
            text: "Publish Job",
          ),
        ],
      ),
    );
  }
}
