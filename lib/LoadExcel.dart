import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huy - Tài',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
        useMaterial3: true,
      ),
      home: DataChartTabContent(),
    );
  }
}

//**********************************BIEU DO DU LIEU*********************************

class DataChartTabContent extends StatefulWidget {
  @override
  _DataChartTabContentState createState() => _DataChartTabContentState();
}

class _DataChartTabContentState extends State<DataChartTabContent> with TickerProviderStateMixin {
  late TabController _categoryTabController;
  late TabController _overviewTabController;
  String _selectedCategory = 'Chỉ tiêu chung';

  @override
  void initState() {
    super.initState();
    _categoryTabController = TabController(length: 5, vsync: this);
    _overviewTabController = TabController(length: 2, vsync: this);
    _loadDefaultExcelFile();
    _loadServiceExcelFile();
    _loadIndusExcelFile();
    _loadAgriExcelFile();
    _loadOverExcelFile();
  }

  @override
  void dispose() {
    _categoryTabController.dispose();
    _overviewTabController.dispose();
    super.dispose();
  }

  // Hàm để load file Excel mặc định từ đường dẫn
  void _loadDefaultExcelFile() async {
    String defaultExcelAssetPath = 'assets/dancuTVL.xlsx';

    // Kiểm tra xem tệp Excel có tồn tại trong assets không
    bool fileExists = await rootBundle.load(defaultExcelAssetPath).then((
        data) => true).catchError((error) => false);

    if (fileExists) {
      try {
        ByteData data = await rootBundle.load(defaultExcelAssetPath);
        List<int> bytes = data.buffer.asUint8List();
        var excel = Excel.decodeBytes(bytes);

        var sheetsData = <String, List<List<dynamic>>>{};
        for (var table in excel.tables.keys) {
          sheetsData[table] = excel.tables[table]!.rows;
        }

        setState(() {
          _sheetsData = sheetsData;
          _selectedSheet = sheetsData.keys.first;
          _currentExcel = excel;
          _currentExcelFile = defaultExcelAssetPath;
        });
      } catch (e) {
        print('Đã xảy ra lỗi khi đọc tệp Excel mặc định: $e');
      }
    } else {
      print('File Excel mặc định không tồn tại trong assets!');
    }
  }


  void _loadServiceExcelFile() async {
    String serviceExcelAssetPath = 'assets/dichvu_TVL.xlsx';

    // Kiểm tra xem tệp Excel có tồn tại trong assets không
    bool fileExists = await rootBundle.load(serviceExcelAssetPath).then((
        data) => true).catchError((error) => false);

    if (fileExists) {
      try {
        ByteData data = await rootBundle.load(serviceExcelAssetPath);
        List<int> bytes = data.buffer.asUint8List();
        var excel = Excel.decodeBytes(bytes);

        var sheetsData = <String, List<List<dynamic>>>{};
        for (var table in excel.tables.keys) {
          sheetsData[table] = excel.tables[table]!.rows;
        }

        setState(() {
          _sheetsDataService = sheetsData;
          _selectedSheetService = sheetsData.keys.first;
        });
      } catch (e) {
        print('Đã xảy ra lỗi khi đọc tệp Excel cho "Dịch vụ": $e');
      }
    } else {
      print('File Excel cho "Dịch vụ" không tồn tại trong assets!');
    }
  }

  void _loadIndusExcelFile() async {
    String indusExcelAssetPath = 'assets/congnghiep_TVL.xlsx';

    // Kiểm tra xem tệp Excel có tồn tại trong assets không
    bool fileExists = await rootBundle.load(indusExcelAssetPath).then((
        data) => true).catchError((error) => false);

    if (fileExists) {
      try {
        ByteData data = await rootBundle.load(indusExcelAssetPath);
        List<int> bytes = data.buffer.asUint8List();
        var excel = Excel.decodeBytes(bytes);

        var sheetsData = <String, List<List<dynamic>>>{};
        for (var table in excel.tables.keys) {
          sheetsData[table] = excel.tables[table]!.rows;
        }

        setState(() {
          _sheetsDataIndus = sheetsData;
          _selectedSheetIndus = sheetsData.keys.first;
        });
      } catch (e) {
        print('Đã xảy ra lỗi khi đọc tệp Excel cho "Công nghiệp": $e');
      }
    } else {
      print('File Excel cho "Công nghiệp" không tồn tại trong assets!');
    }
  }

