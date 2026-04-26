import 'package:flutter/material.dart';

class MyRequestsScreen extends StatefulWidget {
  @override
  _MyRequestsScreenState createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  int selectedTab = 0;
  bool isLoading = false;

  final List<List<Map<String, dynamic>>> tabsData = [
    // نشطة
    [
      {'id': 'REQ001', 'title': 'استخراج بطاقة شخصية', 'progress': 0.7, 'status': 'قيد المراجعة'},
      {'id': 'REQ002', 'title': 'تجديد جواز سفر', 'progress': 0.4, 'status': 'مقبول'},
    ],
    // مكتملة
    [
      {'id': 'CMP001', 'title': 'شهادة ميلاد', 'progress': 1.0, 'status': 'مكتمل'},
      {'id': 'CMP002', 'title': 'ترخيص تجاري', 'progress': 1.0, 'status': 'مكتمل'},
    ],
    // ملغية
    [
      {'id': 'CAN001', 'title': 'بطاقة هوية', 'progress': 0.0, 'status': 'ملغي'},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'طلباتي',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Color(0xFF0E7A4A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => isLoading = true);
          await Future.delayed(Duration(seconds: 1));
          setState(() => isLoading = false);
        },
        child: Column(
          children: [
            // فلتر
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Text('ابحث في الطلبات...', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF0E7A4A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.layers, color: Color(0xFF0E7A4A), size: 20),
                        SizedBox(width: 6),
                        Text('12', style: TextStyle(
                          color: Color(0xFF0E7A4A),
                          fontWeight: FontWeight.bold,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _tabButton('نشطة', 0, Colors.orange)),
                  SizedBox(width: 8),
                  Expanded(child: _tabButton('مكتملة', 1, Colors.green)),
                  SizedBox(width: 8),
                  Expanded(child: _tabButton('ملغية', 2, Colors.red)),
                ],
              ),
            ),

            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _requestsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title, int index, Color color) {
    bool active = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: active ? Border.all(color: color, width: 2) : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? color : Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _requestsList() {
    final requests = tabsData[selectedTab];

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد طلبات',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text('ستظهر طلباتك هنا',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final request = requests[index];
        return _requestCard(request);
      },
    );
  }

