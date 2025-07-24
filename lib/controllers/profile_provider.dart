import 'package:flutter/material.dart';
import 'package:jobhubv2_0/models/response/auth/profile_model.dart';
import 'package:jobhubv2_0/services/helpers/auth_helper.dart';

class ProfileNotifier extends ChangeNotifier {
  Future<ProfileRes>? _profile;
  
  Future<ProfileRes> getProfile({bool forceRefresh = false}) async {
    if (_profile == null || forceRefresh) {
      _profile = AuthHelper.getProfile();
    }
    return _profile!;
  }
  
  void refreshProfile() {
    _profile = null;
    notifyListeners();
  }
}
