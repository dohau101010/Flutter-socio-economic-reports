import 'package:flutter/material.dart';

//Giao diện quản lý cán bộ
class ManagementTabContent extends StatefulWidget {
  @override
  _ManagementTabContentState createState() => _ManagementTabContentState();
}

class _ManagementTabContentState extends State<ManagementTabContent> {
  int _selectedIndex = 0; // -1: không chọn, 0: "Quản Lý Tỉnh", 1: "Quản Lý Huyện"

  String _selectedTableName = ''; // Biến để lưu tên bảng hiện tại

  // Dữ liệu mẫu cho "Quản Lý Tỉnh"
  List<Map<String, String>> provinceData = [
    {
      'name': 'Nguyễn Minh Khoa An',
      'phone': '0345678910',
      'position': 'Quản lý chính',
    },
    {
      'name': 'Đỗ Trung Hậu',
      'phone': '0345678911',
      'position': 'Quản lý phụ',
    },
  ];

  // Dữ liệu mẫu cho "Quản Lý Huyện"
  List<Map<String, String>> districtData = [
    {
      'name': 'Nguyễn Minh Khoa An',
      'phone': '0345678920',
      'position': 'Quản lý chính',
    },
    {
      'name': 'Đỗ Trung Hậu',
      'phone': '0345678921',
      'position': 'Quản lý phụ',
    },
  ];

  // Dữ liệu mẫu cho cán bộ
  List<Map<String, String>> officerData = [
    {
      'name': 'Nguyễn Minh Khoa An',
      'phone': '0345678930',
      'position': 'Cán bộ',
      'field': 'Nông nghiệp', // Thêm trường mới là "Lĩnh vực"
    },
    {
      'name': 'Đỗ Trung Hậu',
      'phone': '0345678931',
      'position': 'Cán bộ',
      'field': 'Công nghiệp', // Thêm trường mới là "Lĩnh vực"
    },
    {
      'name': 'Đỗ Hoàng Thắng',
      'phone': '0345612631',
      'position': 'Cán bộ',
      'field': 'Dịch vụ', // Thêm trường mới là "Lĩnh vực"
    },
    {
      'name': 'Nguyễn Thị Trúc Mai',
      'phone': '0345878931',
      'position': 'Cán bộ',
      'field': 'Lâm nghiệp', // Thêm trường mới là "Lĩnh vực"
    },
    {
      'name': 'Phan Văn Nguyên',
      'phone': '0345677551',
      'position': 'Cán bộ',
      'field': 'Thủy sản', // Thêm trường mới là "Lĩnh vực"
    },
  ];

