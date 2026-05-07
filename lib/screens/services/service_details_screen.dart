import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/theme/app_theme.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({super.key, required this.service});

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

  // Uploaded documents tracking
  final Map<String, bool> _uploadedDocs = {};
  bool _isAgreed = false;

  @override
  void initState() {
    super.initState();
    final docs = widget.service['requiredDocs'] as List<dynamic>;
    for (var doc in docs) {
      _uploadedDocs[doc.toString()] = false;
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primaryGreen, width: 2),
            boxShadow: [AppTheme.primaryShadow],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryGreenLight.withOpacity(0.3), AppTheme.emeraldLight.withOpacity(0.2)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryGreen, width: 2),
                ),
                child: const Icon(Icons.check, color: AppTheme.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                'تم إرسال طلبك بنجاح!',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textDark,
                  height: 1.2,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              Text(
                'رقم طلبك: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              Text(
                'سيتم مراجعة طلبك والتواصل معك قريباً',
                textAlign: TextAlign.center,
                style: AppTheme.caption.copyWith(
                  color: AppTheme.textLight,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.4)),
                    boxShadow: [AppTheme.primaryShadow],
                  ),
                  child: Text(
                    'العودة للرئيسية',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitOrder() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: AppTheme.white),
              const SizedBox(width: 8),
              Text('يرجى تعبئة جميع الحقول ورفع المستندات المطلوبة', style: AppTheme.caption.copyWith(color: AppTheme.white)),
            ],
          ),
          backgroundColor: AppTheme.primaryGreenDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    _showSuccessDialog();
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
                gradient: LinearGradient(
                  colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                boxShadow: [AppTheme.primaryShadow],
              ),
              child: Icon(Icons.arrow_forward, color: AppTheme.white, size: 22),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.white.withOpacity(0.2), AppTheme.white.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              boxShadow: [AppTheme.primaryShadow],
            ),
            child: Icon(Icons.favorite_border, color: AppTheme.emeraldLight, size: 22),
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
        gradient: LinearGradient(
          colors: [AppTheme.surfaceLight, AppTheme.cardWhite],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          service['image'],
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: Icon(
                Icons.image_not_supported,
                color: AppTheme.white.withOpacity(0.6),
                size: 50,
              ),
            );
          },
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
              gradient: LinearGradient(
                colors: [AppTheme.emeraldLight.withOpacity(0.3), AppTheme.primaryGreenLight.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
            ),
            child: Text(
              service['category'],
              style: AppTheme.caption.copyWith(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service['title'],
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
                gradient: LinearGradient(
                  colors: [AppTheme.cardWhite, AppTheme.surfaceLight],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                // تم إزالة boxShadow من هنا
              ),
              child: Column(
                children: [
                  Icon(Icons.access_time, color: AppTheme.primaryGreen, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    service['time'],
                    style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    'مدة التنفيذ',
                    style: AppTheme.caption.copyWith(color: AppTheme.textLight),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryGreenLight.withOpacity(0.1), AppTheme.emeraldLight.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                // تم إزالة boxShadow من هنا
              ),
              child: Column(
                children: [
                  Icon(Icons.payments_outlined, color: AppTheme.primaryGreen, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    '${service['price']} ${service['currency']}',
                    style: AppTheme.bodyLarge.copyWith(color: AppTheme.primaryGreen),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    'رسوم الخدمة',
                    style: AppTheme.caption.copyWith(color: AppTheme.textLight),
                    textDirection: TextDirection.rtl,
                  ),
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
          gradient: LinearGradient(
            colors: [AppTheme.primaryGreen.withOpacity(0.1), AppTheme.borderLight],
          ),
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
              Text(
                'وصف الخدمة',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.info_outline, color: AppTheme.primaryGreen, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            service['description'],
            textAlign: TextAlign.right,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textMedium,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredDocs(Map<String, dynamic> service) {
    final docs = service['requiredDocs'] as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'المستندات المطلوبة',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                textDirection: TextDirection.rtl,
              ),
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

  Widget _buildDocUploadItem(String doc) {
    final isUploaded = _uploadedDocs[doc] ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: isUploaded
            ? LinearGradient(colors: [AppTheme.primaryGreenLight.withOpacity(0.1), AppTheme.emeraldLight.withOpacity(0.05)])
            : LinearGradient(colors: [AppTheme.cardWhite, AppTheme.surfaceLight]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUploaded ? AppTheme.primaryGreenLight : AppTheme.borderLight,
          width: isUploaded ? 2 : 1,
        ),
        boxShadow: isUploaded ? [AppTheme.cardShadow] : [],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _uploadedDocs[doc] = !_uploadedDocs[doc]!;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: isUploaded
                    ? LinearGradient(colors: [AppTheme.primaryGreenLight, AppTheme.emeraldLight])
                    : LinearGradient(colors: [AppTheme.primaryGreen.withOpacity(0.1), AppTheme.primaryGreenLight.withOpacity(0.05)]),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUploaded ? Icons.check : Icons.upload_file,
                    color: AppTheme.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isUploaded ? 'تم الرفع' : 'رفع',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              doc,
              textAlign: TextAlign.right,
              style: AppTheme.bodyMedium.copyWith(
                color: isUploaded ? AppTheme.primaryGreen : AppTheme.textDark,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: isUploaded
                  ? LinearGradient(colors: [AppTheme.primaryGreenLight.withOpacity(0.3), AppTheme.emeraldLight.withOpacity(0.2)])
                  : LinearGradient(colors: [AppTheme.primaryGreen.withOpacity(0.1), AppTheme.primaryGreenLight.withOpacity(0.05)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : Icons.attach_file,
              color: isUploaded ? AppTheme.primaryGreenLight : AppTheme.primaryGreen,
              size: 18,
            ),
          ),
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
              Text(
                'بيانات مقدم الطلب',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textDark),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Icon(Icons.person_outline, color: AppTheme.primaryGreen, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'يرجى تعبئة جميع الحقول المطلوبة',
            style: AppTheme.caption.copyWith(color: AppTheme.textLight),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _fullNameController,
            label: 'الاسم الكامل',
            hint: 'أحمد محمد علي',
            icon: Icons.person,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _idNumberController,
            label: 'رقم الهوية',
            hint: '12345678901',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _phoneController,
            label: 'رقم الجوال',
            hint: '777 123 456',
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _emailController,
            label: 'البريد الإلكتروني (اختياري)',
            hint: 'example@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isOptional: true,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _addressController,
            label: 'العنوان',
            hint: 'صنعاء - حدة',
            icon: Icons.location_on_outlined,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _notesController,
            label: 'ملاحظات إضافية (اختياري)',
            hint: 'أي ملاحظات خاصة بالطلب...',
            icon: Icons.notes,
            maxLines: 3,
            isOptional: true,
            onChanged: () => setState(() {}),
          ),
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
              Text(
                ' *',
                style: AppTheme.caption.copyWith(
                  color: isEmpty ? AppTheme.primaryGreenDark : AppTheme.primaryGreenLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              label,
              style: AppTheme.caption.copyWith(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.cardWhite, AppTheme.surfaceLight],
            ),
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
                color: AppTheme.textLight.withOpacity(0.5),
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: controller.text.isNotEmpty
                      ? LinearGradient(colors: [AppTheme.primaryGreenLight.withOpacity(0.15), AppTheme.emeraldLight.withOpacity(0.1)])
                      : LinearGradient(colors: [AppTheme.primaryGreen.withOpacity(0.1), AppTheme.primaryGreenLight.withOpacity(0.05)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: controller.text.isNotEmpty
                      ? AppTheme.primaryGreenLight
                      : AppTheme.primaryGreen,
                  size: 18,
                ),
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
                ? LinearGradient(colors: [AppTheme.primaryGreenLight.withOpacity(0.1), AppTheme.emeraldLight.withOpacity(0.05)])
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
                : LinearGradient(colors: [AppTheme.primaryGreen.withOpacity(0.3), AppTheme.primaryGreenDark.withOpacity(0.2)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isValid ? AppTheme.primaryGreen.withOpacity(0.4) : Colors.transparent,
            ),
            boxShadow: isValid ? [AppTheme.primaryShadow] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.lock_outline,
                color: AppTheme.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isValid ? 'تأكيد وإرسال الطلب' : 'أكمل جميع الحقول المطلوبة',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}