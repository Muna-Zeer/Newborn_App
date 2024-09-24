import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_vaccine_app/apiServer.dart';
import 'package:my_vaccine_app/screens/Feeding/feddingClass.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedingListView extends StatefulWidget {
  @override
  _FeedingListViewState createState() => _FeedingListViewState();
}

class _FeedingListViewState extends State<FeedingListView> {
  List<Feeding> feedings = [];
  int activePage = 0;
  int cardPerPage = 4;
  final PageController _pageController = PageController();
  List<String> images = [
    'assets/feed1.jpg',
    'assets/feed2.jpg',
    'assets/feed3.jpg',
    'assets/feed4.jpg',
    'assets/feed5.jpg',
  ];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final baseUrl = ApiService.getBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/feedings'));
      debugPrint("response of feeding $response");
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final feedingsData = responseData['data'];

        setState(() {
          feedings = feedingsData
              .map<Feeding>((feedingData) => Feeding.fromJson(feedingData))
              .toList();
        });
      }
    } catch (error) {
      print('$error');
    }
  }

  bool isNumeric(String? strText) {
    if (strText == null) {
      return false;
    }
    return double.tryParse(strText) != null || int.tryParse(strText) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'قائمة التغذية',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //slideShow Images
          SizedBox(height: 16.0),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayCurve: Curves.easeInOut,
              // autoPlayAnimationDuration: Duration(microseconds: 500),
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                setState(() {
                  activePage = index;
                });
              },
            ),
            items: images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    key: Key(image),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color.fromRGBO(35, 20, 120, 0.992),
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Image.asset(
                      image,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          Column(children: [
            Text('hb'),
          ]),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: (feedings.length / cardPerPage).ceil(),
              onPageChanged: (index) {
                setState(() {
                  activePage = index;
                });
              },
              itemBuilder: (context, index) {
                final startIndex = index * cardPerPage;
                final endIndex = (startIndex + cardPerPage) > feedings.length
                    ? feedings.length
                    : (startIndex + cardPerPage);
                List<Feeding> currentFeedings =
                    feedings.sublist(startIndex, endIndex);

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentFeedings.length,
                    itemBuilder: (context, index) {
                      final feeding = currentFeedings[index];
                      return Card(
                          margin: const EdgeInsets.all(16.0),
                          shadowColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'نوع الغذاء ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  '${feeding.feedingType ?? ''}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  'الكمية ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                      text:
                                          ' ${feeding.quantity?.toString() ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: isNumeric(
                                                feeding.quantity?.toString())
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    )),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  'التعليمات',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                RichText(
                                  textAlign: TextAlign.right,
                                  text: TextSpan(
                                    text: ' ${feeding.instructions ?? ''}',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: isNumeric(feeding.instructions
                                                    ?.toString() ??
                                                '')
                                            ? Colors.red
                                            : Colors.black),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/babyMilk.jpg',
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' ${feeding.feedingType ?? ' '}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 95, 203, 249),
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 24.0,
                                ),
                              ],
                            ),
                          ));
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
