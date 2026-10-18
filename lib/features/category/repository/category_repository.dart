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
import 'package:tikdone_app/data/providers/appwrite_provider.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/services/storage_service.dart';

class CategoryRepository {
  //? a list of categories
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionChecker _connectionChecker =
      locator<InternetConnectionChecker>();
  final StorageService _storageService = locator<StorageService>();
  List<CategoryModel> categoryList = [];
  String errorMessage = '';

  Future<Either<Failure, void>> deleteCategory(
      {required String categoryId, required int index}) async {
    try {
      if (await _connectionChecker.hasConnection) {
        await _appwriteProvider.databases!.deleteDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.categoryCollectionId,
          documentId: categoryId,
        );
        final todosResponse = await _appwriteProvider.databases!.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          queries: [
            Query.equal('categoryId', categoryId),
          ],
        );
        for (var todo in todosResponse.documents) {
          await _appwriteProvider.databases!.deleteDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.todoCollectionId,
            documentId: todo.$id,
          );
        }
        categoryList.removeAt(index);
        return right(null);
      } else {
        return left(Failure('Check Your Internet Connection'));
      }
    } on AppwriteException catch (err) {
      return left(Failure(err.message!));
    } on ServerException catch (err) {
      return left(Failure(err.toString()));
    }
  }

  Future<Either<Failure, List<CategoryModel>>> getCategory({required String userId}) async {
    try {
      if (await _connectionChecker.hasConnection) {

        // ۱. دریافت همه دسته‌بندی‌های کاربر (یک درخواست)
        DocumentList categoryDocs = await _appwriteProvider.databases!.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.categoryCollectionId,
          queries: [Query.equal("userId", userId)],
        );

        // تبدیل داکیومنت‌ها به مدل
        List<CategoryModel> categories = categoryDocs.documents
            .map((e) => CategoryModel.fromJson(e.data))
            .toList();
        categoryDocs.documents.map((e)=>{
          log(e.data.toString())
        });

        // ۲. دریافت همه تسک‌های کاربر (فقط یک درخواست دوم)
        // نکته: اگر اپلیکیشن بزرگ شد، می‌توانید Query.limit() را اضافه کنید
        DocumentList todoDocs = await _appwriteProvider.databases!.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.todoCollectionId,
          queries: [Query.equal('userId', userId)],
        );

        // ۳. محاسبه و شمارش در داخل گوشی (بدون نیاز به اینترنت برای هر دسته)
        for (var category in categories) {
          // پیدا کردن تسک‌های مربوط به این دسته خاص
          final categoryTodos = todoDocs.documents
              .where((t) => t.data['categoryId'] == category.id)
              .toList();

          // شمردن کل تسک‌ها و تسک‌های تکمیل شده
          category.totalTodos = categoryTodos.length;
          category.completedTodos = categoryTodos
              .where((t) => t.data['completed'] == true)
              .length;
        }

        return right(categories);
      } else {
        return left(Failure('Check Internet Connection'));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message ?? 'خطای سرور Appwrite'));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('خطای نامشخص: ${e.toString()}'));
    }
  }

  Future<Either<Failure, Document>> addCategory(
      {required String userId,
      required String title,
      required int icon,
      required String theme,
      required bool pinToTop}) async {
    try {

      if (await _connectionChecker.hasConnection) {
        String documentId = ID.unique();
        Document document = await _appwriteProvider.databases!.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.categoryCollectionId,
          documentId: documentId,
          data: {
            "userId": userId,
            "title": title,
            "icon": icon,
            "theme": theme,
            "id": documentId,
            "pinToTop": pinToTop
          },
        );
        categoryList.add(CategoryModel(
            id: documentId,
            title: title,
            icon: icon,
            theme: theme,
            userId: userId));
       
        return right(document);
      } else {
        return left(Failure('Check Internet Connection'));
      }
    } on AppwriteException catch (e) {
      log(e.message!);
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
