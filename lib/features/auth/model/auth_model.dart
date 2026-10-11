import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tikdone_app/core/config/appwrite_config.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/errors/failure.dart';
import 'package:tikdone_app/core/errors/server_exception.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/data/models/user_model.dart';
import 'package:tikdone_app/data/providers/appwrite_provider.dart';
import 'package:tikdone_app/data/services/storage_service.dart';

class AuthModel {
  final _connectionChecker = locator<InternetConnectionChecker>();
  final _appwrite = locator<AppwriteProvider>();
  final _storageService = locator<StorageService>();
  late UserModel userModel;



/// Attempts to log in a user with the provided email and password.
/// 
/// This function checks for an internet connection before proceeding to create
/// an email-password session using the Appwrite account service. If successful,
/// it stores the userId and sessionId in the storage service.
/// 
/// It also retrieves and updates the user's profile information, including
/// their name, email, and profile image from the user document.
/// 
/// Returns a `Future` that resolves to an `Either` containing a `Session` on
/// success or a `Failure` with an error message on failure.
/// 
/// Possible failure reasons include lack of internet connection or exceptions
/// from Appwrite services.

  Future<Either<Failure, Session>> logInUser(
      {required String email, required String password}) async {
    try {
      if (await _connectionChecker.hasConnection) {
        var session = await _appwrite.account!.createEmailPasswordSession(
          email: email,
          password: password,
        );
        _storageService.setValue(StorageKey.userId, session.userId);
        _storageService.setValue(StorageKey.sessionId, session.$id);
        final String userId = session.userId;

        // جستجو در جدول 'user' برای پیدا کردن تصویر پروفایل
        final Document userDocument = await _appwrite.databases!.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.userCollectionId, // جدول user
          documentId: userId, // شناسه کاربر
        );

        final User user = await _appwrite.account!.get();
        userModel = UserModel(
            name: user.name,
            email: user.email,
            image: userDocument.data['profile_image']);
        return right(session);
      } else {
        return left(Failure("Check Your Internet Connection"));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }


  /// Creates a new user and signs them in.
  ///
  /// Returns a [User] with the created user's information on success or a
  /// [Failure] with an error message on failure.
  ///
  /// Possible failure reasons include lack of internet connection or exceptions
  /// from Appwrite services.
  Future<Either<Failure, User>> signInUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      log(email);
      if (await _connectionChecker.hasConnection) {
        var user = await _appwrite.account!.create(
            userId: ID.unique(),
            email: email,
            password: password,
            name: "$firstName $lastName");
        await _appwrite.databases!.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.userCollectionId,
          documentId: user.$id,
          data: {
            "id": user.$id,
            "first_name": firstName,
            "last_name": lastName,
            "full_name": "$firstName $lastName",
            "email": email
          },
        );
        log(user.email.toString());
        return right(user);
      } else {
        return left(Failure("Check Your Internet Connection"));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  /// Checks if the user is currently logged in and returns the session on success
  /// or a [Failure] with an error message on failure.
  ///
  /// Possible failure reasons include lack of internet connection or exceptions
  /// from Appwrite services.
  ///
  /// If the user is logged in, this function also fetches the user's name, email,
  /// and profile image from the 'user' collection and stores them in [userModel].
  ///
  Future<Either<Failure, Session>> checkSession() async {
    try {
      if (await _connectionChecker.hasConnection) {
        final Session session =
            await _appwrite.account!.getSession(sessionId: "current");
        final User user = await _appwrite.account!.get();
        final String userId = session.userId;

        // جستجو در جدول 'user' برای پیدا کردن تصویر پروفایل
        final Document userDocument = await _appwrite.databases!.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.userCollectionId, // جدول user
          documentId: userId, // شناسه کاربر
        );
        userModel = UserModel(
            name: user.name,
            email: user.email,
            image: userDocument.data['profile_image']);
        log("${userModel.name} ${userModel.email} ${userModel.image}");
        return right(session);
      } else {
        return left(Failure("Check Your Internet Connection"));
      }
    } on AppwriteException catch (e) {
      log(e.message!);
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      log(e.message);
      return left(Failure(e.message));
    }
  }
}
