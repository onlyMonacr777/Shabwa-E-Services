import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  static const Color greenMain     = Color(0xFF1B5E3F);
  static const Color greenDark     = Color(0xFF144D33);
  static const Color greenLight    = Color(0xFF2E8B5E);
  static const Color white         = Color(0xFFFFFFFF);
  static const Color whiteSoft     = Color(0xFFF5FAF7);
  static const Color goldPrimary   = Color(0xFFD4AF37);
  static const Color goldLight     = Color(0xFFF0D878);
  static const Color goldBg        = Color(0xFFFFF8E1);
  static const Color textDark      = Color(0xFF1A1A1A);
  static const Color textMedium    = Color(0xFF4A4A4A);
  static const Color textLight     = Color(0xFF8A9A8E);
  static const Color borderGreen   = Color(0xFFD0E8D8);
  static const Color errorRed      = Color(0xFFE74C3C);

  // Controllers for form fields
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
            color: white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: goldPrimary, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: goldBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: goldPrimary, width: 2),
                ),
                child: const Icon(Icons.check, color: goldPrimary, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                'تم إرسال طلبك بنجاح!',
                style: TextStyle(
                  color: textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'رقم طلبك: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
                style: const TextStyle(
                  color: goldPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'سيتم مراجعة طلبك والتواصل معك قريباً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textLight,
                  fontSize: 13,
                ),
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
                    color: greenMain,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: goldPrimary.withOpacity(0.4)),
                  ),
                  child: const Text(
                    'العودة للرئيسية',
                    style: TextStyle(
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: white),
              SizedBox(width: 8),
              Text('يرجى تعبئة جميع الحقول ورفع المستندات المطلوبة'),
            ],
          ),
          backgroundColor: errorRed,
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
      backgroundColor: greenMain,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildAppBar()),
            SliverToBoxAdapter(child: _buildImageHeader(service)),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
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
                color: white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: goldPrimary.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_forward, color: white, size: 22),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: goldPrimary.withOpacity(0.3)),
            ),
            child: const Icon(Icons.favorite_border, color: goldPrimary, size: 22),
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
        color: whiteSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: goldPrimary.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          service['image'],
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: whiteSoft,
              child: const Center(
                child: Icon(Icons.image_not_supported, color: textLight, size: 50),
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
              color: goldBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: goldPrimary.withOpacity(0.3)),
            ),
            child: Text(
              service['category'],
              style: const TextStyle(
                color: goldPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service['title'],
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
                color: whiteSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderGreen),
              ),
              child: Column(
                children: [
                  const Icon(Icons.access_time, color: greenMain, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    service['time'],
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'مدة التنفيذ',
                    style: TextStyle(color: textLight, fontSize: 11),
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
                color: goldBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: goldPrimary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.payments_outlined, color: goldPrimary, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    '${service['price']} ${service['currency']}',
                    style: const TextStyle(
                      color: goldPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'رسوم الخدمة',
                    style: TextStyle(color: textLight, fontSize: 11),
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
      child: Container(height: 1, color: borderGreen),
    );
  }

  Widget _buildDescription(Map<String, dynamic> service) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'وصف الخدمة',
                style: TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.info_outline, color: greenMain, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            service['description'],
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: textMedium,
              fontSize: 14,
              height: 1.6,
            ),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'المستندات المطلوبة',
                style: TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.description_outlined, color: greenMain, size: 20),
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
        color: isUploaded ? whiteSoft : white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUploaded ? greenLight : borderGreen,
          width: isUploaded ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // زر الرفع
          GestureDetector(
            onTap: () {
              setState(() {
                _uploadedDocs[doc] = !_uploadedDocs[doc]!;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isUploaded ? greenLight : goldBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isUploaded ? greenLight : goldPrimary.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUploaded ? Icons.check : Icons.upload_file,
                    color: isUploaded ? white : goldPrimary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isUploaded ? 'تم الرفع' : 'رفع',
                    style: TextStyle(
                      color: isUploaded ? white : goldPrimary,
                      fontSize: 11,
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
              style: TextStyle(
                color: isUploaded ? greenMain : textDark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isUploaded ? greenLight.withOpacity(0.2) : goldBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : Icons.attach_file,
              color: isUploaded ? greenLight : goldPrimary,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ===== نموذج تعبئة البيانات =====
  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'بيانات مقدم الطلب',
                style: TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.person_outline, color: greenMain, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'يرجى تعبئة جميع الحقول المطلوبة',
            style: TextStyle(
              color: textLight,
              fontSize: 12,
            ),
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
                style: TextStyle(
                  color: isEmpty ? errorRed : greenLight,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              label,
              style: const TextStyle(
                color: textDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: whiteSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEmpty && isRequired ? borderGreen : greenLight.withOpacity(0.5),
              width: isEmpty && isRequired ? 1 : 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            style: const TextStyle(color: textDark, fontSize: 14),
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: textLight.withOpacity(0.5),
                fontSize: 13,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: controller.text.isNotEmpty ? greenLight.withOpacity(0.15) : goldBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: controller.text.isNotEmpty ? greenLight : goldPrimary,
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

  // ===== الموافقة =====
  Widget _buildAgreement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () => setState(() => _isAgreed = !_isAgreed),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _isAgreed ? whiteSoft : white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isAgreed ? greenLight : borderGreen,
              width: _isAgreed ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _isAgreed ? greenLight : whiteSoft,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _isAgreed ? greenLight : borderGreen,
                    width: 2,
                  ),
                ),
                child: _isAgreed
                    ? const Icon(Icons.check, color: white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'أقر بأن جميع البيانات المدخلة صحيحة وأنني أوافق على شروط الخدمة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: _isAgreed ? textDark : textLight,
                    fontSize: 12,
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

  // ===== زر التقديم =====
  Widget _buildSubmitButton() {
    final isValid = _isFormValid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: _submitOrder,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isValid ? greenMain : textLight.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isValid ? goldPrimary.withOpacity(0.4) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.lock_outline,
                color: white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isValid ? 'تأكيد وإرسال الطلب' : 'أكمل جميع الحقول المطلوبة',
                style: const TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}