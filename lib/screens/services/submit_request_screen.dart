import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SubmitRequestScreen extends StatefulWidget {
  const SubmitRequestScreen({super.key});

  @override
  State<SubmitRequestScreen> createState() => _SubmitRequestScreenState();
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تقديم طلب')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('معلومات مقدم الطلب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextFormField(decoration: InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person))),
            SizedBox(height: 12),
            TextFormField(decoration: InputDecoration(labelText: 'رقم الهوية', prefixIcon: Icon(Icons.badge))),
            SizedBox(height: 12),
            TextFormField(decoration: InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone))),
            SizedBox(height: 24),
            Text('الملفات المطلوبة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildUploadBox('صورة الهوية'),
            SizedBox(height: 12),
            _buildUploadBox('صورة شخصية'),
            SizedBox(height: 12),
            _buildUploadBox('إيصال الدفع'),
            SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(labelText: 'ملاحظات إضافية', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال الطلب بنجاح')));
                  }
                },
                child: Text('إرسال الطلب', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox(String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(Icons.upload_file, color: AppColors.ocean, size: 32),
          SizedBox(width: 16),
          Expanded(child: Text(label)),
          ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.add), label: Text('رفع')),
        ],
      ),
    );
  }
}
