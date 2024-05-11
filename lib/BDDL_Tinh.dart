import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:soecoreport/TQ_Tinh.dart';
// import 'package:soecoreport/QLCB_Tinh.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:path/path.dart' as path;



//Giao diện quản lý dữ liệu và vẽ biểu đồ
class DataChartTabContent extends StatefulWidget {
  @override
  _DataChartTabContentState createState() => _DataChartTabContentState();
}

class _DataChartTabContentState extends State<DataChartTabContent> with TickerProviderStateMixin {
  //Tạo ra 2 tabBar
  late TabController _categoryTabController; //Gồm 5 mục nhỏ ứng 5 lĩnh vực
  late TabController _overviewTabController; //Gồm 2 tiểu mục (biểu đồ và số liệu)
  String _selectedCategory = 'Chỉ tiêu chung';

  @override
  void initState() {
    super.initState();
    _categoryTabController = TabController(length: 5, vsync: this); //Khởi tạo chiều dài
    _overviewTabController = TabController(length: 2, vsync: this);
    _loadDefaultExcelFile(); //Load các file excel mặc định tránh NULL
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
    bool fileExists = await rootBundle.load(defaultExcelAssetPath).then((data) => true).catchError((error) => false);

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
    bool fileExists = await rootBundle.load(serviceExcelAssetPath).then((data) => true).catchError((error) => false);

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
    bool fileExists = await rootBundle.load(indusExcelAssetPath).then((data) => true).catchError((error) => false);

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
    bool fileExists = await rootBundle.load(agriExcelAssetPath).then((data) => true).catchError((error) => false);

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
    bool fileExists = await rootBundle.load(overExcelAssetPath).then((data) => true).catchError((error) => false);

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
  // ......................................................................
  //Chia sẻ file đến người dùng khác
  // Hàm này sẽ tạo và lưu một file Excel vào bộ nhớ cục bộ và trả về đường dẫn đến file đó
  // Hàm này sẽ sao chép file Excel từ assets vào bộ nhớ cục bộ và mở để tải về
  // Hàm này sẽ sao chép file Excel từ assets vào thư mục tạm thời trên ổ đĩa E và mở để tải về
  Future<void> downloadExcelFile(String assetPath) async {
    try {
      // Tải file Excel từ assets
      ByteData excelData = await rootBundle.load(assetPath);
      List<int> bytes = excelData.buffer.asUint8List();

      // Lấy đường dẫn đến thư mục tạm thời trên ổ đĩa E
      String tempFolderPath = 'E:/temp_folder'; // Sử dụng đường dẫn đến thư mục tạm thời trên ổ đĩa E
      // Tạo thư mục tạm thời nếu nó chưa tồn tại
      Directory tempDir = Directory(tempFolderPath);
      if (!(await tempDir.exists())) {
        await tempDir.create(recursive: true);
      }

      // Lưu file Excel vào thư mục tạm thời
      String filePath = path.join(tempFolderPath);
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Mở file Excel để tải về
      ProcessResult result = await Process.run('open', ['-a', 'MS Excel', filePath]); // Thay 'MS Excel' bằng ứng dụng Excel trên thiết bị của bạn
      // Kiểm tra kết quả
      if (result.exitCode == 0) {
        print('File Excel đã tải về thành công');
      } else {
        print('Đã xảy ra lỗi khi tải file Excel: ${result.stderr}');
      }
    } catch (e) {
      print('Lỗi khi tải file Excel: $e');
    }
  }

  // ******************************************************************************
  //Xây dựng giao diện
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar danh sách các tỉnh
        Expanded(
          flex: 1,
          child: ListView(
            children: [
              ListTile(
                title: Text('TP. VĨNH LONG', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
              ListTile(
                title: Text('TX. BÌNH MINH', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
              ListTile(
                title: Text('H. LONG HỒ', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
              ListTile(
                title: Text('H. MANG THÍT', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
              ListTile(
                title: Text('H. VŨNG LIÊM', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
              ListTile(
                title: Text('H. TAM BÌNH', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
              ListTile(
                title: Text('H. TRÀ ÔN', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
              ListTile(
                title: Text('H. BÌNH TÂN', style: TextStyle(fontSize: 18)),
                onTap: () {
                  // Hành động khi nhấn vào tên tỉnh
                },
              ),
            ],
          ),
        ),
        VerticalDivider(thickness: 1, width: 1),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              // Thanh công cụ đầu tiên với các tùy chọn 5 lĩnh vực muốn xem
              Material(
                color: Colors.white54,
                child: TabBar(
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
              ),
              // Thanh công cụ thứ hai với "Biểu đồ tổng quan" và "Quản lý dữ liệu"
              Material(
                color: Colors.white54,
                child: TabBar(
                  controller: _overviewTabController,
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black45,
                  indicatorColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Biểu đồ tổng quan'),
                    Tab(text: 'Quản lý dữ liệu'),
                  ],
                ),
              ),


              Expanded(
                child: TabBarView(
                  controller: _categoryTabController,
                  children: [
                    //Giao diện mới tạo ra tương ứng 5 tiểu mục
                    _buildCategoryContent('Chỉ tiêu chung'),
                    _buildCategoryContent('Nông Lâm Thủy sản'),
                    _buildCategoryContent('Công nghiệp'),
                    _buildCategoryContent('Dịch vụ'),
                    _buildCategoryContent('Dân cư'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryContent(String category) {
    //Tùy vào tiểu mục đang chọn mà sẽ có 2 hàm biểu đồ và quản lý excel tương ứng
    if (category == 'Dân cư') {
      return TabBarView(
        controller: _overviewTabController,
        children: [
          _buildChartsContent(), // Gọi hàm tạo biểu đồ
          _buildDataManagerContent(),
        ],
      );
    } else if (category == 'Dịch vụ') {
      return TabBarView(
        controller: _overviewTabController,
        children: [
          _buildChartsContentService(),
         _buildDataManagerContentService(),
        ],
      );
    } else if (category == 'Công nghiệp') {
      return TabBarView(
        controller: _overviewTabController,
        children: [
          _buildCombinedBarLineChartWithLegend(),
          _buildDataManagerContentIndus(),
        ],
      );
    } else if (category == 'Nông Lâm Thủy sản') {
      return TabBarView(
        controller: _overviewTabController,
        children: [
          _buildBarChartAgriWithLegend(),
          _buildDataManagerContentAgri(),
        ],
      );
    } else if (category == 'Chỉ tiêu chung') {
      return TabBarView(
        controller: _overviewTabController,
        children: [
          PieChartSample2(),
          _buildDataManagerContentOver(),
        ],
      );
    } else{
      return Center(child: Text('Nội dung cho $category'));
    }
  }
 //Tải dữ liệu excel lên cho tiểu mục chỉ tiêu chung
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
              'CƠ CẤU KINH TẾ TỈNH VĨNH LONG',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Bảng dữ liệu
            SingleChildScrollView( //Cho phép cuộn nếu overflow
              scrollDirection: Axis.horizontal,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.blue,
                ),
                child: DataTable(
                  //điền các cột trước --> k điền vì mình duyệt theo hàng
                  columns: _sheetsDataOver[_selectedSheetOver!]![0]
                      .sublist(0, 11)
                      .map<DataColumn>((item) =>
                      DataColumn(
                        label: Text(' '),
                      ))
                      .toList(),
                  rows: _sheetsDataOver[_selectedSheetOver!]!.sublist(1)
                      .take(5) //bỏ hàng 1, lấy 5 hàng
                      .map<DataRow>((rowData) {
                    return DataRow(
                      cells: rowData.sublist(0, 11).map<DataCell>((cellData) =>
                      //chỉ lấy 8 phần tử đầu tiên của mỗi hàng
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
                  //Nút nhấn chỉnh sửa
                  ElevatedButton(
                    onPressed: () {
  //chưa làm gì cả
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Chỉnh sửa', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      downloadExcelFile('assets/dancuTVL.xlsx');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Tải xuống', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton( //nút tải lên
                    onPressed: () async {
                      //chờ xíu cho nó lấy file
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xls'], //dịnh dạng cho phép
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
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
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

  // Tương tự nhưng load cho nông lâm thủy sản
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
              'GIÁ TRỊ SẢN XUẤT NGÀNH NÔNG - LÂM - NGƯ NGHIỆP TỈNH VĨNH LONG',
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
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Chỉnh sửa', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Tải xuống', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
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
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
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
    }else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
  //Tương tự nhưng load cho dịch vụ
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
              'CƠ CẤU CÁC NGÀNH DỊCH VỤ TỈNH VĨNH LONG',
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
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Chỉnh sửa', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Tải xuống', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
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
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
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
    }else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
//Tương tự nhưng load cho công nghiệp
  Map<String, List<List<dynamic>>> _sheetsDataIndus = {};
  String? _selectedSheetIndus;
  Widget _buildDataManagerContentIndus() {
    if (_selectedSheet != null) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 50),
        child: Column(
          children: [
            // Tiêu đề bảng dữ liệu
            Text(
              'TRỊ GIÁ XUẤT KHẨU NGÀNH CÔNG NGHIỆP TỈNH VĨNH LONG',
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
              padding: EdgeInsets.only(right: 250, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Chỉnh sửa', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
                    ),
                    child: Text(
                        'Tải xuống', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 20),
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
                          _sheetsDataIndus = sheetsData;
                          _selectedSheetIndus = sheetsData.keys.first;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(color: Colors.white),
                      elevation: 7,
                      shadowColor: Colors.black.withOpacity(0.9),
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
    }else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }

  // ......................................................................................
  //Trích xuất dữ liệu từ excel, để vẽ biểu đồ
  List<BarChartGroupData> _extractAgriData() {
    if (_selectedSheet != null) {
      List<BarChartGroupData> barGroups = []; //Mảng chứa giá trị của trục tung

      final colors = [
        Colors.green, // Màu cho Nông nghiệp
        Colors.brown, // Màu cho Lâm nghiệp
        Colors.indigo, // Màu cho Thủy sản
      ]; //đánh dấu các màu

      for (int colIndex = 1; colIndex <= 7; colIndex++) {
        //Duyêt qua 7 cột
        List<BarChartRodData> barRods = [];
        // print('Year: ${colIndex + 2010}');
        //duyệt qua 3 hàng 2,3,4
        for (int rowIndex = 2; rowIndex <= 4; rowIndex++) {
          dynamic cellData = _sheetsDataAgri[_selectedSheetAgri]![rowIndex][colIndex];
          //Trích xuất dữ liệu
          double yValue = (cellData is Data && cellData.value != null) ? double
              .tryParse(cellData.value.toString()) ?? 0 : 0;
          //Chuyển lại thành chuỗi, sau đó thêm vào mảng chứa giá trị trục tung để vẽ
          barRods.add(BarChartRodData(toY: yValue,
            color: colors[rowIndex - 2],
            width: 20,
            // Độ rộng của cột
            borderRadius: BorderRadius.zero,));
        }

        int xValue = colIndex;
        //Thêm vào mảng cách thông số về trục x, trục y sao khi trích xuất
        barGroups.add(BarChartGroupData(x: xValue, barRods: barRods));
      }

      //Đoạn này debug
      for (var group in barGroups) {
        String barGroupStr = 'X: ${group.x}';
        group.barRods.forEach((rod) {
          barGroupStr += ', Y: ${rod.toY}';
        });
        // print(barGroupStr);
      }

      return barGroups;
    } else return [];
  }


  Widget _buildBarChartAgriWithLegend() {
    List<BarChartGroupData> barGroups = _extractAgriData();
  //Lấy dữ liệu và vẽ đồ thị cột
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, //căn chỉnh theo rộng/ngang
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Biểu Đồ Nông Nghiệp',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                //hiệu ứng khi chạm
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blue,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY}',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),maxY: 70,
              barGroups: barGroups,
              //tiêu đề, ẩn hiện tiêu đề 4 phía
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: _bottomTitleAgri,
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              // Cấu hình biểu đồ...
            ),
          ),
        ),
        // Chú thích cho biểu đồ
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(Colors.green, 'Nông nghiệp'),
              _buildLegendItem(Colors.brown, 'Lâm nghiệp'),
              _buildLegendItem(Colors.indigo, 'Thủy sản'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }

//tiêu đề trục hoành là giá trị các năm 2011-2017
  SideTitles get _bottomTitleAgri => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        List<String> years = [
          '2011',
          '2012',
          '2013',
          '2014',
          '2015',
          '2016',
          '2017'
        ];
        //Đánh dấu vị trí các năm trên biểu đồ
        if(value.toInt() == 1) return Text(years[0]);
        else if(value.toInt() == 2) return Text(years[1]);
        else if(value.toInt() == 3) return Text(years[2]);
        else if(value.toInt() == 4) return Text(years[3]);
        else if(value.toInt() == 5) return Text(years[4]);
        else if(value.toInt() == 6) return Text(years[5]);
        else if(value.toInt() == 7) return Text(years[6]);
        else return Text('');
      }
  );
  // *************************************DAN CU*********************************************
  Widget _buildChartsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Biểu đồ đường
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Biểu đồ dân số theo năm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child:_buildLineChart(), // Hàm tạo biểu đồ đường
        ),
        // Biểu đồ cột
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Biểu đồ thu nhập theo năm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildBarChart(), // Hàm tạo biểu đồ cột
        ),
      ],
    );
  }

  Map<int, int> xToColumnIndex = {
    1: 1, // x=1 tương ứng với cột thứ 2 trong Excel
    5: 2, // x=5 tương ứng với cột thứ 3 trong Excel
    9: 3, // x=9 tương ứng với cột thứ 4 trong Excel
    13: 4, // x=13 tương ứng với cột thứ 5 trong Excel
    18: 5, // x=18 tương ứng với cột thứ 6 trong Excel
    24: 6, // x=24 tương ứng với cột thứ 7 trong Excel
    29: 7, // x=29 tương ứng với cột thứ 8 trong Excel
  };
  //Trích dữ liệu về dân số
  List<FlSpot> _extractPopulationData() {
    if (_selectedSheet != null) {
      // Hàng thứ ba chứa dữ liệu "Dân số"
      var populationRow = _sheetsData[_selectedSheet]![2];
      List<FlSpot> populationData = [];

      xToColumnIndex.forEach((x, columnIndex) {
        var cellData = populationRow[columnIndex];
        double y = (cellData is Data && cellData.value != null) ? double.tryParse(cellData.value.toString()) ?? 0 : 0;
      //  print('x: $x, y: $y'); // In ra giá trị của x và y để debug
        populationData.add(FlSpot(x.toDouble(), y));
      });
      return populationData;
    } else {
      return [];
    }
  }
 //Vẽ biểu đồ đường
  Widget _buildLineChart() {
    List<FlSpot> data = _extractPopulationData();

    return AspectRatio(
      aspectRatio: 4,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blue, // Màu nền của tooltip
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y}',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
      lineBarsData: [
            LineChartBarData(
              spots: data,
              //isCurved: true,
              color: Colors.blueGrey,
              barWidth: 4,
              isStrokeCapRound: true,
              //  belowBarData: BarAreaData(show: false),
            ),
          ],
          minX: 0,
          maxX: 30,
          minY: 900,
          maxY: 1000,
          gridData: FlGridData(
            show: true, // Hiển thị lưới

          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

          ),
        ),
      ),
    );
  }
  SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        List<String> years = [
          '2011',
          '2012',
          '2013',
          '2014',
          '2015',
          '2016',
          '2017'
        ];
        if(value.toInt() == 1) return Text(years[0]);
        else if(value.toInt() == 5) return Text(years[1]);
        else if(value.toInt() == 9) return Text(years[2]);
        else if(value.toInt() == 13) return Text(years[3]);
        else if(value.toInt() == 18) return Text(years[4]);
        else if(value.toInt() == 24) return Text(years[5]);
        else if(value.toInt() == 29) return Text(years[6]);
        else return Text('');
      }
  );
  // ****************************************************************************
//Trích dữ liệu thu nhập
  List<BarChartGroupData> _extractIncomeData() {
    if (_selectedSheet != null) {
      var incomeRow = _sheetsData[_selectedSheet]![3];
      List<BarChartGroupData> barGroups = [];

      for (int x in xToColumnIndexx.keys) {
        int columnIndex = xToColumnIndexx[x]!;
        var cellData = incomeRow[columnIndex];
        double y = (cellData is Data && cellData.value != null) ? double
            .tryParse(cellData.value.toString()) ?? 0 : 0;
        //print('x: $x, y: $y');
        barGroups.add(
          BarChartGroupData(
            x: x,
            barRods: [
              BarChartRodData(
                toY: y,
                color: Colors.teal,
                width: 40, // Độ rộng của cột
                borderRadius: BorderRadius.zero,
              ),

            ],
          ),
        );
      }
      return barGroups;
    } else {
      return [];
    }
  }
//Vẽ biểu đồ cột
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blue, // Màu nền của tooltip
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        maxY: 10, // Giá trị lớn nhất trên trục Y
        barGroups: _extractIncomeData(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: _bottomTitless,
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
  SideTitles get _bottomTitless => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        List<String> years = [
          '2011',
          '2012',
          '2013',
          '2014',
          '2015',
          '2016',
          '2017'
        ];
        if(value.toInt() == 1) return Text(years[0]);
        else if(value.toInt() == 5) return Text(years[1]);
        else if(value.toInt() == 9) return Text(years[2]);
        else if(value.toInt() == 13) return Text(years[3]);
        else if(value.toInt() == 18) return Text(years[4]);
        else if(value.toInt() == 24) return Text(years[5]);
        else if(value.toInt() == 29) return Text(years[6]);
        else return Text('');
      }
  );
  Map<int, int> xToColumnIndexx = {
    1: 1, // x=1 tương ứng với cột thứ 2 trong Excel
    5: 2, // x=5 tương ứng với cột thứ 3 trong Excel
    9: 3, // x=9 tương ứng với cột thứ 4 trong Excel
    13: 4, // x=13 tương ứng với cột thứ 5 trong Excel
    18: 5, // x=18 tương ứng với cột thứ 6 trong Excel
    24: 6, // x=24 tương ứng với cột thứ 7 trong Excel
    29: 7, // x=29 tương ứng với cột thứ 8 trong Excel
  };

  // *************************************************************************

  Map<int, int> xToColumnIndexxx = {
    1: 1, // x=1 tương ứng với cột thứ 2 trong Excel
    5: 2, // x=5 tương ứng với cột thứ 3 trong Excel
    9: 3, // x=9 tương ứng với cột thứ 4 trong Excel
    13: 4, // x=13 tương ứng với cột thứ 5 trong Excel
    18: 5, // x=18 tương ứng với cột thứ 6 trong Excel
    24: 6, // x=24 tương ứng với cột thứ 7 trong Excel
    29: 7, // x=29 tương ứng với cột thứ 8 trong Excel
  };
  // Hàm giả định để lấy dữ liệu cho biểu đồ cột (kim ngạch xuất khẩu)
  List<BarChartGroupData> _extractExportValueData() {
    if (_selectedSheet != null) {
      var exportValueRow = _sheetsDataIndus[_selectedSheetIndus]![2]; // Dữ liệu nằm ở hàng thứ 3 trong sheet
      List<BarChartGroupData> barGroups = [];

      xToColumnIndexxx.forEach((x, columnIndex) {
        // Lấy giá trị từ cell, nếu cell là Data và có giá trị, parse nó sang double, ngược lại là 0
        var cellValue = exportValueRow[columnIndex];
        double y = (cellValue is Data && cellValue.value != null) ? double
            .tryParse(cellValue.value.toString()) ?? 0.0 : 0.0;
        //  print('x: $x, y: $y');
        barGroups.add(BarChartGroupData(
          x: x,
          barRods: [
            BarChartRodData(toY: y,
                color: Colors.teal,
                width: 40,
                borderRadius: BorderRadius.zero)
          ],
        ));
      });

      return barGroups;
    } else
      return [];
  }

//Trích dữ liệu tốc độ tăng trưởng
  List<FlSpot> _extractGrowthRateData() {
    if (_selectedSheet != null) {
      // Hàng thứ ba chứa dữ liệu "Dân số"
      var growthRateRow = _sheetsDataIndus[_selectedSheetIndus]![3];
      List<FlSpot> growthRateSpots = [];

      xToColumnIndexxx.forEach((x, columnIndex) {
        var cellData = growthRateRow[columnIndex];
        double y = (cellData is Data && cellData.value != null) ? double.tryParse(cellData.value.toString()) ?? 0 : 0;
       // print('x: $x, y: $y'); // In ra giá trị của x và y để debug
        growthRateSpots.add(FlSpot(x.toDouble(), y));
      });
      return growthRateSpots;
    } else {
      return [];
    }
  }
  //Vẽ biểu đồ cột kết hợp đường
  Widget _buildCombinedBarLineChartWithLegend() {
    // Dữ liệu cho biểu đồ
    List<BarChartGroupData> barGroups = _extractExportValueData();
    List<FlSpot> lineSpots = _extractGrowthRateData();

    // Biểu đồ kết hợp
    Widget combinedChart = _buildCombinedBarLineChart(barGroups, lineSpots);

    // Chú thích cho biểu đồ
    Widget legend = _buildChartLegends();

    // Kết hợp biểu đồ và chú thích
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Text(
            'Biểu đồ cơ cấu các ngành dịch vụ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: combinedChart,
        ),
        legend,
      ],
    );
  }
  //Tạo chú thích phân biệt
  Widget _buildChartLegends() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: Colors.blue,
            ),
            SizedBox(width: 8),
            Text("Kim ngạch xuất khẩu"),
          ],
        ),
        // Chú thích cho biểu đồ đường
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text("Tốc độ tăng trưởng"),
          ],
        ),
      ],
    );
  }


  Widget _buildCombinedBarLineChart(List<BarChartGroupData> barGroups, List<FlSpot> lineSpots) {
    List<FlSpot> data =  _extractGrowthRateData();
    return Stack(
      children: <Widget>[
        // Vẽ biểu đồ cột
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: BarChart(
            BarChartData(
              barGroups:  _extractExportValueData(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blue,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY}',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              maxY: 36,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: _bottomTitless, // Sử dụng cùng trục X như biểu đồ đường
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
        // Vẽ biểu đồ đường
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: LineChart(
            LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blue,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                //  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              minX: 0,
              maxX: 30,
              minY: 0,
              maxY: 50,
              gridData: FlGridData(
                show: false, // Hiển thị lưới
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

              ),
            ),
          ),
        ),
      ],
    );
  }




//Vẽ biểu đồ dịch vụ
  Widget _buildChartsContentService() {
    List<LineChartBarData> lineBarsData = _extractServiceData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tiêu đề và biểu đồ
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Biểu đồ cơ cấu các ngành dịch vụ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildChartWithLegend(lineBarsData),
        ),
      ],
    );
  }
  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
  //Trích dữ liệu dịch vụ
  List<LineChartBarData> _extractServiceData() {
    if (_selectedSheet != null) {
      List<LineChartBarData> lines = [];

      var serviceRows = [
        _sheetsDataService[_selectedSheetService]![2], // Dịch vụ tiêu dùng
        _sheetsDataService[_selectedSheetService]![3], // Dịch vụ sản xuất
        _sheetsDataService[_selectedSheetService]![4], // Dịch vụ công cộng
      ];
      //Dữ liệu của 3 hàng

      for (var serviceRow in serviceRows) {
        List<FlSpot> serviceData = [];

        xToColumnIndex.forEach((x, columnIndex) {
          var cellData = serviceRow[columnIndex];
          double y = (cellData is Data && cellData.value != null) ? double
              .tryParse(cellData.value.toString()) ?? 0 : 0;
          // print('x: $x, y: $y');
          serviceData.add(FlSpot(x.toDouble(), y));
        });

        // Tạo một đường mới cho mỗi loại dịch vụ
        var lineChartData = LineChartBarData(
          spots: serviceData,
          //isCurved: true,
          color: getRandomColor(),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
        );

        lines.add(lineChartData);
      }
      return lines;
    } else
      return [];
  }

