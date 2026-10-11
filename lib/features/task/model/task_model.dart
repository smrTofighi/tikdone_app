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

class TaskModel {
  late CategoryModel categoryModel;

  final _appwrite = locator<AppwriteProvider>();
  final _connectionChecker = locator<InternetConnectionChecker>();
  final _storageService = locator<StorageService>();
  final RxString alarm = RxString('');
  final RxString description = RxString('');

  Future<Either<Failure, dynamic>> deleteTodo(
      {required String id, required bool isCompleted}) async {
    try {
      if (await _connectionChecker.hasConnection) {
        var document = await _appwrite.databases!.deleteDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          documentId: id,
        );

        if (isCompleted == false) {
          categoryModel.activeTodos!.removeWhere((element) => element.id == id);
        } else {
          categoryModel.unActiveTodos!
              .removeWhere((element) => element.id == id);
          categoryModel.completedTodos = categoryModel.completedTodos - 1;
        }
        categoryModel.totalTodos = categoryModel.totalTodos - 1;

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

  Future<Either<Failure, Document>> addTodo({
    required String title,
    required bool completed,
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
            "title": title,
            "description": description.value,
            "completed": completed, // اصلاح فیلد دیتابیس
            "important": false, // فیلد جدید اضافه شد
            'categoryId': categoryModel.id,
            "id": documentId,
          },
        );

        categoryModel.activeTodos!.add(
          TodoModel(
            id: documentId,
            title: title,
            description: description.value,
            categoryId: categoryModel.id,
            userId: _storageService.getValue(StorageKey.userId),
            completed: completed, // استفاده از نام جدید متغیر در مدل
            important: false,
          ),
        );
        categoryModel.totalTodos = categoryModel.totalTodos + 1;

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

  Future<Either<Failure, Document>> updateTodo({
    required String documentId,
    required String title,
    required bool isCompleted,
    required int index,
  }) async {
    try {
      if (await _connectionChecker.hasConnection) {
        Document document = await _appwrite.databases!.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          documentId: documentId,
          data: {
            "title": title,
            "completed": isCompleted, // اصلاح فیلد دیتابیس
            "description": description.value
          },
        );

        if (isCompleted == false) {
          categoryModel.activeTodos![index]
            ..title = title
            ..description = description.value;
        } else {
          categoryModel.unActiveTodos![index]
            ..title = title
            ..description = description.value;
        }
        log(document.data.toString());
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

  Future<Either<Failure, List<TodoModel>>> getTodoList() async {
    try {
      if (await _connectionChecker.hasConnection) {
        DocumentList responseActiveTodo =
            await _appwrite.databases!.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          queries: [
            Query.equal(
              'userId',
              _storageService.getValue(StorageKey.userId),
            ),
            Query.equal('categoryId', categoryModel.id),
            Query.equal('completed', false) // اصلاح فیلد در کوئری
          ],
        );

        DocumentList responseUnActiveTodo =
            await _appwrite.databases!.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          queries: [
            Query.equal(
              'userId',
              _storageService.getValue(StorageKey.userId),
            ),
            Query.equal('categoryId', categoryModel.id),
            Query.equal('completed', true) // اصلاح فیلد در کوئری
          ],
        );

        log(responseActiveTodo.documents.toString());

        // استفاده از fromJson مطابق با آپدیت مدل جدید
        categoryModel.unActiveTodos = responseUnActiveTodo.documents
            .map((doc) => TodoModel.fromJson(doc.data))
            .toList()
            .obs;

        categoryModel.activeTodos = responseActiveTodo.documents
            .map((doc) => TodoModel.fromJson(doc.data))
            .toList()
            .obs;

        return right(categoryModel.activeTodos! as List<TodoModel>);
      } else {
        return left(Failure('لطفا اتصال اینترنت خود را بررسی کنید'));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Document>> updateIsCompleted({
    required String id,
    required bool isComplete, // مقدار جدید تیک (true یا false)
  }) async {
    try {
      final document = await _appwrite.databases!.updateDocument(
        collectionId: AppwriteConfig.todoCollectionId,
        databaseId: AppwriteConfig.databaseId,
        documentId: id,
        data: {
          'completed': isComplete, // اصلاح فیلد دیتابیس
        },
      );

      // منطق تمیز و اصلاح‌شده برای جابجایی تسک بین لیست فعال و انجام‌شده
      if (isComplete) {
        // تسک انجام شد: انتقال از فعال به غیرفعال
        var todo = categoryModel.activeTodos!
            .firstWhere((element) => element.id == id);
        todo.completed = true;
        categoryModel.activeTodos!.remove(todo);
        categoryModel.unActiveTodos!.add(todo);
        categoryModel.completedTodos = categoryModel.completedTodos +
            1; // اضافه کردن به تعداد انجام شده‌ها
      } else {
        // تیک تسک برداشته شد: انتقال از غیرفعال به فعال
        var todo = categoryModel.unActiveTodos!
            .firstWhere((element) => element.id == id);
        todo.completed = false;
        categoryModel.unActiveTodos!.remove(todo);
        categoryModel.activeTodos!.add(todo);
        categoryModel.completedTodos =
            categoryModel.completedTodos - 1; // کسر از تعداد انجام شده‌ها
      }

      log(document.data.toString());
      return right(document);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
