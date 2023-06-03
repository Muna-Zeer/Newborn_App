import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../widgets/newborns_table.dart';

class NewbornsScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text('Newborns Table'),
      backgroundColor: AppColors.primary,
    ),
    body:Container(
      padding:EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:Alignment.topLeft,
          end:Alignment.bottomRight,
          colors:[AppColors.primary,AppColors.secondary],
        ),
      ),
      child: NewbornsTable(),
    ),
   );
  }

}
