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

  @override
  Widget build(BuildContext context) {
    var jobsNotifier = Provider.of<JobsNotifier>(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(text: "", child: BackBtn()),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
              height: 100,
              decoration: BoxDecoration(
                  color: Color(kOrange.value),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: "Job Uploads",
                      style: appStyle(14, Colors.white, FontWeight.w600)),
                  imageUrl.text.isNotEmpty && imageUrl.text.contains('https://')
                      ? Consumer<JobsNotifier>(
                          builder: (context, jobsNotifier, child) {
                            return CircularAvata(
                                w: 20, h: 20, image: jobsNotifier.logo);
                          },
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
          Positioned(
              top: 80,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Color(0xFFFBFBFB),
                ),
                child: ListView(
                  children: [
                    const HeightSpacer(size: 10),
                    buildtextfield(
                        hintText: "Job Title",
                        controller: title,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),
                    buildtextfield(
                        hintText: "Company",
                        controller: company,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 0.65,
                          child: Consumer<JobsNotifier>(
                            builder: (context, jobsNotifier, child) {
                              return buildtextfield(
                                  hintText: "Logo URL (or use upload button)",
                                  controller: imageUrl,
                                  onChanged: (value) =>
                                      {jobsNotifier.setLogo(imageUrl.text)},
                                  onSubmitted: (value) {
                                    if (value!.isEmpty &&
                                        imageUrl.text.contains('https://')) {
                                      return "Please fill this field";
                                    } else {
                                      return null;
                                    }
                                  });
                            },
                          ),
                        ),
                        SizedBox(
                          width: width * 0.25,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // Show loading
                              Get.snackbar(
                                "Uploading", 
                                "Please wait while we upload your image...",
                                backgroundColor: Color(kOrange.value),
                                colorText: Colors.white,
                              );
                              
                              // Upload image
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
                            icon: const Icon(Icons.upload_file, size: 16),
                            label: const Text("Upload", style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(kOrange.value),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    buildtextfield(
                        hintText: "Location",
                        controller: location,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),

                        buildtextfield(
                        hintText: "Contract",
                        controller: contract,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReusableText(
                          text: "Salary Options",
                          style: appStyle(12, Colors.black, FontWeight.w600)),
                    ),
                    SizedBox(
                        height: 30,
                        child: Consumer<JobsNotifier>(
                          builder: (context, jobsNotifier, child) {
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: jobsNotifier.salaries.length,
                              itemBuilder: (context, index) {
                                var data = jobsNotifier.salaries[index];
                                return ChoiceChip(
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  visualDensity: VisualDensity.standard,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  label: Text(
                                    data['title'],
                                    style: appStyle(
                                        10, Colors.black, FontWeight.w500),
                                  ),
                                  selected: data['isSelected'],
                                  selectedColor: Color(kOrange.value),
                                  onSelected: (newState) {
                                    jobsNotifier.toggleCheck(index);
                                    jobsNotifier.selectedSalary = data['title'];
                                  },
                                );
                              },
                            );
                          },
                        )),
                    const HeightSpacer(size: 10),
                    buildtextfield(
                        hintText: "Salary Range",
                        controller: salary,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),
                    const HiringSwitcher(text: "Hiring Status"),
                    buildtextfield(
                        hintText: "Description",
                        maxLines: 3,
                        controller: description,
                        onSubmitted: (value) {
                          if (value!.isEmpty && value.length < 50) {
                            return "Description should have more than 50 characters";
                          } else {
                            return null;
                          }
                        }),
                    ReusableText(
                        text: "Requirements",
                        style: appStyle(14, Colors.black, FontWeight.w600)),
                    const HeightSpacer(size: 10),
                    buildtextfield(
                        hintText: "Requirements",
                        maxLines: 2,
                        controller: requirements1,
                        onSubmitted: (value) {
                          if (value!.isEmpty && value.length < 50) {
                            return "Description should have more than 50 characters";
                          } else {
                            return null;
                          }
                        }),
                    buildtextfield(
                        hintText: "Requirements",
                        maxLines: 2,
                        controller: requirements2,
                        onSubmitted: (value) {
                          if (value!.isEmpty && value.length < 50) {
                            return "Description should have more than 50 characters";
                          } else {
                            return null;
                          }
                        }),
                    buildtextfield(
                        hintText: "Requirements",
                        maxLines: 2,
                        controller: requirements3,
                        onSubmitted: (value) {
                          if (value!.isEmpty && value.length < 50) {
                            return "Description should have more than 50 characters";
                          } else {
                            return null;
                          }
                        }),
                    buildtextfield(
                        hintText: "Requirements",
                        maxLines: 2,
                        controller: requirements4,
                        onSubmitted: (value) {
                          if (value!.isEmpty && value.length < 50) {
                            return "Description should have more than 50 characters";
                          } else {
                            return null;
                          }
                        }),
                    buildtextfield(
                        hintText: "Requirements",
                        maxLines: 2,
                        controller: requirements5,
                        onSubmitted: (value) {
                          if (value!.isEmpty && value.length < 50) {
                            return "Description should have more than 50 characters";
                          } else {
                            return null;
                          }
                        }),
                    const HeightSpacer(size: 20),
                    CustomOutlineBtn(
                      width: width,
                      hieght: 40,
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
                            requirements: [
                              requirements1.text,
                              requirements2.text,
                              requirements3.text,
                              requirements4.text,
                              requirements5.text
                            ]);

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
                      text: "Upload Job",
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