  // Cập nhật để xử lý cả hai trường hợp trong một hàm
  void _deleteRow(int index) {
    setState(() {
      if (_selectedIndex == 0) {
        provinceData.removeAt(index);
      } else if (_selectedIndex == 1) {
        districtData.removeAt(index);
      } else if (_selectedIndex == 2) {
        officerData.removeAt(index);
      }
    });
  }
//Chinhr sửa cập nhât dữ liệu
  void _editRow(int index, String newName, String newPhone,
      [String? newField]) {
    setState(() {
      if (_selectedIndex == 0) {
        provinceData[index]['name'] = newName;
        provinceData[index]['phone'] = newPhone;
      } else if (_selectedIndex == 1) {
        districtData[index]['name'] = newName;
        districtData[index]['phone'] = newPhone;
      } else if (_selectedIndex == 2) {
        officerData[index]['name'] = newName;
        officerData[index]['phone'] = newPhone;
        if (newField != null)
          officerData[index]['field'] = newField; // Cập nhật "Lĩnh vực"
      }
    });
  }
//Hộp thoại để chỉnh sửa thông tin cans bộ
  void _showEditDialog(int index) {
    List<Map<String, String>> currentData = _selectedIndex == 0
        ? provinceData
        : _selectedIndex == 1 ? districtData : officerData;
    TextEditingController nameController = TextEditingController(
        text: currentData[index]['name']);
    TextEditingController phoneController = TextEditingController(
        text: currentData[index]['phone']);
    // Khởi tạo fieldController với giá trị mặc định là chuỗi rỗng để tránh lỗi
    TextEditingController fieldController = TextEditingController(
        text: _selectedIndex == 2 ? currentData[index]['field'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa thông tin $_selectedTableName'),
          // Sử dụng biến để hiển thị tên bảng
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController,
                  decoration: InputDecoration(labelText: 'Họ và Tên')),
              TextField(controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Số điện thoại')),
              // Bây giờ không cần kiểm tra _selectedIndex == 2 nữa vì fieldController luôn được khởi tạo
              TextField(controller: fieldController,
                  decoration: InputDecoration(labelText: 'Lĩnh vực')),
            ],
          ),
          actions: [
            TextButton(child: Text('Hủy'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                _editRow(index, nameController.text, phoneController.text,
                    fieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//Hộp thoại để thêm thông tin cán bộ
  void _showAddOfficerDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    String field = 'Nông nghiệp'; // Giá trị mặc định cho radio button

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm cán bộ mới'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController,
                      decoration: InputDecoration(labelText: 'Họ và tên')),
                  TextField(controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Số điện thoại')),
                  Column(
                    children: <String>[
                      'Nông nghiệp',
                      'Lâm nghiệp',
                      'Thủy sản',
                      'Công nghiệp',
                      'Dịch vụ'
                    ]
                        .map((String value) {
                      return RadioListTile<String>(
                        title: Text(value),
                        value: value,
                        groupValue: field,
                        onChanged: (String? newValue) {
                          setState(() {
                            field = newValue!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                // Thêm thông tin mới vào danh sách cán bộ
                setState(() {
                  officerData.add({
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'position': 'Cán bộ',
                    'field': field,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
//Lựa chọn giao diện hiển thị tuyf thuộc vào tab muốn chọn
  Widget _buildContentBasedOnSelection(int selectedIndex) {
    if (selectedIndex == 0) {
      _selectedTableName = 'Quản lý tỉnh';
    } else if (selectedIndex == 1) {
      _selectedTableName = 'Quản lý huyện';
    } else if (selectedIndex == 2) {
      _selectedTableName = 'Quản lý cán bộ';
    } else {
      _selectedTableName = '';
    }

    List<Map<String, String>> currentData = selectedIndex == 0
        ? provinceData
        : selectedIndex == 1
        ? districtData
        : officerData;

    //Bố trí dưới dạng wrap
    //Nó cho phép các widget con tự động chuyển hàng hoặc cột
    // khi chúng không thể hiển thị trên cùng một hàng hoặc cột.
    // Wrap không cần phải biết trước số lượng widget con cần hiển thị,
    // và nó linh hoạt hơn trong việc đáp ứng với kích thước màn hình
    // hoặc kích thước của parent widget.
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedTableName.isNotEmpty) //nếu có chọn tab
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTableName, //Tên tab dangd chọn
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Nếu là quản lý cán bộ thì có thêm nút "thêm cán bộ"
                  if (selectedIndex == 2) _buildOfficerAddingButton(),
                ],
              ),
            ),
          Wrap(
            spacing: 10, // Khoảng cách giữa các phần tử
            runSpacing: 10, // Khoảng cách giữa các hàng
            children: [
              ..._buildDataWidgets(currentData, selectedIndex), // Dữ liệu hiện có
            ],
          ),
        ],
      ),
    );
  }

//Xây dựng nút nhấn thêm cán bộ
  Widget _buildOfficerAddingButton() {
    return ElevatedButton(
      onPressed: () {
        _showAddOfficerDialog(); //hiển thị hộp thoại điền thông tin vào
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Màu nền xanh lá cây
        elevation: 4, // Độ nâng của shadow
        shadowColor: Colors.black, // Màu shadow
      ),
      child: Text(
        'Thêm cán bộ',
        style: TextStyle(color: Colors.white), // Chữ màu trắng
      ),
    );
  }

//Bố trí dữ liệu vào trong từng ô wrap
  List<Widget> _buildDataWidgets(
      List<Map<String, String>> currentData,
      int selectedIndex,
      ) {
    return currentData.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, String> data = entry.value;
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          //đóng khung, bo tròn
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //ghi nội dung vào gồm: Tên, sdt, vị trí và Lĩnh vực nếu là cán bộ
              children: [
                Text(
                  'Họ và Tên: ${data['name'] ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRow(index),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'SĐT: ${data['phone'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Vị trí: ${data['position'] ?? ''}',
              style: TextStyle(fontSize: 16),
            ),
            if (selectedIndex == 2) ...[
              SizedBox(height: 4),
              Text(
                'Lĩnh vực: ${data['field'] ?? ''}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }
 //Xây dựng thanh sidebar gồm 2 tab,  1 tag sổ xuống được, và 1 tab cố định
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView( //tag cho phép cuộn nếu tràn)
            child: ListBody(
              children: [
                ExpansionTile( //Tab có thể sổ ra
                  title: Text(
                    'Tài Khoản Quản Lý',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        'Quản Lý Tỉnh',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Quản Lý Huyện',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    'Tài Khoản Cán Bộ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        VerticalDivider(thickness: 1, width: 1),
        // Phần nội dun chính
        //Thực hiện giao diện tương ứng tab được chọn.
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            child: _buildContentBasedOnSelection(_selectedIndex),
          ),
        ),
      ],
    );
  }
}

