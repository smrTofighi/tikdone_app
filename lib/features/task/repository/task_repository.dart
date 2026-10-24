import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tikdone_app/core/config/appwrite_config.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/errors/failure.dart';
import 'package:tikdone_app/core/errors/server_exception.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/models/todo_model.dart';
import 'package:tikdone_app/data/providers/appwrite_provider.dart';
import 'package:tikdone_app/data/services/storage_service.dart';

class TaskRepository {
  late CategoryModel categoryModel;

  final _appwrite = locator<AppwriteProvider>();
  final _connectionChecker = locator<InternetConnectionChecker>();
  final _storageService = locator<StorageService>();

  Future<Either<Failure, Document>> createTask({
    required String title,
    required String description,
    required String categoryId,
    required int priority,
    DateTime? dueDate,
    DateTime? remindAt,
  }) async {
    try {
      if (await _connectionChecker.hasConnection) {
        String documentId = ID.unique();

        Document document = await _appwrite.databases!.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          documentId: documentId,
          data: {
            "userId": _storageService.getValue(StorageKey.userId),
            "categoryId": categoryId,
            "id": documentId,
            "title": title,
            "description": description,
            "completed": false, // تسک جدید همیشه ناتمام است
            "priority": priority, // فیلد جدید
            "dueDate": dueDate?.toIso8601String(),
            "remindAt": remindAt?.toIso8601String(),
          },
        );

        return right(document);
      } else {
        return left(Failure('لطفا اتصال اینترنت خود را بررسی کنید'));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, List<TodoModel>>> getTasksByCategory(
      String categoryId) async {
    try {
      if (await _connectionChecker.hasConnection) {
        // دریافت داکیومنت‌ها از سرور بر اساس categoryId
        final response = await _appwrite.databases!.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          queries: [
            Query.equal('categoryId', categoryId),
            Query.equal('userId', _storageService.box.read(StorageKey.userId)),
            // اختیاری: برای اینکه تسک‌های جدیدتر بالاتر نشان داده شوند
            Query.orderDesc('\$createdAt'),
          ],
        );

        // تبدیل دیتای خام (JSON) سرور به لیست مدل‌های دارت
        final List<TodoModel> tasks = response.documents
            .map((doc) => TodoModel.fromJson(doc.data))
            .toList();

        return right(tasks);
      } else {
        return left(Failure('لطفاً اتصال اینترنت خود را بررسی کنید'));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('خطای نامشخص: ${e.toString()}'));
    }
  }

}
