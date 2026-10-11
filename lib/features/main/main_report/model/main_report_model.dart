import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tikdone_app/core/config/appwrite_config.dart';
import 'package:tikdone_app/core/config/storage_key.dart';
import 'package:tikdone_app/core/errors/failure.dart';
import 'package:tikdone_app/core/errors/server_exception.dart';
import 'package:tikdone_app/core/locator/locator.dart';
import 'package:tikdone_app/data/models/category_model.dart';
import 'package:tikdone_app/data/providers/appwrite_provider.dart';
import 'package:tikdone_app/data/services/storage_service.dart';

class MainReportModel {
  List<CategoryModel> categoryList = [];
  final AppwriteProvider _appwriteProvider = locator<AppwriteProvider>();
  final InternetConnectionChecker _connectionChecker =
      locator<InternetConnectionChecker>();
  final StorageService _storageService = locator<StorageService>();
  Future<Either<Failure, void>> getCategoryAndTodos() async {
    try {
      if (await _connectionChecker.hasConnection) {
        String userId = _storageService.getValue(StorageKey.userId);
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
          final activeTodos = await _appwriteProvider.databases!.listDocuments(
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
              Query.equal('isComplete', false),
            ],
          );
          category.totalTodos = activeTodos.total;
        }
        return right(null);
      } else {
        return left(Failure('Check your internet connection!'));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } on AppwriteException catch (e) {
      return left(Failure(e.message!));
    }
  }
}
