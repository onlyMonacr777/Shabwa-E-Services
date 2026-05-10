import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() =>
      _AdminServicesScreenState();
}

class _AdminServicesScreenState
    extends State<AdminServicesScreen> {

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();

  bool _requiresUpload = false;

  Future<void> _addService() async {

    if (_titleCtrl.text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('services')
        .add({

      'title': _titleCtrl.text.trim(),

      'description': _descCtrl.text.trim(),

      'price': _priceCtrl.text.trim(),

      'duration': _durationCtrl.text.trim(),

      'requiresUpload': _requiresUpload,

      'createdAt': FieldValue.serverTimestamp(),
    });

    _titleCtrl.clear();
    _descCtrl.clear();
    _priceCtrl.clear();
    _durationCtrl.clear();

    setState(() {
      _requiresUpload = false;
    });

    Navigator.pop(context);
  }

  Future<void> _deleteService(String id) async {

    await FirebaseFirestore.instance
        .collection('services')
        .doc(id)
        .delete();
  }

  void _showAddDialog() {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (_) {

        return Padding(

          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),

          child: Container(

            padding: const EdgeInsets.all(24),

            decoration: const BoxDecoration(

              color: Color(0xFF111827),

              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),

            child: SingleChildScrollView(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Center(
                    child: Text(
                      'إضافة خدمة جديدة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildField(
                    _titleCtrl,
                    'اسم الخدمة',
                    Icons.design_services,
                  ),

                  const SizedBox(height: 16),

                  _buildField(
                    _descCtrl,
                    'وصف الخدمة',
                    Icons.description,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),

                  _buildField(
                    _priceCtrl,
                    'السعر',
                    Icons.attach_money,
                  ),

                  const SizedBox(height: 16),

                  _buildField(
                    _durationCtrl,
                    'مدة التنفيذ',
                    Icons.timer,
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [

                        Checkbox(
                          value: _requiresUpload,
                          activeColor: Colors.blue,
                          onChanged: (v) {
                            setState(() {
                              _requiresUpload = v!;
                            });
                          },
                        ),

                        const SizedBox(width: 8),

                        const Text(
                          'الخدمة تتطلب رفع ملفات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addService,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'إضافة الخدمة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(
      TextEditingController controller,
      String hint,
      IconData icon, {
        int maxLines = 1,
      }) {

    return Container(

      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.05),

        borderRadius: BorderRadius.circular(16),
      ),

      child: TextField(

        controller: controller,

        maxLines: maxLines,

        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
          ),

          prefixIcon: Icon(
            icon,
            color: Colors.white70,
          ),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(

      textDirection: TextDirection.rtl,

      child: Scaffold(

        backgroundColor: const Color(0xFF0B1120),

        floatingActionButton: FloatingActionButton(

          backgroundColor: const Color(0xFF2563EB),

          onPressed: _showAddDialog,

          child: const Icon(Icons.add),
        ),

        appBar: AppBar(

          backgroundColor: const Color(0xFF111827),

          title: const Text(
            'إدارة الخدمات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: StreamBuilder<QuerySnapshot>(

          stream: FirebaseFirestore.instance
              .collection('services')
              .orderBy('createdAt', descending: true)
              .snapshots(),

          builder: (context, snapshot) {

            if (!snapshot.hasData) {

              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {

              return const Center(

                child: Text(
                  'لا توجد خدمات',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              );
            }

            return ListView.builder(

              padding: const EdgeInsets.all(16),

              itemCount: docs.length,

              itemBuilder: (context, index) {

                final doc = docs[index];

                final data =
                doc.data() as Map<String, dynamic>;

                return Container(

                  margin: const EdgeInsets.only(bottom: 16),

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(

                    color: const Color(0xFF1E293B),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Row(

                        children: [

                          Expanded(
                            child: Text(
                              data['title'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          IconButton(

                            onPressed: () =>
                                _deleteService(doc.id),

                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        data['description'] ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [

                          _infoCard(
                            Icons.attach_money,
                            'السعر',
                            data['price'] ?? '',
                          ),

                          const SizedBox(width: 12),

                          _infoCard(
                            Icons.timer,
                            'المدة',
                            data['duration'] ?? '',
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(

                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(

                          color: (data['requiresUpload'] == true)
                              ? Colors.orange.withOpacity(0.15)
                              : Colors.green.withOpacity(0.15),

                          borderRadius:
                          BorderRadius.circular(14),
                        ),

                        child: Row(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            Icon(
                              data['requiresUpload'] == true
                                  ? Icons.upload_file
                                  : Icons.check_circle,
                              color: data['requiresUpload'] == true
                                  ? Colors.orange
                                  : Colors.green,
                              size: 18,
                            ),

                            const SizedBox(width: 8),

                            Text(
                              data['requiresUpload'] == true
                                  ? 'تتطلب رفع ملفات'
                                  : 'لا تحتاج رفع ملفات',
                              style: TextStyle(
                                color:
                                data['requiresUpload'] == true
                                    ? Colors.orange
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard(
      IconData icon,
      String title,
      String value,
      ) {

    return Expanded(

      child: Container(

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(

          color: Colors.white.withOpacity(0.05),

          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(

          children: [

            Icon(
              icon,
              color: Colors.blue,
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}