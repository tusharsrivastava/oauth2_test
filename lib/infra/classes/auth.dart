import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oauth_test/infra/interfaces/iauth.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

import '../../webview.dart';

// Dummy Login Credentials
// happy-oystercatcher@example.com
// Ashamed-Fowl-34

class OAuth implements IAuth {
  final authorizationEndpoint =
      Uri.parse('https://www.oauth.com/playground/auth-dialog.html');
  final tokenEndpoint = Uri.parse('https://authorization-server.com/token');
  final redirectUrl =
      Uri.parse("https://www.oauth.com/playground/authorization-code.html");

  final clientID = "J748MN1E4J-FamKb0ifZ1F-j";
  final clientSecret = "Y0QB8hb7lQ9EBaZ1xPxN_oGPJDsDFDuf4y7R9DI17SOrSR3J";

  oauth2.Client client;

  final BuildContext context;

  OAuth(this.context);

  Future _initClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var credString = prefs.getString("creds");

    print("Creds: $credString");

    if (credString != null) {
      var credentials = oauth2.Credentials.fromJson(credString);
      client = oauth2.Client(credentials,
          identifier: clientID, secret: clientSecret);
      return;
    }

    var grant = oauth2.AuthorizationCodeGrant(
      clientID,
      authorizationEndpoint,
      tokenEndpoint,
      secret: clientSecret,
    );

    print("Grant Created: ${grant.toString()}");

    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl,
        scopes: ["photo", "offline_access"], state: "IOKpzJC_hb5_90NY");

    print("Authorization URL: ${authorizationUrl.toString()}");

    var responseUrl = await redirectAndListen(authorizationUrl, redirectUrl);

    print("Response URL: ${responseUrl.toString()}");

    client =
        await grant.handleAuthorizationResponse(responseUrl.queryParameters);

    // Save the credentials
    prefs.setString("creds", client.credentials.toJson());
  }

  Future<Uri> redirectAndListen(Uri authorizationUrl, Uri redirectUrl) async {
    // Client implementation detail
    // Completer<Uri> _completer = new Completer<Uri>();
    var response = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) {
        return WebViewScreen(
          initialPageUrl: authorizationUrl,
          closeViewUrl: redirectUrl,
        );
      }),
    );
    return response;
  }

  @override
  Future startAuth() async {
    return await _initClient();
  }
}
