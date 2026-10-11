import 'package:appwrite/appwrite.dart';
import 'package:tikdone_app/core/config/appwrite_config.dart';

class AppwriteProvider {
  Client client = Client();
  Account? account;
  Databases? databases;

  AppwriteProvider() {
    client
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId)
        .setSelfSigned(status: true);
    account = Account(client);
    databases = Databases(client);
  }
}
