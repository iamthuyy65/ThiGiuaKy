import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Product.dart'; // Import trang quản lý sản phẩm
class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách sản phẩm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        backgroundColor: Color(0xFFFF9E15),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Products").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    // Hình ảnh sản phẩm
                    Expanded(
                      flex: 3,
                      child: doc["productImage"] != null && doc["productImage"].isNotEmpty
                          ? Image.network(doc["productImage"], height: 100, width: 100, fit: BoxFit.cover)
                          : Icon(Icons.image, size: 50),
                    ),
                    // Thông tin sản phẩm
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc["productName"], style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Loại: ${doc["productType"]}"),
                            Text("Giá: ${doc["productPrice"]}"),
                          ],
                        ),
                      ),
                    ),
                    // Nút sửa và xóa sản phẩm
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Khi nhấn sửa, chuyển đến trang quản lý sản phẩm với thông tin sản phẩm
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductManagementScreen(
                              productId: doc.id,
                              productName: doc["productName"],
                              productType: doc["productType"],
                              productPrice: doc["productPrice"],
                              productImage: doc["productImage"],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Xóa sản phẩm
                        FirebaseFirestore.instance.collection("Products").doc(doc.id).delete().then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sản phẩm đã được xóa")));
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi xóa: $error")));
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
