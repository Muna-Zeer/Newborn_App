import 'package:flutter/material.dart';
import 'package:newborn_app/widgets/motherForm.dart';
import '../constant/colors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Mother Form'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MotherForm(motherId: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
