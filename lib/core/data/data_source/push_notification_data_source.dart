import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "fir-social-3f174",
    "private_key_id": "b491bda4fb342216c822d8fc1579e1ae7b49105e",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDZRiP0eFotDSr7\nTFkdacd1YGDOy44Zx43UIPcamXyqF5/+bP772pzFmYD0q7fs38H48di5du61qtZy\nE1CvV3ljCzLzTwNf9Wb91SkFGzfVOPNZMVeXWeS0x7fRUUbnY+dum8EPyETYf1WP\nyvzpPPAG4dhDRQRjSqQHysheRapBlcQFddkCsSK2XxxS1NkN6PuC7eN6ySuSiU7V\nMmF9xM36/6jC9rEEjDu6CD4LKN9xziBoZTm+zNfzYBuV9pZAAELa75emqzOg/MKs\nuFJP7/B2Ry3bmzkWog31yRK2J8u9sde/Xqih8/KOaHpLO3ARC0bSuQGV8OI5MgZG\nwpHnF93ZAgMBAAECggEAAkRFxKua7OXPz9sW12nBTad4Sb6sevb0CHVhv+aVGxJV\nG5gFbCPL11EP3A2XZRUxA9DkbPaRYeENl2yoPp9hShqa7kL3OFbaBhYlap2Ynk93\nqh5WXqMkEbbp2KPPeJjC2HUvb+PBRHJwoQfyDe4Hhtov5xoXBCuqTNVYCYlnxS3J\nllYZ+sByZ2EjEWYSTR5XCgLoJOMVzr1jdhoHe+YAVqUZsc/dNc00i6JcQFKe7n+W\nL2RZOR9MkzbKaF71m2mR/h3fjy3FkWEerRtHL71czvyh1Y8doQuSmaFqfZrgpLjs\nluL9LVRoN5N/bq21D0UkGBkH949rUtNWbx5dQUB6kQKBgQD3uN6D/G6qR76AQztm\nxjy/pOiGsS/izjTMvfRg5QXDq9yXK3jNaWBrn2ksibjAnHzMiFn+NYdj3Z0NK/AO\nbvwy9EiewHMvwZXR78fvV67GHarTOpZp+MlNJPWXxiJjsKYSyj6yQGjCqYvKOPMU\nGbfWJEaIynFDZD7Um9q8NpgwaQKBgQDgiM2xeD0DoO0LQLzdP6XPPrjHx5gOj94t\nAWtuoLVXWwBOlBWWOX4Wpnl7LpTEGVECYe1EMLHqxiMNOvmq85mGolKI/O9ckj8O\n+2Rhhxyn+f8BRZFWKaTHKtbGBK3+WL+0vZ4e+xcgvGPecz0VgQZj0I0gKVngu7WU\n0GCOrRaT8QKBgAfhjMq8LDUkpS3lda1WXzZlo7QtTO21S767yFuQzbck75arnmNC\nl/u0jZ8KHqOaFupW6C4LO+x0b3usyy1aYJGqbekHDGMXkJGmREEcFAZfiUDBG2nx\nrU3UADA88HkldJMidg4ruGmBBV6Ao1MfYlbgvpG5hxLyzIDtGG9meT8JAoGAawwt\n7NdjV3CIst25bU4j8gt4Mx8QepjSluhfXM3Xxv8GxW/KXuWoHIpfzn+lw1xCh/1C\nDkmc+U5fdbZRQ9SBtHN9H/xe7eZ3k9/8upac7eS9U9Dj+o0+FwpwfNXMUj/jnfrt\nAN4654uJnYuZasAp2LqcHeI5DHDRoFI8Rql04zECgYEAhSKvylFgs0LskObvj44x\nkRvdHS/jfX+JcRd1KN4Y/19EHtj6hyEJefEBCXXxo9zisuXfxKtiTZhWumYnQSDh\nOpZeTnvE65ay2mg0dLkYNMFVRDWaKMKw6BQZk4ouI7wulq4EEq6mwdWJsrJEg4sC\njh6WtuqrYOqThd1MPxIFjEk=\n-----END PRIVATE KEY-----\n",
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
  List<String> scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

  var client = await clientViaServiceAccount(
    ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );
  AccessCredentials credentials =
      await obtainAccessCredentialsViaServiceAccount(
          ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);
  client.close();
  return credentials.accessToken.data;
}

Future<void> sendFCMMessage({
  required String fcmToken,
  required String title,
  required String body,
  required String route,
}) async {
  final String serverKey = await getAccessToken(); // Your FCM server key
  const String fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/fir-social-3f174/messages:send';

  final Map<String, dynamic> message = {
    'message': {
      'token': fcmToken,
      'notification': {'title': title, 'body': body},
      'data': {
        'route': route,
      },
    }
  };

  final response = await post(
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
      print('Failed to send FCM message: ${response.body}');
    }
  }
}
