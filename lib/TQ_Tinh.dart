import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'dart:io';
// import 'dart:math';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:excel/excel.dart';
// import 'package:share_plus/share_plus.dart';
//Trang tổng quan gồm biểu đồ tròn và bảng dữ liệu

class OverviewTabContent extends StatefulWidget {
  @override
  _OverviewTabContentState createState() => _OverviewTabContentState();
}

class _OverviewTabContentState extends State<OverviewTabContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<String> _imagePaths = [
    'assets/ttkt.jpg',
    'assets/ttxhbp.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 45, // Chiều cao của thanh tab bar
            child: TabBar(
              isScrollable: true, // Cho phép cuộn nếu cần thiết
              controller: _tabController,
              onTap: (index) {
                _tabController.animateTo(index);
              },
              tabs: [
                 Text("TÌNH HÌNH KINH TẾ"),
                Text("SỐ LIỆU THỐNG KÊ"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Image.asset(
                  'assets/ttkt.jpg',
                  height: 100,
                  //fit: BoxFit.cover,
                ),
                PieChartOverview(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class PieChartOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), // Bo tròn viền
      ),
      child: Row(
        children: [
          //Biểu đồ tròn
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sectionsSpace: 0,
                startDegreeOffset: 180,
                sections: [
                  PieChartSectionData(
                    color: Color(0XFF007F73),
                    value: 60,
                    title: 'Hoàn thành\n60%',
                    radius: 150,
                    titleStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.6,
                  ),
                  PieChartSectionData(
                    color: Color(0XFFE8751A),
                    value: 40,
                    title: 'Còn lại\n40%',
                    radius: 150,
                    titleStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.6,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: DataTable(
              //Bảng dữ liệu
              dataRowHeight: 50,
              headingRowHeight: 60,
              columnSpacing: 20,
              columns: const <DataColumn>[
                //Tiêu đề các ô trong bảng
                DataColumn(label: Text('KPI')),
                DataColumn(label: Text('Đạt được')),
                DataColumn(label: Text('Target %')),
                DataColumn(label: Text('Trend Line')),
              ],
              rows: const <DataRow>[
                DataRow(
                  //Thêm nội dung vào các hàng
                  cells: <DataCell>[
                    DataCell(Text('Nông nghiệp')),
                    DataCell(Text('12,4567')),
                    DataCell(Text('15%')),
                    DataCell(Icon(Icons.show_chart)),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Du lịch')),
                    DataCell(Text('9,4567')),
                    DataCell(Text('25%')),
                    DataCell(Icon(Icons.show_chart)),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Công Nghiệp')),
                    DataCell(Text('9,9567')),
                    DataCell(Text('25%')),
                    DataCell(Icon(Icons.show_chart)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//
