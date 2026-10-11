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

class MainCategoryModel {
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

  Future<Either<Failure, List<CategoryModel>>> getCategory(
      {required String userId}) async {
    try {
      if (await _connectionChecker.hasConnection) {
        DocumentList documentList = await _appwriteProvider.databases!
            .listDocuments(
                databaseId: AppwriteConfig.databaseId,
                collectionId: AppwriteConfig.categoryCollectionId,
                queries: [Query.equal("userId", userId)]);
        Map<String, dynamic> data = documentList.toMap();

        List list = data['documents'].toList();

        categoryList =
            list.map((e) => CategoryModel.fromJson(e['data'])).toList();

        for (final category in categoryList) {
          final completedTodos =
              await _appwriteProvider.databases!.listDocuments(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.todoCollectionId,
            queries: [
              Query.equal('categoryId', category.id),
              Query.equal(
                'userId',
                _storageService.getValue(
                  StorageKey.userId,
                ),
              ),
              Query.equal('isComplete', true),
            ],
          );
          final totalTodos = await _appwriteProvider.databases!.listDocuments(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.todoCollectionId,
            queries: [
              Query.equal('categoryId', category.id),
              Query.equal(
                'userId',
                _storageService.getValue(
                  StorageKey.userId,
                ),
              ), // فیلتر بر اساس userId
            ],
          );
          final int total = totalTodos.total;
          final int completed = completedTodos.total;
          //final double percentage = total > 0 ? (completed / total) * 100 : 0;
          category.totalTodos = total;
          category.completedTodos = completed;
        
        }
        return right(categoryList);
      } else {
        return left(Failure('Check Internet Connection'));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Document>> addCategory(
      {required String userId,
      required String title,
      required String icon,
      required String theme}) async {
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
            "id": documentId
          },
        );
        categoryList.add(CategoryModel(
            id: documentId,
            title: title,
            icon: icon,
            theme: theme,
            userId: userId));
        log(document.toString());
        return right(document);
      } else {
        return left(Failure('Check Internet Connection'));
      }
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
