import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';

import '../config.dart';

int getUserIdFromToken(Request request) {
  String token = request.headers['Authorization'].replaceAll('Bearer ', '');
  JwtClaim claim = verifyJwtHS256Signature(token, Config.secret);
  return int.tryParse(claim.subject);
}
