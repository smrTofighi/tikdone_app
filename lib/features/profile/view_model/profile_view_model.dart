
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tikdone_app/features/auth/view_model/auth_view_model.dart';
import 'package:tikdone_app/features/profile/model/profile_model.dart';

class ProfileViewModel extends GetxController {
  late ProfileModel _model;
  final RxBool isEditing = false.obs;
  final TextEditingController nameEditingController = TextEditingController();
  ProfileModel get model => _model;
  ProfileViewModel() {
    _model = ProfileModel();
  }

  void setUserModel (){
    var userModel = Get.find<AuthViewModel>().model.userModel;
    nameEditingController.text= userModel.name;
    _model.setUserModel(userModel);
    update();
  }

  void setImage(){
    _model.pickImageFromGallery();
    update();
  }
  @override
  void onInit() {
    setUserModel();
    super.onInit();
  }
}
