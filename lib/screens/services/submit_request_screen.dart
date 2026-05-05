import 'package:flutter/material.dart';

class SubmitRequestScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const SubmitRequestScreen({super.key, required this.service});

  @override
  State<SubmitRequestScreen> createState() => _SubmitRequestScreenState();
}

class _SubmitRequestScreenState extends State<SubmitRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1F12),
        title: const Text('تقديم الطلب'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF0A1F12),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFD4AF37),
            secondary: Color(0xFF1B5E20),
            surface: Color(0xFF122B1A),
            onSurface: Colors.white,
          ),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _showSuccessDialog();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          type: StepperType.vertical,
          elevation: 0,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                children: [
                  if (_currentStep != 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFF5C8D6E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          foregroundColor: const Color(0xFF8FBC8F),
                        ),
                        child: const Text('السابق'),
                      ),
                    ),
                  if (_currentStep != 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentStep == 2 ? 'إرسال الطلب' : 'التالي',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('البيانات الشخصية',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('أدخل بياناتك الشخصية المطلوبة',
                  style: TextStyle(color: Color(0xFF5C8D6E), fontSize: 12)),
              content: _buildPersonalInfoForm(),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('رفع المستندات',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('قم برفع المستندات المطلوبة للخدمة',
                  style: TextStyle(color: Color(0xFF5C8D6E), fontSize: 12)),
              content: _buildDocumentsUpload(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text('المراجعة والتأكيد',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('راجع بياناتك قبل إرسال الطلب',
                  style: TextStyle(color: Color(0xFF5C8D6E), fontSize: 12)),
              content: _buildReviewStep(),
              isActive: _currentStep >= 2,
              state: StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          _textField('الاسم الكامل', Icons.person_outline),
          const SizedBox(height: 16),
          _textField('رقم الهوية الوطنية', Icons.badge_outlined),
          const SizedBox(height: 16),
          _textField('رقم الهاتف', Icons.phone_outlined),
          const SizedBox(height: 16),
          _textField('البريد الإلكتروني', Icons.email_outlined),
          const SizedBox(height: 16),
          _textField('العنوان الحالي', Icons.location_on_outlined),
        ],
      ),
    );
  }

  Widget _textField(String label, IconData icon) {
    return TextFormField(
      textAlign: TextAlign.right,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5C8D6E)),
        suffixIcon: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF8FBC8F), size: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF5C8D6E).withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF5C8D6E).withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
        ),
        filled: true,
        fillColor: const Color(0xFF122B1A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  Widget _buildDocumentsUpload() {
    return Column(
      children: [
        ...List.generate(
          widget.service['requiredDocs'].length,
              (index) => _uploadItem(widget.service['requiredDocs'][index]),
        ),
      ],
    );
  }

  Widget _uploadItem(String docName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF122B1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF5C8D6E).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  docName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'انقر لاختيار الملف من الجهاز',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF5C8D6E).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.cloud_upload, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF122B1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF5C8D6E).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _reviewItem('الخدمة', widget.service['title']),
          const Divider(color: Color(0xFF5C8D6E), height: 24),
          _reviewItem('الرسوم', '${widget.service['price']} ${widget.service['currency']}'),
          const Divider(color: Color(0xFF5C8D6E), height: 24),
          _reviewItem('المدة المتوقعة', widget.service['time']),
          const Divider(color: Color(0xFF5C8D6E), height: 24),
          _reviewItem('حالة الطلب', 'قيد المراجعة'),
        ],
      ),
    );
  }

  Widget _reviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5C8D6E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF122B1A),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B5E20).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 28),
              const Text(
                'تم إرسال الطلب بنجاح!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1F12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  'رقم الطلب: REQ-2026-001',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'سيتم إشعارك عند اكتمال المراجعة',
                style: TextStyle(
                  color: const Color(0xFF5C8D6E),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'العودة للرئيسية',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}