import 'dart:async';

import 'package:camera/camera.dart';
import 'package:corproots/paymentReminders/payment_reminder_step1.dart';
import 'package:corproots/registered_users/updateProfile.dart';
import 'package:corproots/staff/dashboard.dart';
import 'package:corproots/staff/saved_document_types_all.dart';
import 'package:corproots/users/MyDocumentsUser.dart';
import 'package:corproots/users/payment_notifications_user.dart';
import 'package:corproots/users/update_enquiry_status.dart';
import 'package:corproots/web_admin/add_new_service_all.dart';
import 'package:corproots/web_admin/our_services.dart';
import 'package:corproots/web_admin/web_admin_dashboard.dart';
import 'package:corproots/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginSignup.dart';
import 'UserCheck.dart';
import 'admin/ListAllDepartments.dart';
import 'admin/addNewUser.dart';
import 'admin/admin_dash.dart';
import 'admin/assign_dept_al.dart';
import 'admin/assign_staff_enquiry.dart';
import 'admin/databaseAddingTesting.dart';
import 'admin/remindersLoading.dart';
import 'newEnquiry/patnershipFirm.dart';
import 'newEnquiry/pvtltdEnquiry.dart';
import 'newEnquiry.dart';
import 'otpEnter.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //print('Handling a background message ${message.messageId}');
  //print(message.notification.title);
  //print(message.notification.body);
}

AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'high Importance Notifications',
    'This channel is userd for important notifications.',
    importance: Importance.high);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

 // final cameras = await availableCameras();
 // final firstCamera = cameras.first;


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
/* camera intializing */
  WidgetsFlutterBinding.ensureInitialized();

  //prefs.setString('camera_available', firstCamera.toString());
/* ends here */
 // runApp(MyApp(firstCamera));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  //final availableCamera;

 // MyApp(this.availableCamera);

  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late var personalDetails;
  late var _userType;
  late Future str;
  late var loadPage;
  final _database = FirebaseDatabase.instance.reference();
  Timer? timer;

  cameraSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('availableCamera', widget.availableCamera.toString());
  }

  checkForReminder() async {}

  @override
  void initState() {
    super.initState();


    //timer = Timer.periodic(Duration(seconds: 15), (Timer t) => checkForReminder());

    // cronJobs();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
    getToken();
    cameraSet();
    // print(" STR is : " + str.toString());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Corp Roots',
        routes: {
          'loginSignup': (context) => LoginSignup(),
          'otpEnter': (context) => otpEnter(),
          'updateProfile': (context) => updateProfile(),
          'newEnquiry': (context) => newEnquiry(),
          //'pvtltdEnquiry': (context) => pvtltdEnquiry(),
          'patnershipFirm': (context) => PatnershipFirm(),
          'myRequests': (context) => Welcome(1),
          'myDocumentsUser': (context) => MyDocumentsUser(),
          'addNewUser': (context) => AddNewUser(),
          'listDepartments': (context) => ListAllDepartments(),
          'database-adding-testing': (context) => databaseAddingTesting(),
          'payment-notifications-user': (context) =>
              payment_notifications_user(),
          'remindersLoading': (context) => remindersLoading(),
          'payment-reminder-step1': (context) => payment_reminder_step1(),
          'userCheck': (context) => UserCheck(),
          'assign_staff' : (context) => assign_staff_enquiry(),
          'web_admin_dashboard' : (context) => web_admin_dashboard(),
          'our_services' : (context) => our_services(),
          'add-new-service' : (context) => add_new_service_all(),
          'assign_dept' : (context) => assign_dept_al(),
          'admin-dash' : (context) => AdminDash(),
          'staff_dash_load' : (context) => staffDash(),
          'saved_document_types' : (context) => saved_document_types_all()
        },
        theme: ThemeData(
          primaryColor: Colors.blue[800],
        ),
        // home: Dashboard(),
        //home: Welcome(0),
        home: UserCheck(),
      ),
    );
  }



  checkLoginUser() {
    switch (_userType) {
      case 'admin':
        {
          return AdminDash();
        }
        break;
      case 'normal_user':
        {
          return Welcome(0);
        }
        break;
      case 'staff':
        {
          return staffDash();
        }
        break;

      default:
        {
          return Welcome(0);
        }
    }
  }

  getToken() async {
    Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    String? token = await FirebaseMessaging.instance.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceId', token!);
    print("Token is : " + token);

    return "true";
  }
}
