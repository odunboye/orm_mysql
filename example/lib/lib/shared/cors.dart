import 'package:shelf/shelf.dart' as shelf;

class Cors {
  static const Map<String, String> corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': '*',
  };

  static shelf.Response _options(shelf.Request request) =>
      (request.method == 'OPTIONS')
          ? shelf.Response.ok(null, headers: corsHeaders)
          : null;
  static shelf.Response _cors(shelf.Response response) =>
      response.change(headers: corsHeaders);
  static shelf.Middleware fixCORS =
      shelf.createMiddleware(requestHandler: _options, responseHandler: _cors);
}
