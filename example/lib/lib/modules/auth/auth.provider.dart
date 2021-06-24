import 'dart:async';
import 'dart:convert';
import 'package:oniru_server/modules/authority/authority.service.dart';
import 'package:oniru_server/modules/user/models/user.dart';
import 'package:oniru_server/modules/user/user.service.dart';
import 'package:oniru_server/shared/util/hash.dart';
import 'package:shelf/shelf.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../shared/config.dart';
import '../authority/models/authority.dart';
import 'user.info.model.dart';

abstract class AuthProvider {
  static UserService _userService = UserService();
  static AuthorityService _authorityService = AuthorityService();
  static JsonDecoder _decoder = const JsonDecoder();

  static List<String> excluded = <String>['properties/ref'];

  static FutureOr<Response> handle(Request request) async =>
      (request.url.toString() == 'login')
          ? AuthProvider.auth(request)
          : AuthProvider.verify(request);

  static FutureOr<Response> auth(Request request) async {
    try {
      dynamic data = _decoder.convert(await request.readAsString());
      String user = data['login'] as String;
      String hash = Hash.create(data['password'] as String);
      User _userModel = await _userService.findByEmailPassword(user, hash);

      List<Authority> _authorities =
          await _authorityService.findAllByUserId(_userModel.id);

      JwtClaim claim = JwtClaim(
        subject: _userModel.id.toString(),
        issuer: 'Oniru',
        audience: <String>['oniruestates.com'],
      );

      String token = issueJwtHS256(claim, Config.secret);

      UserInfoModel _userInfoModel = UserInfoModel(
          authorities: _authorities, user: _userModel, token: token);
      return Response.ok(_userInfoModel.toJson());
    } catch (e) {
      return Response(401, body: 'Incorrect username/password');
    }
  }

  static FutureOr<Response> verify(Request request) async {
    if (checkExcluded(request.url.path)) {
      return null;
    }
    try {
      String token = request.headers['Authorization'].replaceAll('Bearer ', '');
      JwtClaim claim = verifyJwtHS256Signature(token, Config.secret);
      claim.validate(issuer: 'Oniru', audience: 'oniruestates.com');
      return null;
    } catch (e) {
      return Response.forbidden('Authorization rejected');
    }
  }

  static bool checkExcluded(String uri) {
    return excluded.contains(uri) ? true : false;
  }
}
