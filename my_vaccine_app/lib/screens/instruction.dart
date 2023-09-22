import 'package:flutter/material.dart';

class VaccineInstructionCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const VaccineInstructionCard({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VaccineInstructionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ' تعليمات التطعيم',
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          VaccineInstructionCard(
            title: 'تعليمات لأخذ اللقاح للأطفال الرضع',
            description:
                'تأكد من الحصول على اللقاح في الوقت المحدد واتبع جميع التعليمات المقدمة من الطبيب.',
            color: Colors.blue,
          ),
          SizedBox(height: 16),
          VaccineInstructionCard(
            title: 'أهمية التعامل مع الأطفال الرضع بعد أخذ اللقاح',
            description:
                'ابقِ الطفل في مكان هادئ ونظيف وتأكد من توفير العناية الجيدة له. قم بتطبيق التعليمات المقدمة من الطبيب لتقديم الراحة والرعاية للطفل.',
            color: Colors.green,
          ),
          SizedBox(height: 16),
          VaccineInstructionCard(
            title: 'مضاعفات اللقاح وكيفية التعامل معها',
            description:
                'بعد أخذ اللقاح، قد تظهر بعض المضاعفات العابرة مثل احمرار أو انتفاخ في موقع اللقاح. في حالة حدوث أي مضاعفات غير معتادة أو تأثيرات جانبية خطيرة، يجب التواصل مع الطبيب فورًا.',
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
