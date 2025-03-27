import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        hintColor: Colors.cyanAccent,
        scaffoldBackgroundColor: Colors.grey[200],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trang Chủ",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Chữ in đậm
            fontSize: 20, // Tăng kích thước chữ
            color: Colors.white, // Màu chữ trắng
          ),
        ),
        backgroundColor: Color(0xFFFF9E15),
      ),
      body: Stack(
        children: [
          // Nền Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF042A55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  // Nút Quản lý sản phẩm
                  ElevatedButton.icon(
                    onPressed: () {
                      // Điều hướng đến trang quản lý sản phẩm
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductManagementScreen()),
                      );
                    },

                    icon: Icon(Icons.shopping_cart, size: 24, color: Colors.white), // Thêm màu trắng cho icon
                    label: Text(
                        "Quản lý sản phẩm",
                        style: TextStyle(fontSize: 18, color: Colors.white) // Thêm màu trắng cho chữ
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Color(0xFFFF9E15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5, // Hiệu ứng bóng đổ
                    ),

                  ),
                  SizedBox(height: 20),],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
