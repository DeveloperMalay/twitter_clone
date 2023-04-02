import 'dart:developer';
import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/model/user_model.dart';

import '../../../apis/user_api.dart';
import '../../home/view/home_view.dart';
import '../view/login_view.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authApi: ref.watch(authApiProvider), userApi: ref.watch(userApiProvider));
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  AuthController({required AuthApi authApi, required UserApi userApi})
      : _authApi = authApi,
        _userApi = userApi,
        super(false);
  final AuthApi _authApi;
  final UserApi _userApi;
  Future<model.Account?> currentUser() => _authApi.currentUserAccount();
  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.signUp(email: email, password: password);
    res.fold((
      l,
    ) {
      showSnackBar(
        context,
        l.message,
      );
      log(l.stackTrace.toString());
    }, (r) async {
      UserModel userModel = UserModel(
        email: email,
        name: getNameFromEmail(email),
        followers: const [],
        following: const [],
        profilePic: '',
        bannerPic: '',
        uid: r.$id,
        bio: '',
        isTwitterBlue: false,
      );
      final res2 = await _userApi.saveUserData(userModel);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Accounted created! Please login.');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginView()));
      });
    });
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
      },
    );
  }
}
