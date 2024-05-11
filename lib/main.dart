import 'package:flutter/material.dart';
import 'package:soecoreport/TQ_Tinh.dart';
import 'package:soecoreport/QLCB_Tinh.dart';
import 'package:soecoreport/BDDL_Tinh.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KTXT TVL',
      theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Image.asset(
                'assets/quochuy.png',
                fit: BoxFit.cover,
                height: 50.0,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text('BẢNG DỮ LIỆU KTXH TỈNH VĨNH LONG', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          backgroundColor: Color(0XFF2D9596),
        ),
        body: Column(
          children: [
            Container(
              color: Color(0XFF00224D),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                indicatorColor: Colors.white,
                labelStyle: TextStyle(fontSize: 18), // Đặt kiểu cho nhãn đã chọn
                tabs: [
                  Tab(text: 'KTXH Tỉnh Vĩnh Long', ),
                  Tab(text: 'Tổng quan'),
                  Tab(text: 'Biểu đồ dữ liệu'),
                  Tab(text: 'Quản lý cán bộ'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [

                  TitleWithImage(),
                  OverviewTabContent(), // Widget cho tab "Tổng quan"
                  DataChartTabContent(),
                  ManagementTabContent(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DistrictWidget extends StatelessWidget {
  final String districtName;

  DistrictWidget({required this.districtName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(districtName),
      onTap: () {
        // Hành động khi nhấn vào tên huyện
      },
    );
  }
}

//...................................ANH TONG QUAN NEN............................
class TitleWithImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Row(
            children: [
              _buildLogo(), // Thêm hình ảnh nhỏ
              SizedBox(width: 8.0), // Khoảng cách giữa hình ảnh và văn bản
              Text(
                'HỆ THỐNG THÔNG TIN ĐIỆN TỬ TỈNH VĨNH LONG', // Tiêu đề của bạn
                style: TextStyle(
                  fontSize: 25.0, // Kích thước văn bản
                  fontWeight: FontWeight.bold, // Độ đậm của văn bản
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0), // Đặt bán kính bo tròn
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/tvl.jpg', // Đường dẫn đến ảnh của bạn
                  width: 50, // Đặt chiều rộng mong muốn cho ảnh
                  height: 50, // Đặt chiều cao mong muốn cho ảnh
                  // Để ảnh đổ đầy vào container
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100, // Chiều rộng của hình ảnh
      height: 100.0, // Chiều cao của hình ảnh
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), // Bo tròn góc
        //color: Colors.blue, // Màu nền của hình ảnh (nếu hình ảnh không tải được)
      ),
      child: Image.asset('assets/bt.png'), // Đường dẫn tới hình ảnh trong assets
    );
  }

}
