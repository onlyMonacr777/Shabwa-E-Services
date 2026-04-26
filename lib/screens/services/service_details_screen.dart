import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // AppBar قابل للطي مع صورة الخدمة
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Color(service['color']),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(service['color']),
                      Color(service['color']).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // أيقونة كبيرة في الخلفية
                    Positioned(
                      right: -50,
                      bottom: -50,
                      child: Icon(
                        service['icon'],
                        size: 250,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    // المحتوى
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              service['icon'],
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            service['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // المحتوى
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات سريعة
                  Row(
                    children: [
                      _buildInfoCard(
                        'المدة',
                        service['time'],
                        Icons.schedule,
                        Color(service['color']),
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        'التكلفة',
                        service['price'],
                        Icons.payments,
                        Color(service['color']),
                      ),
                      const SizedBox(width: 12),
                      _buildInfoCard(
                        'التقييم',
                        '${service['rating']}',
                        Icons.star,
                        Colors.amber,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // الوصف
                  const Text(
                    'نبذة عن الخدمة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تتيح هذه الخدمة للمواطنين إنجاز معاملاتهم بسهولة ويسر دون الحاجة للزيارة الميدانية. يتم معالجة الطلب إلكترونياً وإشعارك بكل تحديث.',
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xFF64748B),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // المتطلبات
                  const Text(
                    'المتطلبات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem('صورة شخصية حديثة'),
                  _buildRequirementItem('صورة من الهوية الوطنية'),
                  _buildRequirementItem('تعبئة النموذج الإلكتروني'),
                  _buildRequirementItem('دفع الرسوم المستحقة'),

                  const SizedBox(height: 30),

                  // خطوات التقديم
                  const Text(
                    'خطوات التقديم',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStepItem(1, 'تسجيل الدخول', true),
                  _buildStepItem(2, 'تعبئة البيانات', false),
                  _buildStepItem(3, 'رفع المستندات', false),
                  _buildStepItem(4, 'تأكيد الطلب', false),

                  const SizedBox(height: 40),

                  // زر التقديم
                  GestureDetector(
                    onTap: () {
                      // الانتقال لشاشة تقديم الطلب
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(service['color']),
                            Color(service['color']).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(service['color']).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'تقديم الطلب الآن',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Color(0xFF4CAF50),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF1A5F7A).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                '$step',
                style: const TextStyle(
                  color: Color(0xFF1A5F7A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: isCompleted
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF1E293B),
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}