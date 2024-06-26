import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test5/screen/signin_screen.dart';
import 'package:test5/screen/SettingPage.dart';
import 'package:test5/screen/HomeReal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDDwTpv01GKgKFb61RKUbwW8COn00psHL8',
        appId: '1:523124466650:android:3b718ad3d0c198ab9d96e3',
        messagingSenderId: '523124466650',
        projectId: 'my-listdrug-flutter-312e4',
        storageBucket: 'my-listdrug-flutter-312e4.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  checkAuthStatus();
}

Future<void> checkAuthStatus() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  Widget initialScreen;

  if (user != null) {
    // ถ้ามีผู้ใช้ล็อกอินอยู่แล้ว
    initialScreen = MyHomePage(title: 'Your App Title');
  } else {
    // ถ้าไม่มีผู้ใช้ล็อกอินอยู่ ให้ไปที่หน้า SignInScreen
    initialScreen = SignInScreen();
  }

  runApp(
    MaterialApp(
      home: initialScreen,
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? userName;

  @override
  void initState() {
    super.initState();
    getUserDisplayName().then((displayName) {
      setState(() {
        userName = displayName;
      });
    });
  }

  Future<String?> getUserDisplayName() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      try {
        await user.reload(); // รีเฟรชข้อมูลผู้ใช้
        user = auth.currentUser; // ดึงข้อมูลผู้ใช้ใหม่

        // ดึงข้อมูลจาก Firestore
        DocumentSnapshot<Map<String, dynamic>>? userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .get(); // ทำการ null check ก่อนการเรียกใช้ตัวแปร user

        if (userDoc != null && userDoc.exists) {
          // ถ้ามีข้อมูลใน Firestore
          return userDoc['username']; // ส่งคืนชื่อผู้ใช้จาก Firestore
        } else {
          // ถ้าไม่มีข้อมูลใน Firestore หรือ userDoc เป็น null
          return null; // ส่งคืนค่า null
        }
      } catch (e) {
        print('Error fetching user data: $e');
        return null; // ส่งคืนค่า null ในกรณีเกิดข้อผิดพลาด
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text("Hello"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                onPressSetting();
              },
              iconSize: 30.0,
            ),
          ),
          // สามารถเพิ่ม IconButton หรือ Widget อื่น ๆ ได้ตามต้องการ
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15.0), // ปรับความสูงตามที่ต้องการ
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(5.0), // ปรับตำแหน่งของ Text ตามต้องการ
              child: Text(
                userName ?? 'User', // ใช้ชื่อผู้ใช้ถ้ามีหรือใช้ 'User' ถ้าไม่มี
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomBody(title: widget.title),
      backgroundColor: const Color.fromARGB(255, 225, 246, 227),
    );
  }

  onPressSetting() {
    print("setting");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute(title: widget.title)),
    );
  }
}
