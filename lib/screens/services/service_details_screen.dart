import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import '/core/theme/app_theme.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final _fullNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  final Map<String, bool> _uploadedDocs = {};
  final Map<String, String> _uploadedFilesNames = {};

  bool _isAgreed = false;
  bool _isLiked = false;
  int _likesCount = 0;

  String? _orderId;
  String _userName = 'زائر';

  // ✅ معرف الخدمة الفريد
  String get _serviceId {
    final id = widget.service['id'];
    if (id != null && id.toString().isNotEmpty) {
      return id.toString();
    }
    // fallback: استخدم العنوان كـ ID
    final title = widget.service['title'] ?? '';
    return title.hashCode.toString();
  }

  @override
  void initState() {
    super.initState();

    final docs = widget.service['requiredDocs'] as List<dynamic>? ?? [];
    for (var doc in docs) {
      _uploadedDocs[doc.toString()] = false;
    }

    _loadUserData();
    _checkIfLiked();
    _loadLikesCount();
  }

  // ========================== رفع وهمي ==========================
  Future<void> _pickAndUploadFile(String docName) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: false,
      );

      if (result == null) return;

      final pickedFile = result.files.single;
      await Future.delayed(const Duration(seconds: 1));

      final fakeFileName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';

      setState(() {
        _uploadedDocs[docName] = true;
        _uploadedFilesNames[docName] = fakeFileName;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ تم رفع الملف بنجاح'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    } catch (e) {
      setState(() => _uploadedDocs[docName] = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _userName = doc['name'] ?? user.email?.split('@')[0] ?? 'مستخدم';
        });
      }
    }
  }

  // ✅ التحقق من اللايك
  Future<void> _checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final likeDoc = await FirebaseFirestore.instance
        .collection('services')
        .doc(_serviceId)
        .collection('likes')
        .doc(user.uid)
        .get();

    setState(() => _isLiked = likeDoc.exists);
  }

  // ✅ جلب عدد اللايكات
  Future<void> _loadLikesCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('services')
        .doc(_serviceId)
        .collection('likes')
        .get();

    setState(() => _likesCount = snapshot.docs.length);
  }

  // ✅ تبديل اللايك
  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سجل دخولك أولاً')),
      );
      return;
    }

    final serviceRef = FirebaseFirestore.instance.collection('services').doc(_serviceId);
    final likeRef = serviceRef.collection('likes').doc(user.uid);
    final userFavRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(_serviceId);

    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });

    try {
      if (_isLiked) {
        // إضافة لايك
        await likeRef.set({'timestamp': FieldValue.serverTimestamp()});
        // حفظ في مفضلات المستخدم
        await userFavRef.set({
          'serviceId': _serviceId,
          'title': widget.service['title'] ?? '',
          'category': widget.service['category'] ?? '',
          'price': widget.service['price'] ?? 0,
          'currency': widget.service['currency'] ?? 'ريال',
          'time': widget.service['time'] ?? '',
          'image': widget.service['image'] ?? '',
          'likedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // إزالة لايك
        await likeRef.delete();
        // إزالة من المفضلات
        await userFavRef.delete();
      }
    } catch (e) {
      print('❌ خطأ في اللايك: $e');
      // تراجع
      setState(() {
        _isLiked = !_isLiked;
        _likesCount += _isLiked ? 1 : -1;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _fullNameController.text.isNotEmpty &&
        _idNumberController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _uploadedDocs.values.every((uploaded) => uploaded) &&
        _isAgreed;
  }

  Future<void> _submitOrder() async {
    if (!_isFormValid) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      _orderId = DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13);

      await FirebaseFirestore.instance.collection('orders').doc(_orderId).set({
        "orderId": _orderId,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
        "uid": user?.uid ?? "",
        "accountEmail": user?.email ?? "",
        "fullName": _fullNameController.text.trim(),
        "idNumber": _idNumberController.text.trim(),
        "phone": _phoneController.text.trim(),
        "userEmail": _emailController.text.trim(),
        "address": _addressController.text.trim(),
        "notes": _notesController.text.trim(),
        "serviceTitle": widget.service['title'],
        "serviceId": _serviceId,
        "uploadedFiles": _uploadedFilesNames,
      });

      _showSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء الإرسال')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 28),
            const SizedBox(width: 8),
            const Text('تم بنجاح'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('تم إرسال طلبك بنجاح', textAlign: TextAlign.right),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Text(
                'رقم الطلب: $_orderId',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('البقاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
            child: const Text('حسناً', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDocUploadItem(String doc) {
    final isUploaded = _uploadedDocs[doc] ?? false;
    final fileName = _uploadedFilesNames[doc];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isUploaded
            ? LinearGradient(colors: [
          AppTheme.primaryGreenLight.withOpacity(0.1),
          AppTheme.emeraldLight.withOpacity(0.05)
        ])
            : LinearGradient(colors: [AppTheme.cardWhite, AppTheme.surfaceLight]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUploaded ? AppTheme.primaryGreenLight : AppTheme.borderLight,
          width: isUploaded ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _pickAndUploadFile(doc),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isUploaded
                        ? LinearGradient(colors: [AppTheme.primaryGreenLight, AppTheme.emeraldLight])
                        : LinearGradient(colors: [
                      AppTheme.primaryGreen.withOpacity(0.1),
                      AppTheme.primaryGreenLight.withOpacity(0.05)
                    ]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(isUploaded ? Icons.check : Icons.upload_file,
                          color: AppTheme.white, size: 16),
                      const SizedBox(width: 4),
                      Text(isUploaded ? 'تم الرفع' : 'رفع',
                          style: AppTheme.caption.copyWith(
                              color: AppTheme.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(doc, textAlign: TextAlign.right,
                    style: AppTheme.bodyMedium.copyWith(
                        color: isUploaded ? AppTheme.primaryGreen : AppTheme.textDark)),
              ),
            ],
          ),
          if (isUploaded && fileName != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_drive_file, size: 14, color: AppTheme.primaryGreen),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(fileName,
                        style: AppTheme.caption.copyWith(
                            color: AppTheme.primaryGreen, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      backgroundColor: AppTheme.primaryGreenDark,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildAppBar()),
            SliverToBoxAdapter(child: _buildImageHeader(service)),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  boxShadow: [AppTheme.cardShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    _buildTitleSection(service),
                    _buildPriceSection(service),
                    _buildDivider(),
                    _buildDescription(service),
                    _buildDivider(),
                    _buildRequiredDocs(service),
                    _buildDivider(),
                    _buildFormSection(),
                    _buildDivider(),
                    _buildAgreement(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.white.withOpacity(0.2),
                  AppTheme.white.withOpacity(0.1)
                ]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                boxShadow: [AppTheme.primaryShadow],
              ),
              child: Icon(Icons.arrow_forward, color: AppTheme.white, size: 22),
            ),
          ),
          // ✅ زر اللايك الفعلي
          GestureDetector(
            onTap: _toggleLike,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  _isLiked ? Colors.red.withOpacity(0.3) : AppTheme.white.withOpacity(0.2),
                  _isLiked ? Colors.red.withOpacity(0.1) : AppTheme.white.withOpacity(0.1)
                ]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: _isLiked ? Colors.red.withOpacity(0.5) : AppTheme.primaryGreen.withOpacity(0.3)),
                boxShadow: [AppTheme.primaryShadow],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_likesCount',
                    style: TextStyle(
                      color: _isLiked ? Colors.red : AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : AppTheme.emeraldLight,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.surfaceLight, AppTheme.cardWhite]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          service['image'] ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
            child: Icon(Icons.image_not_supported,
                color: AppTheme.white.withOpacity(0.6), size: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(Map<String, dynamic> service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppTheme.emeraldLight.withOpacity(0.3),
                AppTheme.primaryGreenLight.withOpacity(0.2)
              ]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
            ),
            child: Text(
              service['category'] ?? '',
              style: AppTheme.caption.copyWith(
                  color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service['title'] ?? '',
            textAlign: TextAlign.right,
            style: AppTheme.titleLarge.copyWith(color: AppTheme.textDark),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(Map<String, dynamic> service) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.cardWhite, AppTheme.surfaceLight]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.access_time, color: AppTheme.primaryGreen, size: 24),
                  const SizedBox(height: 8),
                  Text(service['time'] ?? '',
                      style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                      textDirection: TextDirection.rtl),
                  Text('مدة التنفيذ',
                      style: AppTheme.caption.copyWith(color: AppTheme.textLight),
                      textDirection: TextDirection.rtl),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.primaryGreenLight.withOpacity(0.1),
                  AppTheme.emeraldLight.withOpacity(0.05)
                ]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.payments_outlined, color: AppTheme.primaryGreen, size: 24),
                  const SizedBox(height: 8),
                  Text('${service['price'] ?? 0} ${service['currency'] ?? 'ريال'}',
                      style: AppTheme.bodyLarge.copyWith(color: AppTheme.primaryGreen),
                      textDirection: TextDirection.rtl),
                  Text('رسوم الخدمة',
                      style: AppTheme.caption.copyWith(color: AppTheme.textLight),
                      textDirection: TextDirection.rtl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppTheme.primaryGreen.withOpacity(0.1),
            AppTheme.borderLight
          ]),
        ),
      ),
    );
  }

  Widget _buildDescription(Map<String, dynamic> service) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('وصف الخدمة',
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                  textDirection: TextDirection.rtl),
              const SizedBox(width: 8),
              Icon(Icons.info_outline, color: AppTheme.primaryGreen, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            service['description'] ?? '',
            textAlign: TextAlign.right,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMedium, height: 1.6),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredDocs(Map<String, dynamic> service) {
    final docs = service['requiredDocs'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('المستندات المطلوبة',
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                  textDirection: TextDirection.rtl),
              const SizedBox(width: 8),
              Icon(Icons.description_outlined, color: AppTheme.primaryGreen, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          ...docs.map((doc) => _buildDocUploadItem(doc.toString())).toList(),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('بيانات مقدم الطلب',
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                  textDirection: TextDirection.rtl),
              const SizedBox(width: 8),
              Icon(Icons.person_outline, color: AppTheme.primaryGreen, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text('مرحباً $_userName، يرجى تعبئة جميع الحقول المطلوبة',
              style: AppTheme.caption.copyWith(color: AppTheme.textLight),
              textDirection: TextDirection.rtl, textAlign: TextAlign.right),
          const SizedBox(height: 16),
          _buildTextField(controller: _fullNameController, label: 'الاسم الكامل',
              hint: 'أحمد محمد علي', icon: Icons.person, onChanged: () => setState(() {})),
          const SizedBox(height: 12),
          _buildTextField(controller: _idNumberController, label: 'رقم الهوية',
              hint: '12345678901', icon: Icons.badge_outlined,
              keyboardType: TextInputType.number, onChanged: () => setState(() {})),
          const SizedBox(height: 12),
          _buildTextField(controller: _phoneController, label: 'رقم الجوال',
              hint: '777 123 456', icon: Icons.phone_android,
              keyboardType: TextInputType.phone, onChanged: () => setState(() {})),
          const SizedBox(height: 12),
          _buildTextField(controller: _emailController, label: 'البريد الإلكتروني (اختياري)',
              hint: 'example@email.com', icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress, isOptional: true,
              onChanged: () => setState(() {})),
          const SizedBox(height: 12),
          _buildTextField(controller: _addressController, label: 'العنوان',
              hint: 'صنعاء - حدة', icon: Icons.location_on_outlined,
              onChanged: () => setState(() {})),
          const SizedBox(height: 12),
          _buildTextField(controller: _notesController, label: 'ملاحظات إضافية (اختياري)',
              hint: 'أي ملاحظات خاصة بالطلب...', icon: Icons.notes,
              maxLines: 3, isOptional: true, onChanged: () => setState(() {})),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isOptional = false,
    required VoidCallback onChanged,
  }) {
    final isEmpty = controller.text.isEmpty;
    final isRequired = !isOptional;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isRequired)
              Text(' *',
                  style: AppTheme.caption.copyWith(
                      color: isEmpty ? AppTheme.primaryGreenDark : AppTheme.primaryGreenLight,
                      fontWeight: FontWeight.bold)),
            Text(label,
                style: AppTheme.caption.copyWith(
                    color: AppTheme.textDark, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.cardWhite, AppTheme.surfaceLight]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEmpty && isRequired
                  ? AppTheme.borderLight
                  : AppTheme.primaryGreen.withOpacity(0.5),
              width: isEmpty && isRequired ? 1 : 1.5,
            ),
            boxShadow: controller.text.isNotEmpty ? [AppTheme.cardShadow] : [],
          ),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.caption.copyWith(
                  color: AppTheme.textLight.withOpacity(0.5)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: controller.text.isNotEmpty
                      ? LinearGradient(colors: [
                    AppTheme.primaryGreenLight.withOpacity(0.15),
                    AppTheme.emeraldLight.withOpacity(0.1)
                  ])
                      : LinearGradient(colors: [
                    AppTheme.primaryGreen.withOpacity(0.1),
                    AppTheme.primaryGreenLight.withOpacity(0.05)
                  ]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon,
                    color: controller.text.isNotEmpty
                        ? AppTheme.primaryGreenLight
                        : AppTheme.primaryGreen,
                    size: 18),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () => setState(() => _isAgreed = !_isAgreed),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: _isAgreed
                ? LinearGradient(colors: [
              AppTheme.primaryGreenLight.withOpacity(0.1),
              AppTheme.emeraldLight.withOpacity(0.05)
            ])
                : LinearGradient(colors: [AppTheme.cardWhite, AppTheme.surfaceLight]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isAgreed ? AppTheme.primaryGreenLight : AppTheme.borderLight,
              width: _isAgreed ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: _isAgreed
                      ? LinearGradient(colors: [AppTheme.primaryGreenLight, AppTheme.emeraldLight])
                      : LinearGradient(colors: [AppTheme.cardWhite, AppTheme.surfaceLight]),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _isAgreed ? AppTheme.primaryGreenLight : AppTheme.borderLight,
                    width: 2,
                  ),
                ),
                child: _isAgreed
                    ? Icon(Icons.check, color: AppTheme.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'أقر بأن جميع البيانات المدخلة صحيحة وأنني أوافق على شروط الخدمة',
                  textAlign: TextAlign.right,
                  style: AppTheme.caption.copyWith(
                    color: _isAgreed ? AppTheme.textDark : AppTheme.textLight,
                    fontWeight: _isAgreed ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isValid = _isFormValid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: _submitOrder,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isValid
                ? AppTheme.primaryGradient
                : LinearGradient(colors: [
              AppTheme.primaryGreen.withOpacity(0.3),
              AppTheme.primaryGreenDark.withOpacity(0.2)
            ]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isValid ? Icons.check_circle : Icons.lock_outline,
                  color: AppTheme.white),
              const SizedBox(width: 8),
              Text(
                isValid ? 'تأكيد وإرسال الطلب' : 'أكمل جميع الحقول',
                style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}