import 'package:flutter/material.dart';

class AdminSearchScreen
    extends StatefulWidget {

  const AdminSearchScreen({
    super.key,
  });

  @override
  State<AdminSearchScreen>
  createState() =>
      _AdminSearchScreenState();
}

class _AdminSearchScreenState
    extends State<AdminSearchScreen> {

  final controller =
  TextEditingController();

  List<String> results = [];

  final data = [
    'جواز سفر',
    'بطاقة شخصية',
    'شهادة ميلاد',
    'رخصة قيادة',
  ];

  void search(String value) {

    setState(() {

      results = data.where((item) {

        return item.contains(value);

      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'البحث',
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: controller,

              onChanged: search,

              textAlign:
              TextAlign.right,

              decoration:
              const InputDecoration(
                hintText:
                'ابحث هنا...',
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount:
                results.length,

                itemBuilder:
                    (context, index) {

                  return ListTile(
                    title: Text(
                      results[index],
                      textDirection:
                      TextDirection.rtl,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}