//Vẽ biểu đồ đa đường
  Widget _buildMultiLineChart(List<LineChartBarData> lineBarsData) {
    List<LineChartBarData> lineBarsData = _extractServiceData();

    return Padding(
      padding: const EdgeInsets.only(left: 5.0), // Thêm padding ở bên phải
      child: AspectRatio(
        aspectRatio: 1,
        child: LineChart(
          LineChartData(
            lineBarsData: lineBarsData,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.blue,

              ),
            ),
            minX: 0,
            maxX: 30,
            minY: 0,
            maxY: 70,
            gridData: FlGridData(
              show: true,
              // ... các thiết lập khác
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitlesss),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),// Các

          ),
        ),
      ),
    );
  }
  //Vẽ biểu đồ và chú thích
  Widget _buildChartWithLegend(List<LineChartBarData> lineBarsData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _buildMultiLineChart(lineBarsData),
        ),
        _buildLegend(lineBarsData),
      ],
    );
  }
 //Tạo chú thích
  Widget _buildLegend(List<LineChartBarData> lineBarsData) {
    List<String> serviceNames = ['Dịch vụ tiêu dùng', 'Dịch vụ sản xuất', 'Dịch vụ công cộng'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List<Widget>.generate(lineBarsData.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lineBarsData[index].color,
                  ),
                ),
                SizedBox(width: 4),
                Text(serviceNames[index]),
              ],
            ),
          );
        }),
      ),
    );
  }

