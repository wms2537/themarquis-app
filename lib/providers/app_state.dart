import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:marquis_v2/env.dart';
import 'package:marquis_v2/models/app_state.dart';
import 'package:hive/hive.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part "app_state.g.dart";

final baseUrl = environment['apiUrl'];

@Riverpod(keepAlive: true)
class AppState extends _$AppState {
  Box<AppStateData>? _hiveBox;
  Timer? _refreshTokenTimer;
  @override
  AppStateData build() {
    _hiveBox ??= Hive.box<AppStateData>("appState");
    final result = _hiveBox!.get("appState", defaultValue: AppStateData())!;
    return result.copyWith(autoLoginResult: null);
  }

  void changeNavigatorIndex(int newIndex) {
    state = state.copyWith(navigatorIndex: newIndex);
    _hiveBox!.put("appState", state);
  }

  void changeTheme(String theme) {
    state = state.copyWith(theme: theme);
    _hiveBox!.put("appState", state);
  }

  void selectGame(String? id) {
    state = state.copyWith(
      selectedGame: id,
    );
    _hiveBox!.put("appState", state);
  }

  Future<void> login(String email) async {
    final url = Uri.parse('$baseUrl/auth/signin-sandbox');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //verify token
    state = state.copyWith(
        accessToken: decodedResponse['access_token'],
        refreshToken: decodedResponse['refresh_token'],
        autoLoginResult: true);
    await ref.read(userProvider.notifier).getUser();
    await _hiveBox!.put("appState", state);
  }

  Future<void> signup(String email, String referralCode) async {
    final url = Uri.parse('$baseUrl/auth/signup-sandbox');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw HttpException(
          'Request error with status code ${response.statusCode}.\nResponse:${utf8.decode(response.bodyBytes)}');
    }
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //verify token
    state = state.copyWith(
        accessToken: decodedResponse['access_token'],
        refreshToken: decodedResponse['refresh_token'],
        autoLoginResult: true);
    await ref.read(userProvider.notifier).getUser();
    await _hiveBox!.put("appState", state);
  }

  Future<void> verifyCode(String email, String code) async {
    final url = Uri.parse('$baseUrl/auth/verify-code');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email, 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );
    final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //verify token
    state = state.copyWith(
        accessToken: decodedResponse['access_token'],
        refreshToken: decodedResponse['refresh_token'],
        autoLoginResult: true);
    await ref.read(userProvider.notifier).getUser();
    await _hiveBox!.put("appState", state);
  }

  Future<void> logout() async {
    print("logout");
    state = state.copyWith(
      navigatorIndex: 0,
      accessToken: null,
      refreshToken: null,
      selectedGame: null,
    );
    _refreshTokenTimer?.cancel();
    _refreshTokenTimer = null;
    ref.read(userProvider.notifier).clearData();
    await _hiveBox!.put("appState", state);
  }

  Future<bool> tryAutoLogin() async {
    if (state.accessToken == null) {
      state = state.copyWith(autoLoginResult: true);
      return false;
    }
    // await refreshToken();
    await ref.read(userProvider.notifier).getUser();
    state = state.copyWith(autoLoginResult: true);
    return true;
  }

  void setConnectivity(bool val) {
    state = state.copyWith(isConnectedInternet: val);
  }

  void setAutoLogin(bool val) {
    state = state.copyWith(autoLoginResult: val);
  }

  Future<void> refreshToken() async {
    if (state.accessToken == null) return;
    // await ref.read(natsServiceProvider.notifier).resetConnection();
    // final response =
    //     await ref.read(natsServiceProvider.notifier).makeMicroserviceRequest(
    //           "auth.refreshToken",
    //           jsonEncode({
    //             "accessToken": state.token!.accessToken,
    //             "refreshToken": state.token!.id,
    //           }),
    //           isAuth: true,
    //         );
    // final json = jsonDecode(response) as Map<String, dynamic>;
    // final token = Token.fromJson(json["token"]);
    // final creds = json["creds"];
    // await ref
    //     .read(natsServiceProvider.notifier)
    //     .updateConnection(creds, token.user);

    state =
        state.copyWith(accessToken: state.accessToken, autoLoginResult: true);
    // _refreshTokenTimer = Timer(
    //   token.accessTokenExpiry.difference(
    //     DateTime.now(),
    //   ),
    //   () {
    //     refreshToken();
    //   },
    // );
    await _hiveBox!.put("appState", state);
  }

  // Future<void> requestChangePassword(String email) async {
  //   await ref.read(natsServiceProvider.notifier).makeMicroserviceRequest(
  //         "auth.requestChangePassword",
  //         jsonEncode({
  //           "email": email,
  //         }),
  //         isAuth: true,
  //       );
  // }
}
