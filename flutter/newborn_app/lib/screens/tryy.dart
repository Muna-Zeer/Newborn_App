// // import 'package:flutter/material.dart';
// // import '../screens/newborns_screen.dart';
// // import '../screens/newborn.dart';
// // import '../constant/colors.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import '../constant/paginate_table.dart';

// // class NewbornsTable extends StatefulWidget {
// //   @override
// //   _NewbornsTableState createState() => _NewbornsTableState();
// // }

// // class _NewbornsTableState extends State<NewbornsTable> {
// //   final PaginationService _paginationService = PaginationService(onChange:
// //       (isLoading, items, currentPage, totalPages, hasNextPage, hasPrevPage) {
// //     // Handle changes to pagination data here
// //   });
// //   List<Newborn> _newborns = [];
// //   int _currentPage = 1;
// //   int _totalPages = 1;
// //   bool _isLoading = false;
// //   bool _hasNextPage = false;
// //   bool _hasPrevPage = false;
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchNewborns();
// //   }

// //   Future<void> _fetchNewborns() async {
// //     final paginationService = PaginationService(
// //       onChange: (isLoading, items, currentPage, totalPages, hasNextPage,
// //           hasPrevPage) {
// //         setState(() {
// //           _isLoading = isLoading;
// //           _currentPage = currentPage;
// //           _totalPages = totalPages;
// //           _hasNextPage = hasNextPage;
// //           _hasPrevPage = hasPrevPage;

// //           if (items != null && items is List<dynamic>) {
// //             _newborns = items
// //                 .map((item) => Newborn.fromJson(item as Map<String, dynamic>))
// //                 .toList();
// //             print('pagination $_newborns');
// //             print('items $items');
// //           }
// //         });
// //       },
// //     );

// //     try {
// //       final url = 'http://127.0.0.1:8000/api/newbornWithMothers';
// //       final response = await http.get(Uri.parse(url));
// //       final data = json.decode(response.body)['data'];
// //       final items = data['data'] as List<dynamic>;
// //       setState(() {
// //         _newborns = items
// //             .map((item) => Newborn.fromJson(item as Map<String, dynamic>))
// //             .toList();
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //       print('Error fetching newborns: $e');
// //     }
// //   }

// //   List<Newborn> mapNewborns(dynamic data) {
// //     return (data as List<dynamic>)
// //         .map((item) => Newborn.fromJson({
// //               'mother_name': item['motherName'],
// //               'newborn_name': item['newbornName'],
// //               'gender': item['gender'],
// //               'date_of_birth': item['dateOfBirth'],
// //               'time_of_birth': item['timeOfBirth'],
// //               'weight': item['weight'],
// //               'status': item['status'],
// //               'identity_number': item['id']
// //             }))
// //         .toList();
// //   }

// //   String mapNewbornsToString(dynamic data) {
// //     return jsonEncode(mapNewborns(data));
// //   }

// //   void _getNextPage(String url, String Function(dynamic) mapper) {
// //     if (_paginationService.hasNextPage) {
// //       setState(() {
// //         // Update the current page number in the PaginationService object
// //         _paginationService.getNextPage(url, mapper);
// //       });
// //       _fetchNewborns();
// //     }
// //   }

// //   void _getPreviousPage(String url, String Function(dynamic) mapper) {
// //     if (_paginationService.hasPrevPage) {
// //       setState(() {
// //         // Update the current page number in the PaginationService object
// //         _paginationService.getPreviousPage(url, mapper);
// //       });
// //       _fetchNewborns();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       child: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             DataTable(
// //               columns: [
// //                 // DataColumn(
// //                 //     label: Text('ID',
// //                 //         style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(
// //                     label: Text('Name',
// //                         style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(
// //                     label: Text('Gender',
// //                         style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(
// //                     label: Text('Date of Birth',
// //                         style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(
// //                     label: Text('Time of Birth',
// //                         style: TextStyle(fontWeight: FontWeight.bold))),
// //                 DataColumn(
// //                     label: Text('Weight',
// //                         style: TextStyle(fontWeight: FontWeight.bold))),
// //               ],
// //               rows: _newborns
// //                   .map(
// //                     (newborn) => DataRow(
// //                       cells: [
// // // DataCell(Text(newborn.id.toString())),
// //                         DataCell(Text(newborn.newbornName)),
// //                         DataCell(Text(newborn.gender)),
// //                         DataCell(Text(newborn.dateOfBirth)),
// //                         DataCell(Text(newborn.timeOfBirth)),
// //                         DataCell(Text(newborn.weight.toString())),
// //                       ],
// //                     ),
// //                   )
// //                   .toList(),
// //             ),
// //             SizedBox(height: 20),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 ElevatedButton(
// //                   child: Text('Prev'),
// //                   onPressed: () => this._getPreviousPage(
// //                       'http://127.0.0.1:8000/api/newbornWithMothers',
// //                       mapNewbornsToString),
// //                   style: ElevatedButton.styleFrom(
// //                     primary: AppColors.primary,
// //                     textStyle: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 10),
// //                 Text('Page $_currentPage of $_totalPages'),
// //                 SizedBox(width: 10),
// //                 ElevatedButton(
// //                   child: Text('Next'),
// //                   onPressed: () => this._getNextPage(
// //                       'http://127.0.0.1:8000/api/newbornWithMothers',
// //                       mapNewbornsToString),
// //                   style: ElevatedButton.styleFrom(
// //                     primary: AppColors.primary,
// //                     textStyle: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 20),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }










