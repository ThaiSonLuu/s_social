import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "fir-social-3f174",
    "private_key_id": "2cb18fb570df4cf2b5f2d1b870e834f6e16af962",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC2qPp1ZrNx7Ewb\n2hT64uqfR+i4O4I9g0FeFI+Hb42Vr52xJagzl8zgh5eeyNJx2pWSiCNATn7acrvF\n/s1LyKm+fdzMn8wL68IX/GCs2x8L9bUi7oSul62lwIZFWeu7TCQP2oLZkzteN4ZD\nEP+tjg0s0yoSD9aRZp9n8wVTgxfduQYj61HH18sawVtaqWNpvhmtht8DJiJGTnJX\nzhB16sb6yjE8o3LIbFqYWaDdCi0enXHkHWLNyKymuTZtiWDkuABWLPXhm13N4YWe\nGFtLBFMwuumRZiO3P1m7tbJpox1d8I9KBHp4uQRk5LZ2JFF4JjU+yCzikGtoHkRj\nAFkNQ0OnAgMBAAECggEAALLuCbphlYFgVPjzm38xlQUaggWwaPrHRQfxSFAP19uQ\nZhCq+ohASn8siQ8hJceFU7kyf4qd52gNS8lDJMZ9f+2JH/KQqFW1stHVFIZ0ic2B\nSYnYbDuA3ithjAMLVSKtXYuc5zjRb7wmnzdRNi15VktZUcbkHgok2dYzhJXTDpJk\nsL/NtiJ3u/LJMZ80YVBiNrP0PjySGEmMs/kS4X3/2b2wIf2udODXZXIp68Bkv3w3\nalsoJp+ahy87uY7tLDxHUfdalujNJ+TKwJWzU2bX9H/jd8PECFSs9cQfwaWXTATu\nFz8ndaMQ+swzfBGeQktqy2Ejo9rgBQV4yvA4b9eEjQKBgQDmrVl8zzQFqme6unUV\nIXCLw1B+4KD/r0+4k6joRzCQoyVf522ykII9Teud8HUTnPBMW4+SbWdFTQrQLq3Z\nbx6YkwPCnfbyvGprDuUfoBHrwSokQxXj+cTyDwBDot0DqqYviVZza5HJUNfiUAng\n8bxK+lKnsSq1N0por8mg2TFv/QKBgQDKtjgpe1WisWqbi5wYG0aFZVU/yLNwLV4P\nYy7K/Z7zfxme4gurMfXoejTtjjjAAiBSBiFns5UeLBxRwpEAVUOLu/7v7/mb1XKk\nf1rj8qeW5/1dPF5uSHfoduxyVju2O5GUQCyuik1ODLzB2a6r0oPEdTW7y7iY9NGD\ndF3HgUtZcwKBgFZ8Ka/kk5GIOQnGPH1moyaTXMuk9lfGZ7JBEjO79RZVRH73aqZn\nDZ1kaHE3pP1sep92OJbik7Rk1SgGSEHcKnFztRYzWVHamF95HyhDQFTOgDlGOZ/W\nliNWwneZSRnF0jbCW/o8G1WKDNaZwYpnt3u47GJYxzVX/HrRZVv78lAVAoGACeXb\n2Cqtg8Ql8HJgrMyoJNtNzk9+c3vDm/y7zC2WFU2fcqKW70UBPNi6vN605qsz6M1j\n1Cxwm4iL2XImol2Hbss/J3gQOAu0DVQqm/a9OCEbvfG0qq3fLPqhkPOk9sDx2stH\nYz5dh/IXRV/bp4gf5vfSJ9lKqi1KDaEg8xzdEQECgYEA0URyCXOne4IPWuv9ZUnV\n0y52W0doAl+P5cjSfwBd/Xv8wmr7okWnvu5s0pIy+/ST9rxWkGIoS5eFtXY1YFMh\nZkxjQinvBQbP2g/znpEqM2fVrKC40HZQnK7iEAhlFvy7Nhw2AHeNnMsHm6t5Z1oh\naMue+tk3nGudAfQMp284RmM=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-wvz0k@fir-social-3f174.iam.gserviceaccount.com",
    "client_id": "109794639275476251985",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-wvz0k%40fir-social-3f174.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };
  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
  ];
  var client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );
  auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);
  client.close();
  return credentials.accessToken.data;
}

Future<void> sendFCMMessage({
  required String fcmToken,
  required String title,
  required String body,
}) async {
  final String serverKey = await getAccessToken(); // Your FCM server key
  const String fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/fir-social-3f174/messages:send';
  final currentFCMToken = await FirebaseMessaging.instance.getToken();

  final Map<String, dynamic> message = {
    'message': {
      'token': fcmToken,
      'notification': {'title': title, 'body': body},
      'data': {
        'current_user_fcm_token': currentFCMToken,
      },
    }
  };

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print('FCM message sent successfully');
    }
  } else {
    if (kDebugMode) {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }
}
