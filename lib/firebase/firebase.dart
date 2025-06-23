import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:techgrains/com/techgrains/common/tg_log.dart';

class FirebaseSetup {
  static FirebaseSetup? _firebaseSetup; // Singleton DatabaseHelper
  FirebaseSetup._createInstance();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  factory FirebaseSetup() {
    _firebaseSetup ??= FirebaseSetup._createInstance();
    return _firebaseSetup!;
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    TGLog.d('User granted permission: ${settings.authorizationStatus}');
  }

  void initState() async {
    /// Get Token
    firebaseMessaging.getToken().then((String? token) async {
      String newToken = token ?? "";
      TGLog.d("getToken token : $newToken");
      if (newToken.isNotEmpty) {
        // Firebase token refresh
        await updateToken(newToken);
      }
    });

    firebaseMessaging.getAPNSToken().then((String? token) async {
      String newToken = token ?? "";
      TGLog.d("getAPNSToken token : $newToken");
    });

    /// Refresh Token Token
    firebaseMessaging.onTokenRefresh.listen((newToken) async {
      TGLog.d("onTokenRefresh newToken : $newToken");
      await updateToken(newToken);
    });

    /// When app is foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      TGLog.d("onMessage > Received message: ${json.encode(message.toMap())}");
      TGLog.d('Got a message whilst in the foreground!');
      TGLog.d("Message data: ${message.data}");
    });

    /// When app is background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      TGLog.d("onMessageOpenedApp > Received message: ${json.encode(message.toMap())}");
      TGLog.d('Message data: ${message.notification}');
      if (message.notification != null) {
        //When App in Background
        TGLog.d("When App in Background");
        onNotificationClicked(message.data);
      }
    });

    // when app is closed and it will be called only once
    firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      //app was killed and on notification clicked;
      if (message != null) {
        TGLog.d("getInitialMessage > Received message: ${json.encode(message.toMap())}");
        //When App is killed
        TGLog.d("When App is killed");
        //onNotificationClicked(message.data);
        Future.delayed(const Duration(milliseconds: 1600), () {
          onNotificationClicked(message.data);
        });
      }
    });

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  Future<void> updateToken(var newToken) async {
    // String savedToken = PreferenceManager.getInstance().getFirebaseToken() ?? "";
    // if (savedToken.isEmpty || newToken != savedToken) {
    //   TGLog.d("got new firebase Token : $newToken");
    //   await saveToken(newToken);
    //   // Firebase token refresh
    // }
  }

  Future<void> saveToken(String token) async {
    TGLog.d("Update firebase token");
    //await PreferenceManager.getInstance().saveFirebaseToken(token);
  }

  Future<void> eventTrack(dynamic message) async {
    TGLog.d("Notification : $message");
  }

  Future<void> onNotificationClicked(dynamic data) async {
    //NavigationBody.gotoOrderDetailScreen(data);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  //PreferenceManager.getInstance().saveNotificationUserInfo(json.encode(message.toMap()));
  TGLog.d("Handling a background message: ${json.encode(message.toMap())}");

  /// Only for android
  //if (Platform.isAndroid) await FirebaseSetup().showNotification(message);
  if (Platform.isAndroid) {
    //Navigate
  }

  return Future<void>.value();
}
