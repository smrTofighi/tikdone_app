import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/data/models/user_model.dart';
import 'package:tikdone_app/data/providers/appwrite_provider.dart';

class ProfileModel {
late UserModel userModel;
 Rx<File?> image = File('').obs; // ذخیره فایل تصویر انتخاب شده
  final ImagePicker _picker = ImagePicker(); // نمونه از ImagePicker
  final _appwrite = locator<AppwriteProvider>();
  final _connectionChecker = locator<InternetConnectionChecker>();
  // متد برای انتخاب تصویر از گالری
  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      
        image.value = File(pickedFile.path); // تنظیم تصویر انتخاب شده
      
    }
  }
 
void setUserModel (UserModel model){
  userModel = model;
}
}