import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/model/user_model.dart';

import '../constants/constant.dart';

final userApiProvider = Provider((ref) {
  return UserApi(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IUserApi {
  FutureEither saveUserData(UserModel usermodel);
}

class UserApi implements IUserApi {
  final Databases _db;
  UserApi({required Databases db}) : _db = db;
  @override
  FutureEither saveUserData(UserModel usermodel) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstant.databaseId,
        collectionId: AppWriteConstant.usersCollection,
        documentId: usermodel.uid,
        data: usermodel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