//  Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Text(
//                   'Enter information about doctor',
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 32.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Doctor Name',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           errorStyle: TextStyle(color: Colors.red),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter the doctor name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: aboutController,
//                         decoration: InputDecoration(
//                           labelText: 'About Doctor',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           errorStyle: TextStyle(color: Colors.red),
//                         ),
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         style: TextStyle(
//                           fontSize: 16,
//                           height: 1.5,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter some information about the doctor';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: salaryController,
//                         decoration: InputDecoration(
//                           labelText: 'Salary',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           errorStyle: TextStyle(color: Colors.red),
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter the salary';
//                           }
//                           if (double.tryParse(value) == null) {
//                             return 'Please enter a valid number for the salary';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: nurseNameController,
//                         decoration: InputDecoration(
//                           labelText: 'Nurse Name',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           errorStyle: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: ministryOfHealthNameController,
//                         decoration: InputDecoration(
//                           labelText: 'ministry Name',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           errorStyle: TextStyle(color: Colors.red),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter the doctor name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       child: TextFormField(
//                         controller: midwifeNameController,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: null,
//                         style: TextStyle(fontSize: 16, height: 1.5),
//                         decoration: InputDecoration(
//                           labelText: 'Midwife Name',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.red),
//                           ),
//                           errorStyle: TextStyle(color: Colors.red),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter some information about the doctor';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 Center(
//                     child: Column(
//                   children: [
//                     TextFormField(
//                       controller:
//                           _imageController, // Bind the controller to the text field
//                       decoration: InputDecoration(
//                         labelText: 'Image Path',
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: _pickImage,
//                       child: Text('Pick Image'),
//                     ),
//                   ],
//                 )),
//                 SizedBox(height: 16.0),
//                 Center(
//                   child: Text(
//                     'Schedule  of Doctor',
//                     style:
//                         TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 Center(
//                   child: SizedBox(
//                     width: 1000.0,
//                     child: Table(
//                       columnWidths: {
//                         0: FlexColumnWidth(1),
//                         1: FlexColumnWidth(2),
//                         2: FlexColumnWidth(2),
//                       },
//                       border: TableBorder.all(color: Colors.blue),
//                       children: [
//                         TableRow(
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                           ),
//                           children: [
//                             TableCell(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Day',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Start Time',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TableCell(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'End Time',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         _buildTableRow('Monday'),
//                         _buildTableRow('Tuesday'),
//                         _buildTableRow('Wednesday'),
//                         _buildTableRow('Thursday'),
//                         _buildTableRow('Friday'),
//                         _buildTableRow('Saturday'),
//                         _buildTableRow('Sunday'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SizedBox(
//           width: 200.0,
//           child: ElevatedButton(
//             child: Text('Save'),
//             onPressed: _saveDoctor,
//           ),
//         ),
//       ),
//     );
//     // add this closing parenthesis
//   }

//   TableRow _buildTableRow(String day) {
//     final startText = schedule[day]?['start'] ?? 'Not set';
//     final endText = schedule[day]?['end'] ?? 'Not set';
//     return TableRow(
//       children: [
//         TableCell(
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               day,
//               style: TextStyle(fontSize: 16.0),
//             ),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: InkWell(
//               child: Text(
//                 startText,
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               onTap: () => _selectStartTime(context, day),
//             ),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: InkWell(
//               child: Text(
//                 endText,
//                 style: TextStyle(fontSize: 16.0),
//               ),
//               onTap: () => _selectEndTime(context, day),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
