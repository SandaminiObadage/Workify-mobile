import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhubv2_0/constants/app_constants.dart';
import 'package:jobhubv2_0/controllers/zoom_provider.dart';
import 'package:jobhubv2_0/models/request/auth/profile_update_model.dart';
import 'package:jobhubv2_0/models/response/auth/skills.dart';
import 'package:jobhubv2_0/services/firebase_services.dart';
import 'package:jobhubv2_0/services/helpers/auth_helper.dart';
import 'package:jobhubv2_0/views/ui/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  FirebaseServices _services = FirebaseServices();
  late Future<List<Skills>> skills;
  bool _obscureText = true;
  bool _loader = false;

  bool get obscureText => _obscureText;

  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool get loader => _loader;

  set setLoader(bool newState) {
    _loader = newState;
    notifyListeners();
  }

  bool? _entrypoint;

  bool get entrypoint => _entrypoint ?? false;

  set entrypoint(bool newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  bool? _loggedIn;

  bool get loggedIn => _loggedIn ?? false;

  set loggedIn(bool newState) {
    _loggedIn = newState;
    notifyListeners();
  }

  getStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedIn = prefs.getBool('loggedIn') ?? false;
  }

  getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    entrypoint = prefs.getBool('entrypoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
    userUid = prefs.getString('uid') ?? '';
    name = prefs.getString('username') ?? '';
    profile = prefs.getString('profile') ?? '';
  }

  final loginFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = loginFormKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool profileValidation() {
    final form = profileFormKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  userLogin(model, ZoomNotifier zoomNotifier) {
    AuthHelper.login(model).then((response) {
      if (response) {
        setLoader = false;
        zoomNotifier.currentIndex = 0;
        Get.to(() => const MainScreen());
      } else if (!response) {
        setLoader = false;
        Get.snackbar("Sign Failed", "Please Check your credentials",
            colorText: Color(kLight.value),
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert));
      }
    });
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');
    
    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('profile');
    await prefs.remove('uid');
    await prefs.remove('username');
    
    // Clear user-specific resume URL
    if (uid != null && uid.isNotEmpty) {
      await prefs.remove('resumeUrl:$uid');
    }
  }

  updateProfile(ProfileUpdateReq model) async {
    try {
      bool response = await AuthHelper.updateProfile(model);
      if (response) {
        Get.snackbar("Profile Update", "Enjoy your search for a job",
            colorText: Color(kLight.value),
            backgroundColor: Color(kLightBlue.value),
            icon: const Icon(Icons.add_alert));

        Future.delayed(const Duration(seconds: 3)).then((value) {
          /// TODO: Navigate to home page
          // Get.to(() => const MainScreen());
        });
      } else {
        Get.snackbar("Update Failed", "Please try again",
            colorText: Color(kLight.value),
            backgroundColor: Color(kOrange.value),
            icon: const Icon(Icons.add_alert));
      }
    } catch (e) {
      Get.snackbar("Update Failed", "Error: ${e.toString()}",
          colorText: Color(kLight.value),
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error));
    }
  }

 Future<List<Skills>> getSkills() {
     skills = AuthHelper.getSkills();

    return skills;
  }
}
