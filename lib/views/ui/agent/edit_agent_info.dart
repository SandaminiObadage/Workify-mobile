import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/models/request/agents/createAgent.dart';
import 'package:jobhubv2_0/services/helpers/agents_helper.dart';
import 'package:jobhubv2_0/views/common/BackBtn.dart';
import 'package:jobhubv2_0/views/common/app_bar.dart';
import 'package:jobhubv2_0/views/common/custom_outline_btn.dart';
import 'package:jobhubv2_0/views/common/exports.dart';
import 'package:jobhubv2_0/views/common/height_spacer.dart';
import 'package:jobhubv2_0/views/ui/jobs/widgets/textfield.dart';
import 'package:jobhubv2_0/views/ui/mainscreen.dart';

class EditAgency extends StatefulWidget {
  const EditAgency({super.key});

  @override
  State<EditAgency> createState() => _EditAgencyState();
}

class _EditAgencyState extends State<EditAgency> {
  TextEditingController company = TextEditingController(text: agentInfo!.company);
  TextEditingController hqAddress = TextEditingController(text:  agentInfo!.hqAddress);
  TextEditingController workingHrs = TextEditingController(text:  agentInfo!.workingHrs);

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
              height: 100,
              decoration: BoxDecoration(
                  color: Color(kOrange.value),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: ReusableText(
                  text: "Edit Information",
                  style: appStyle(16, Colors.white, FontWeight.w600)),
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
                        hintText: "Company Name",
                        controller: company,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),
                    buildtextfield(
                        hintText: "HQ Address",
                        controller: hqAddress,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),
                    buildtextfield(
                        hintText: "Working Hours",
                        controller: workingHrs,
                        onSubmitted: (value) {
                          if (value!.isEmpty) {
                            return "Please fill this field";
                          } else {
                            return null;
                          }
                        }),
                    const HeightSpacer(size: 20),
                    CustomOutlineBtn(
                      width: width,
                      hieght: 40,
                      onTap: () {

                        CreateAgent model = CreateAgent(
                            uid: userUid,
                            company: company.text,
                            hqAddress: hqAddress.text,
                            workingHrs: workingHrs.text);

                        var newModel = createAgentToJson(model);

                        AngenciesHelper.updateAgentInfo(newModel);
                        Get.to(() => const MainScreen());
                      },
                      color: Color(kOrange.value),
                      color2: Colors.white,
                      text: "Submit",
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
