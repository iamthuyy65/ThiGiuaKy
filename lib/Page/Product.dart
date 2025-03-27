import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Login.dart';
import 'ProductListScreen.dart';

class ProductManagementScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productType;
  final int productPrice;
  final String productImage;

  ProductManagementScreen({
    this.productId = "",
    this.productName = "",
    this.productType = "",
    this.productPrice = 0,
    this.productImage = "",
  });

  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  String productId = "";
  String productName = "";
  String productType = "";
  String productImage = "";
  int productPrice = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  bool isEditing = false;

  // Đăng xuất
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.productId.isNotEmpty) {
      isEditing = true;
      productId = widget.productId;
      productName = widget.productName;
      productType = widget.productType;
      productPrice = widget.productPrice;
      productImage = widget.productImage;
      nameController.text = productName;
      typeController.text = productType;
      priceController.text = productPrice.toString();
      imageController.text = productImage;
    }
  }

  // Thêm sản phẩm
  void createData() {
    if (productName.isEmpty || productType.isEmpty || productPrice == 0 || productImage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin sản phẩm!")),
      );
      return;
    }

    FirebaseFirestore.instance.collection("Products").add({
      "productName": productName,
      "productType": productType,
      "productPrice": productPrice,
      "productImage": productImage,
    }).then((_) {
      // Sau khi thêm thành công, hiển thị thông báo và điều hướng về danh sách sản phẩm
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$productName đã được thêm thành công")),
      );

      // Điều hướng về màn hình danh sách sản phẩm
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductListScreen()), // Quay lại danh sách sản phẩm
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi thêm sản phẩm: $error")),
      );
    });
  }


  // Cập nhật sản phẩm
  void updateData() {
    if (productId.isEmpty) return;

    FirebaseFirestore.instance.collection("Products").doc(productId).update({
      "productName": productName,
      "productType": productType,
      "productPrice": productPrice,
      "productImage": productImage,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$productName đã được cập nhật thành công")),
      );

      // Sau khi cập nhật thành công, điều hướng về màn hình danh sách sản phẩm
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductListScreen()), // Quay lại danh sách sản phẩm
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi cập nhật: $error")),
      );
    });
  }


  // Xóa dữ liệu nhập
  void clearFields() {
    nameController.clear();
    typeController.clear();
    priceController.clear();
    imageController.clear();

    setState(() {
      productId = "";
      productName = "";
      productType = "";
      productPrice = 0;
      productImage = "";
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quản lý sản phẩm",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF9E15),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tên sản phẩm"),
              onChanged: (value) => productName = value,
            ),
            SizedBox(height: 10),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: "Loại sản phẩm"),
              onChanged: (value) => productType = value,
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Giá sản phẩm"),
              keyboardType: TextInputType.number,
              onChanged: (value) => productPrice = int.tryParse(value) ?? 0,
            ),
            SizedBox(height: 10),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: "URL hình ảnh"),
              onChanged: (value) => productImage = value,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF9E15),
                foregroundColor: Colors.white,
              ),
              onPressed: isEditing ? updateData : createData,
              child: Text(isEditing ? "Cập nhật sản phẩm" : "Thêm sản phẩm"),
            ),
          ],
        ),
      ),
    );
  }
}