//Tiêu đề truc hoành
  SideTitles get _bottomTitlesss => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        List<String> years = [
          '2011',
          '2012',
          '2013',
          '2014',
          '2015',
          '2016',
          '2017'
        ];
        if(value.toInt() == 1) return Text(years[0]);
        else if(value.toInt() == 5) return Text(years[1]);
        else if(value.toInt() == 9) return Text(years[2]);
        else if(value.toInt() == 13) return Text(years[3]);
        else if(value.toInt() == 18) return Text(years[4]);
        else if(value.toInt() == 24) return Text(years[5]);
        else if(value.toInt() == 29) return Text(years[6]);
        else return Text('');
      }
  );


  // ********************************************************************************
  //Load dữ liệu cho dân cư và thu nhập
  Excel? _currentExcel;
  String? _currentExcelFile;
// Sử dụng một Map để lưu trữ các Sheets và dữ liệu của chúng
  Map<String, List<List<dynamic>>> _sheetsData = {};
  String? _selectedSheet;

  Widget _buildDataManagerContent() {
    if (_selectedSheet != null) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 50),
        child: Column(
          children: [
            // Tiêu đề bảng dữ liệu
            Text(
              'DÂN SỐ VÀ THU THẬP TRUNG BÌNH TỈNH VĨNH LONG',
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
                  columns: _sheetsData[_selectedSheet!]![0]
                      .sublist(0, 11)
                      .map<DataColumn>((item) =>
                      DataColumn(
                        label: Text(' '),
                      ))
                      .toList(),
                  rows: _sheetsData[_selectedSheet!]!.sublist(1)
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
            // Dòng chứa các nút nhấn
            Padding(
              padding: EdgeInsets.only(right: 250, top: 50),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.end, // Đặt nút sang phải
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // Đặt nút nhấn sang phải
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Hành động khi nhấn vào nút "Chỉnh sửa"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.all(16),
                            textStyle: TextStyle(color: Colors.white),
                            elevation: 7,
                            shadowColor: Colors.black.withOpacity(0.9),
                          ),
                          child: Text(
                            'Chỉnh sửa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            downloadExcelFile('assets/dancuTVL.xlsx');

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.all(16),
                            textStyle: TextStyle(color: Colors.white),
                            elevation: 7,
                            shadowColor: Colors.black.withOpacity(0.9),
                          ),
                          child: Text(
                            'Tải xuống',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
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
                                _currentExcel = excel;
                                _currentExcelFile = filePath;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(16),
                            textStyle: TextStyle(color: Colors.white),
                            elevation: 7,
                            shadowColor: Colors.black.withOpacity(0.9),
                          ),
                          child: Text(
                            '    Tải lên    ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }else {
      return Center(
        child: Text(
          'Không có dữ liệu để hiển thị.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
}
//Biểu đồ tròn cho chỉ tiêu chung
class PieChartSample2 extends StatelessWidget {
  final List<double> data1 = [30, 10, 10, 35, 15];
  final List<double> data2 = [20, 10, 15, 35, 20];
  final List<Color> colors = [
    Colors.green,
    Colors.brown,
    Colors.blue,
    Colors.red,
    Colors.orange,
  ];
  final List<String> sectors = [
    "Nông nghiệp",
    "Lâm nghiệp",
    "Thủy sản",
    "Công nghiệp",
    "Dịch vụ",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPieChart(data1, colors, sectors),
          ),
          Expanded(
            child: _buildPieChart(data2, colors, sectors),
          ),
          _buildLegends(colors, sectors),
        ],
      ),
    );
  }
//Vẽ biểu đồ tròn theo định danj
  Widget _buildPieChart(List<double> data, List<Color> colors, List<String> sectors) {
    List<PieChartSectionData> sections = List.generate(data.length, (i) {
      final isTouched = false;
      final double fontSize = isTouched ? 25 : 12;
      final double radius = isTouched ? 60 : 90;
      final value = data[i];
      final percentage = value / data.reduce((a, b) => a + b) * 100;

      return PieChartSectionData(
        color: colors[i],
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: sections,
      ),
    );
  }
}
//Tạo chú thích
Widget _buildLegends(List<Color> colors, List<String> sectors) {
  return Wrap(
    alignment: WrapAlignment.center,
    children: List<Widget>.generate(colors.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[index],
              ),
            ),
            SizedBox(width: 8),
            Text(sectors[index], style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    }),
  );
}