  void _loadAgriExcelFile() async {
    String agriExcelAssetPath = 'assets/nlt_TVL.xlsx';

    // Kiểm tra xem tệp Excel có tồn tại trong assets không
    bool fileExists = await rootBundle.load(agriExcelAssetPath).then((
        data) => true).catchError((error) => false);

    if (fileExists) {
      try {
        ByteData data = await rootBundle.load(agriExcelAssetPath);
        List<int> bytes = data.buffer.asUint8List();
        var excel = Excel.decodeBytes(bytes);

        var sheetsData = <String, List<List<dynamic>>>{};
        for (var table in excel.tables.keys) {
          sheetsData[table] = excel.tables[table]!.rows;
        }

        setState(() {
          _sheetsDataAgri = sheetsData;
          _selectedSheetAgri = sheetsData.keys.first;
        });
      } catch (e) {
        print('Đã xảy ra lỗi khi đọc tệp Excel cho "Nông Lâm Thủy Sản": $e');
      }
    } else {
      print('File Excel cho "Nông Lâm Thủy Sản" không tồn tại trong assets!');
    }
  }

  void _loadOverExcelFile() async {
    String overExcelAssetPath = 'assets/ctc_TVL.xlsx';

    // Kiểm tra xem tệp Excel có tồn tại trong assets không
    bool fileExists = await rootBundle.load(overExcelAssetPath).then((
        data) => true).catchError((error) => false);

    if (fileExists) {
      try {
        ByteData data = await rootBundle.load(overExcelAssetPath);
        List<int> bytes = data.buffer.asUint8List();
        var excel = Excel.decodeBytes(bytes);

        var sheetsData = <String, List<List<dynamic>>>{};
        for (var table in excel.tables.keys) {
          sheetsData[table] = excel.tables[table]!.rows;
        }

        setState(() {
          _sheetsDataOver = sheetsData;
          _selectedSheetOver = sheetsData.keys.first;
        });
      } catch (e) {
        print('Đã xảy ra lỗi khi đọc tệp Excel cho "Dịch vụ": $e');
      }
    } else {
      print('File Excel cho "Dịch vụ" không tồn tại trong assets!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bảng dữ liệu'),
        backgroundColor: Colors.blue, // Màu nền là màu xanh dương
      ),
      body: Material(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  // Thanh công cụ đầu tiên với các tùy chọn
                  Material(
                    color: Colors.white54,
                    child: Row(
                      children: [
                        TabBar(
                          controller: _categoryTabController,
                          isScrollable: true,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black45,
                          indicatorColor: Colors.black,
                          labelStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(text: 'Chỉ tiêu chung'),
                            Tab(text: 'Nông Lâm Thủy sản'),
                            Tab(text: 'Công nghiệp'),
                            Tab(text: 'Dịch vụ'),
                            Tab(text: 'Dân cư'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _categoryTabController,
                      children: [
                        _buildDataManagerContentOver(),
                        _buildDataManagerContentAgri(),
                        _buildDataManagerContentIndus(),
                        _buildDataManagerContentService(),
                        _buildDataManagerContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  Map<String, List<List<dynamic>>> _sheetsDataService = {};
  String? _selectedSheetService;

  Widget _buildDataManagerContentService() {
    if (_selectedSheet != null) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 50),
        child: Column(
          children: [
            // Tiêu đề bảng dữ liệu
            Text(
              'CƠ CẤU CÁC NGÀNH DỊCH VỤ QUẬN PHÚ NHUẬN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Bảng dữ liệu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.blue,
                ),
                child: DataTable(
                  columns: _sheetsDataService[_selectedSheetService!]![0]
                      .sublist(0, 11)
                      .map<DataColumn>((item) =>
                      DataColumn(
                        label: Text(' '),
                      ))
                      .toList(),
                  rows: _sheetsDataService[_selectedSheetService!]!.sublist(1)
                      .take(4)
                      .map<DataRow>((rowData) {
                    return DataRow(
                      cells: rowData.sublist(0, 11).map<DataCell>((cellData) =>
                          DataCell(
                            Text(
                              cellData?.value?.toString() ?? '0',
                              style: TextStyle(fontSize: 18),
                            ),
                          ))
                          .toList(),
                    );
                  })
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 250, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xls'],
                      );

                      if (result != null && result.files.single.path != null) {
                        var filePath = result.files.single.path!;
                        var bytes = File(filePath).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);

                        var sheetsData = <String, List<List<dynamic>>>{};
                        for (var table in excel.tables.keys) {
                          sheetsData[table] = excel.tables[table]!.rows;
                        }

                        setState(() {
                          _sheetsDataService = sheetsData;
                          _selectedSheetService = sheetsData.keys.first;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF00224D),
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Đặt hình dạng hình vuông cho nút
                      ),
                    ),
                    child: Text(
                        '   Tải lên   ', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }


  // ..................................................................
  Map<String, List<List<dynamic>>> _sheetsDataOver = {};
  String? _selectedSheetOver;
  Widget _buildDataManagerContentOver() {
    if (_selectedSheet != null) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 50),
        child: Column(
          children: [
            // Tiêu đề bảng dữ liệu
            Text(
              'CƠ CẤU KINH TẾ QUẬN PHÚ NHUẬN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Bảng dữ liệu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.blue,
                ),
                child: DataTable(
                  columns: _sheetsDataOver[_selectedSheetOver!]![0]
                      .sublist(0, 11)
                      .map<DataColumn>((item) =>
                      DataColumn(
                        label: Text(' '),
                      ))
                      .toList(),
                  rows: _sheetsDataOver[_selectedSheetOver!]!.sublist(1)
                      .take(5)
                      .map<DataRow>((rowData) {
                    return DataRow(
                      cells: rowData.sublist(0, 11).map<DataCell>((cellData) =>
                          DataCell(
                            Text(
                              cellData?.value?.toString() ?? '0',
                              style: TextStyle(fontSize: 18),
                            ),
                          ))
                          .toList(),
                    );
                  })
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 250, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xls'],
                      );

                      if (result != null && result.files.single.path != null) {
                        var filePath = result.files.single.path!;
                        var bytes = File(filePath).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);

                        var sheetsData = <String, List<List<dynamic>>>{};
                        for (var table in excel.tables.keys) {
                          sheetsData[table] = excel.tables[table]!.rows;
                        }

                        setState(() {
                          _sheetsDataOver = sheetsData;
                          _selectedSheetOver = sheetsData.keys.first;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF00224D),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Đặt hình dạng hình chữ nhật cho nút
                      ),
                    ),
                    child: Text(
                        'Tải lên', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }


  Map<String, List<List<dynamic>>> _sheetsDataAgri = {};
  String? _selectedSheetAgri;

  Widget _buildDataManagerContentAgri() {
    if (_selectedSheet != null) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 50),
        child: Column(
          children: [
            // Tiêu đề bảng dữ liệu
            Text(
              'GIÁ TRỊ SẢN XUẤT NGÀNH NÔNG - LÂM - NGƯ NGHIỆP QUẬN PHÚ NHUẬN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Bảng dữ liệu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.blue,
                ),
                child: DataTable(
                  columns: _sheetsDataAgri[_selectedSheetAgri!]![0]
                      .sublist(0, 11)
                      .map<DataColumn>((item) =>
                      DataColumn(
                        label: Text(' '),
                      ))
                      .toList(),
                  rows: _sheetsDataAgri[_selectedSheetAgri!]!.sublist(1)
                      .take(4)
                      .map<DataRow>((rowData) {
                    return DataRow(
                      cells: rowData.sublist(0, 11).map<DataCell>((cellData) =>
                          DataCell(
                            Text(
                              cellData?.value?.toString() ?? '0',
                              style: TextStyle(fontSize: 18),
                            ),
                          ))
                          .toList(),
                    );
                  })
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 250, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xls'],
                      );

                      if (result != null && result.files.single.path != null) {
                        var filePath = result.files.single.path!;
                        var bytes = File(filePath).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);

                        var sheetsData = <String, List<List<dynamic>>>{};
                        for (var table in excel.tables.keys) {
                          sheetsData[table] = excel.tables[table]!.rows;
                        }

                        setState(() {
                          _sheetsDataAgri = sheetsData;
                          _selectedSheetAgri = sheetsData.keys.first;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF00224D),
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Đặt hình dạng hình chữ nhật cho nút
                      ),
                    ),
                    child: Text(
                        '   Tải lên   ', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }


  Map<String, List<List<dynamic>>> _sheetsDataIndus = {};
  String? _selectedSheetIndus;
  Widget _buildDataManagerContentIndus() {
    if (_selectedSheetIndus != null) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 50),
        child: Column(
          children: [
            // Tiêu đề bảng dữ liệu
            Text(
              'TRỊ GIÁ XUẤT KHẨU NGÀNH CÔNG NGHIỆP QUẬN PHÚ NHUẬN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Bảng dữ liệu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.blue,
                ),
                child: DataTable(
                  columns: _sheetsDataIndus[_selectedSheetIndus!]![0]
                      .sublist(0, 11)
                      .map<DataColumn>((item) =>
                      DataColumn(
                        label: Text(' '),
                      ))
                      .toList(),
                  rows: _sheetsDataIndus[_selectedSheetIndus!]!.sublist(1)
                      .take(3)
                      .map<DataRow>((rowData) {
                    return DataRow(
                      cells: rowData.sublist(0, 11).map<DataCell>((cellData) =>
                          DataCell(
                            Text(
                              cellData?.value?.toString() ?? '0',
                              style: TextStyle(fontSize: 18),
                            ),
                          ))
                          .toList(),
                    );
                  })
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20, top: 20),
              child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['xlsx', 'xls'],
                  );

                  if (result != null && result.files.single.path != null) {
                    var filePath = result.files.single.path!;
                    var bytes = File(filePath).readAsBytesSync();
                    var excel = Excel.decodeBytes(bytes);

                    var sheetsData = <String, List<List<dynamic>>>{};
                    for (var table in excel.tables.keys) {
                      sheetsData[table] = excel.tables[table]!.rows;
                    }

                    setState(() {
                      _sheetsDataIndus = sheetsData;
                      _selectedSheetIndus = sheetsData.keys.first;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF00224D), // Màu hồng
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 35), // Padding để điều chỉnh kích thước
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Độ cong của góc
                  ),
                ),
                child: Text(
                  'Tải lên',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }


  // ********************************************************************************
  Excel? _currentExcel;
  String? _currentExcelFile;

// Sử dụng một Map để lưu trữ các Sheets và dữ liệu của chúng
  Map<String, List<List<dynamic>>> _sheetsData = {};
  String? _selectedSheet;

  Widget _buildDataManagerContent() {
    if (_selectedSheet != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tiêu đề bảng dữ liệu
            Text(
              'DÂN SỐ VÀ THU THẬP TRUNG BÌNH QUẬN PHÚ NHUẬN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Khoảng cách giữa tiêu đề và bảng dữ liệu
            // Bảng dữ liệu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.blue,
                ),
                child: DataTable(
                  columns: _sheetsData[_selectedSheet!]![0]
                      .sublist(0, 11)
                      .map<DataColumn>((item) =>
                      DataColumn(label: Text(' ')))
                      .toList(),
                  rows: _sheetsData[_selectedSheet!]!.sublist(1, 4).map<
                      DataRow>((rowData) {
                    return DataRow(
                      cells: rowData.sublist(0, 11).map<DataCell>((cellData) =>
                          DataCell(
                            Text(
                              cellData?.value?.toString() ?? '0',
                              style: TextStyle(fontSize: 20, color: Colors.black87),
                            ),
                          )).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Khoảng cách giữa bảng dữ liệu và nút "Tải lên"
            // Nút tải lên
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 120, // Độ rộng của nút
                  height: 40, // Độ cao của nút
                  child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xls'],
                      );

                      if (result != null &&
                          result.files.single.path != null) {
                        var filePath = result.files.single.path!;
                        var bytes = File(filePath).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);

                        var sheetsData = <String, List<List<dynamic>>>{};
                        for (var table in excel.tables.keys) {
                          sheetsData[table] = excel.tables[table]!.rows;
                        }

                        setState(() {
                          _sheetsData = sheetsData;
                          _selectedSheet = sheetsData.keys.first;
                          //_currentExcel = excel; // Not sure about these variables, they weren't defined in your provided code snippet
                          //_currentExcelFile = filePath; // Not sure about these variables, they weren't defined in your provided code snippet
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF00224D), // Màu xám

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Tải lên',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
}

