
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:newborn_app/methods/AuthService_api.dart';
// import 'package:newborn_app/screens/login.dart';
// import 'package:newborn_app/screens/register.dart';
// import '../methods/doctor_api.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.withOpacity(.1),
//       appBar: AppBar(
//         title: Text("Practo",
//             style: TextStyle(color: Colors.indigo, fontSize: 50)),
//         backgroundColor: Colors.white,
//         leading: Icon(
//           Icons.local_hospital_rounded,
//           color: Colors.indigo,
//           size: 40,
//         ),
//         actions: [
//           Icon(
//             Icons.email_outlined,
//             color: Colors.indigo,
//             size: 30,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("mail", style: TextStyle(color: Colors.black)),
//               Text("info@gmail.com", style: TextStyle(color: Colors.black)),
//             ],
//           ),
//           SizedBox(
//             width: 7,
//           ),
//           Icon(
//             Icons.call,
//             color: Colors.indigo,
//             size: 30,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("call", style: TextStyle(color: Colors.black)),
//               Text("+01227120519", style: TextStyle(color: Colors.black)),
//             ],
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 200,
//               decoration: BoxDecoration(
//                   color: Colors.indigo,
//                   borderRadius: BorderRadius.circular(50)),
//               child: Center(
//                 child: Text(
//                   "Make appointment",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 7,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Container(
//               width: 35,
//               height: 50,
//               decoration: BoxDecoration(
//                   color: Colors.blue, borderRadius: BorderRadius.circular(100)),
//               child: Center(
//                 child: Icon(
//                   Icons.search,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height - 92,
//             child: ListView(
//               padding: const EdgeInsets.all(8),
//               scrollDirection: Axis.vertical,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text("Home",
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text("Department of childbirth+",
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text("’Mothers+",
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text("Blog+",
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text("Pages+",
//                                 style: TextStyle(color: Colors.black)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => SignUpView()),
//                                 );
//                               },
//                               child: Text('Register'),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => LoginView()),
//                                 );
//                               },
//                               child: Text('Login'),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () async {
//                                 // Log out user and navigate to home screen
//                                 AuthService authService = AuthService();
//                                 await authService.logout();
//                                 Navigator.of(context).pushNamedAndRemoveUntil(
//                                     '/HomeScreen',
//                                     (Route<dynamic> route) => false);
//                               },
//                               child: Text(
//                                 'Logout',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.access_time_outlined,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.add_location_alt_rounded,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.alternate_email_rounded,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Icon(
//                               Icons.menu,
//                               color: Colors.black,
//                               size: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 350, // Increased height
//                   decoration: BoxDecoration(
//                     color: Colors.indigo.withOpacity(.5),
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: const AssetImage("lib/assets/images/doctor1.png"),
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: 350, // Increased height
//                         color: Colors.black.withOpacity(.3),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 50,
//                             left: 50,
//                             bottom: 25), // Increased top padding
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Welcome to our Hospital!",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 25),
//                             ),
//                             Text(
//                               "Experience Safe and Comfortable Delivery",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 40),
//                             ),
//                             Text(
//                               "Our expert doctors and nurses are dedicated to providing the best care for you and your newborn. Trust us to make your delivery experience a memorable one!",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 17),
//                             ),
//                             Container(
//                               width: 150,
//                               height: 35,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.white),
//                               child: Center(
//                                 child: Text(
//                                   "Book Now",
//                                   style: TextStyle(color: Colors.indigo),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "----- Our Team Doctors -----".toString(),
//                       style: TextStyle(color: Colors.indigo, fontSize: 15),
//                     ),
//                     Text(
//                       "Our Dedicated Doctors".toString(),
//                       style: TextStyle(color: Colors.black, fontSize: 40),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Center(
//                   child: Container(
//                     width: 1200,
//                     height: 800,
//                     child: FutureBuilder(
//                       future:
//                           fetchDoctors(), // call fetchDoctors function to retrieve data
//                       builder: (BuildContext context, AsyncSnapshot snapshot) {
//                         if (snapshot.hasData) {
//                           return Center(
//                               child: GridView.builder(
//                             itemCount: snapshot.data.length,
//                             scrollDirection: Axis.horizontal,
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               crossAxisSpacing: 10.0,
//                               mainAxisSpacing: 30.0,
//                             ),
//                             itemBuilder: (BuildContext context, int index) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       spreadRadius: 2,
//                                       blurRadius: 5,
//                                       offset: Offset(
//                                           0, 3), // changes position of shadow
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         width: double.infinity,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           child: Image.asset(
//                                             snapshot.data[index]['img'] ??
//                                                 'lib/assets/images/doctor1.png', // use a placeholder image asset if img URL is not available
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Text(
//                                         "Dr. " + snapshot.data[index]['name'] ??
//                                             '',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Text(
//                                         snapshot.data[index]
//                                                 ['specialization'] ??
//                                             '',
//                                         style: TextStyle(
//                                           color: Colors.black.withOpacity(.5),
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.email,
//                                             size: 16,
//                                             color: Colors.black.withOpacity(.5),
//                                           ),
//                                           SizedBox(width: 5),
//                                           Text(
//                                             snapshot.data[index]['email'] ??
//                                                 'N/A',
//                                             style: TextStyle(
//                                               color:
//                                                   Colors.black.withOpacity(.5),
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.phone,
//                                             size: 16,
//                                             color: Colors.black.withOpacity(.5),
//                                           ),
//                                           SizedBox(width: 5),
//                                           Text(
//                                             snapshot.data[index]['phone'] ?? '',
//                                             style: TextStyle(
//                                               color:
//                                                   Colors.black.withOpacity(.5),
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ));
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 400,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: NetworkImage(
//                                 "https://img.freepik.com/free-photo/happy-medical-team-using-laptop-together_13339-250352.jpg?size=626&ext=jpg&ga=GA1.2.145604237.1604566061"))),
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 400,
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(.4),
//                           ),
//                         ),
//                         Positioned(
//                           right: 20,
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 25, bottom: 25, left: 50),
//                             child: Container(
//                               width: 400,
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 textDirection: TextDirection.rtl,
//                                 children: [
//                                   Text(
//                                     "We Believe in a Healthier you",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 40),
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Text(
//                                     "The American Hospital Directory® provides data, statistics, and analytics about more than 7,000 hospitals nationwide. AHD.com® hospital information includes both public and private sources such as Medicare claims data, hospital cost reports, and commercial licensors.\n \n AHD® is not affiliated with the American Hospital Association (AHA) and is not a source for AHA Data.  Our data are evidence-based and derived from the most definitive sources. ",
//                                     style: TextStyle(
//                                         color: Colors.white.withOpacity(.8),
//                                         fontSize: 15),
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         width: 200,
//                                         height: 40,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                             color:
//                                                 Colors.white.withOpacity(.8)),
//                                         child: Center(
//                                             child: Text(
//                                           "Get a Consultant",
//                                           style: TextStyle(
//                                               color:
//                                                   Colors.black.withOpacity(.8)),
//                                         )),
//                                       ),
//                                       SizedBox(
//                                         width: 20,
//                                       ),
//                                       Icon(
//                                         Icons.play_circle_fill_rounded,
//                                         color: Colors.white.withOpacity(.8),
//                                         size: 50,
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "----- Experience -----".toString(),
//                       style: TextStyle(color: Colors.indigo, fontSize: 15),
//                     ),
//                     Text(
//                       "What our users say about their online\n            consultation experience"
//                           .toString(),
//                       style: TextStyle(color: Colors.black, fontSize: 40),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 50, right: 50),
//                   child: Container(
//                     height: 200,
//                     color: Colors.transparent,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 11,
//                       itemBuilder: (context, i) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: (Container(
//                             width: 400,
//                             decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(.7),
//                                 borderRadius: BorderRadius.circular(20)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: 50,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(50),
//                                           image: DecorationImage(
//                                               image: NetworkImage(
//                                                   "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBw8QEBUQDxIPEA8QDxAPEBUPEBUPFRAWFRUXFhUVFRYYHSggGBolHRUVITEhJikrLi4uGB8zODMsNygtLisBCgoKDg0OGhAQGzElHSYtLS03Ky81LS83LyswLS0tLS0tLTAtLy8tLS0vLS8tKzUtLy0wLS0tLS0tLS0tLS0tLf/AABEIANoA5wMBIgACEQEDEQH/xAAcAAACAwEBAQEAAAAAAAAAAAAAAwECBAYFBwj/xAA/EAACAgECAwUFBgQEBQUAAAABAgADERIhBDFBBRMiUWEGMnGBkRRCUqGxwSNygpIzYtHhByRDsvBTVGNzov/EABkBAQADAQEAAAAAAAAAAAAAAAABAwQCBf/EAC8RAQACAgAEAwYFBQAAAAAAAAABAgMRBBIhMUFR8CJxgZGxwRMUQqHRBSMyYeH/2gAMAwEAAhEDEQA/APuMIQgEIQgEIQgEjMJBMCZGZUmQWgWzDMWWlS0BuYaokvDXAdqhmJ1yQ0B2YZig0kNAbmTmLDSwMC0mVBkwJhCEAhCEAhCEAhCEAhCEAhCRAJBMCZQmBJMqWlGaLZ4DC0oXimslC8gOLypeILypsgP1w1zP3kNUDRrkh5nzJBjY0B5YPMwaWDQNQaXDzKGjFaBpDSwMQrRimSGwlQZYQJhIkwCEIQCEIQCEJBgEgmBMoTAGMWzQZolmgDNFM8h3iWaQLO8prii+SfmJ5vb/AGmeF4Wy5ffGlK/R3OA3yGT8QJAt2n29RTkFtTgkaUwST1GTsMdTOav9ouJtOQ3dLjknPHqx3PyxOW7w7Akk+ZOZ6/ZaBsD0Ofl1lWTJqOjVhw7nq9mvi+IG4ts+Zz+s2U9s3qctiwZGVOFJ/lPIGIqpAB5ctv2l7eFwvT9JmjNaGm2DHLo+C4tLkFlZypLLvsVZTurDowmgGcz2FZov0jOm9CGGdtaDKN/NjI9ROjE2UtzRt5+SnJaar5lgYrMkGdODg0YGmcGMUwNKtGK0zK0YrSRpVpcGIVoxTJDhJlAZYQJhCEAhCEAkQkEwKkxTNLsYhzAq7RLNJdpndpAlmiyZDNKEyBXG05n/AIiavsleB4ftaF/TwnT+eZ085/28KfYWVnVXa2k0qxx3ro2Si/0kmIHAkbz2eyS5wUG3U9DjbE8O/IJB+nnnkP0/OaOyER3UMljkFlNutkFRAz4UTcrnC59fKUXpuG6mTXZ21Ssfd6kZyeWfPEtxPEohKDvLbMZITCovoztsJ4PYPar/AGhqbcNVyrLMCQwHiUsNmwdpoq4SwcQWdrShDgAEBXzjBPiGNO+Om+4mfliJ1K+ZmY3D0uEcqy2aWUoQzKxGUwRqDEHGytn4YnVjHQgjmCDkEdCPSctwA7sAgZGNHIHUPPoMzoeza9NKKceFSu3LAY4x6YxL8Nv0svE0/VPu+p4hJAgZoZAJcGUEmA1TGKYlTLgwHq0arTMpjVMkaVMYIhTGKZIZJlRLQCEIQIMoxljFuYC3MQ7S7mIcyAtzEuZdzFMZAox/WQJJ5yAYAJzXt/wLWUVXLnTwtlrW4GSKrKyrMB6HT8jOmWFiKwZWGVdWRhnmrAqw+hMju6rblnb45wlhsqrc4OUUDB1AAZwM9cCen2fwItGEzWd9TZOMdWx5ARvafs9ZwWQQhoe0it6yBrYgt4k+4xC79CeXOM7LsOhkXGrUMg7ZTSTz/m0/SU5N6bMMxEsPZ9taXqx/hqXZFVkYtjOAzsBpBPP5ids2+RVgggNWLdIV/NSRuud8Nyzj1nJcC9iXFawurOA7v72dsqoGw6TqOHpuKYDVKgACgV6sHpuekqvEd19bTppssravKa1Uhgyts1bjZh6Ef6T2+Bp7upK/wVqu/wCWfXE8BlwH/ExycdToCA/En9J02MbeQA+gneDvMs3FT0gYhCTNLGiEJMCRLAyglhAYpjFMUJZTA0qY1TMyGPQyQ4GWEoplxJEwhCBQxTxjRLmAiwxDtG2RDyAtjFEy7RZkCJKiRLCACTBQTyBPwGZj7T7V4bhRniLq6jjOknU5+CLkyYiZ7ImYjuy+2FGvgbsc6u74gbZ/w2GfqCZ84p4kq2pDhgCBnkQehnte1XtM3F0WV8OjJVVZw/EamYa+KrVwHAUe5pJBKk55Tmw2oZ6HcEfH/wAHynNo13X496etwvEk4xsx6k9fIzqeAdiMd4MFQQMZz6Z6Th+HtYMPU4BG+f2zOm4OnUSGyNIGrP5KBymXJWIlrpaZh03ZlYsszsUp0k9dT76R6gbn6T2p4fYnEojik5V7lZ6hjwlaveGeQbxA4PMZnvYl+KI5OjJnmedAEJMjEsUoxCWAhiBWAkmQIFxLAygloDkMchmZTHoZI0KYwRSRgki8JEIC2iHjmiXgZ3iHj3mdpzIWYt5cyjwE8RxCVI1th011oXc4zgDyHU9APMziOO9qeKu/w2PCpklVTOogci9wz4vMadI9ec3+3vG+GvhgfeP2i0eaglagf6gzf0icxwn/AJ9Zt4fFGuaWTPkneoba+1+Js/h28RfhiFVjayLqb3a7wpwob7tqnS3LY7HLorXxV0nvVfBFj63Vl3ZQMAFh5HORvNopDDGFOVK4YbFW95W8wf8ATymfikwO8OrFYAvz75oGwsJ/9WkkHVzZATvNkRFe7NMzKOz+G+08QoDZNyXU6fdBLqSPhgqNvSefX2dYjtqDBAxLkeEggYNiA88EYYY3G/3d+m7L4fu+IptYgPTxCmzAGHG6n4ZyDmY+Ouau5xZprBvsdD9zdicb+6d5TmwVy2nfkvw8RbFXp5tnZHZQLeMJrG4OgjP54/Oe1RwAVjuMn/LjI+m4nldkWt4FrRmV2KU7ELqA1GpWOA2wLLjoGU+6M9L9jvxqam0EbkeFsfAA7/KeFxHD5Mc9evrye1g4mmWOnT14S8btO3QEsAyUNr/2jfUPwkEqfRs9I8drXUuakIZEICixdQClFdRnZs4bzme7DXEHw6aShDDSQbm8j6IZm7VcBeHfGO9WnQR10ko4+hXHoG8p6XA0j8KvNHff/Pu87jbf3ba8Nevo9uv2oXIV6WLYLHu7NsDmQGH79Yxfa3g9tZvr1MqLqpLaixwACmZzNo/5lR+GmwH+og/tMPHJiypB926tzv0DDE1zwuOWSOIvD6hW6soZSGUgYKnIOZM4bsTinruZl91b3rKDI1I+p8fLBI8ifIzt6rFdQyEMrDII6/79MTFmwzjn/TViyxeEmVIjMSpEpWgSRKywgXWOSJWOSTAekcIlI1ZIvCEICmiHj2iHgZ3iGj3iGnMhRi7IwxVv7GB879r7dXH3DpWtNI/prUn/APTNPO4YEjUh8aliw5+EnqOo5zR7RE/b+KJ/9zZ+2PyxPPGtG11/d3OOgJxy6j/eepj6Vj3POv1mXtcJaGOANL4zoJ94eaH7w/MTexXTr06tGcqdy6YxZWw9VLD5zzOGuruGQuQMGysbPU346yN9PqOU9SksMNnvPwsOdwXcow5d6ACQfvYI6y/UTCvavAVYrZCdT8OTw+on3gmGpsPxQ1mdX2fwnD8QUvWirXdSlxaxNeG906VbYEH09es5PhkA4hlBzXbwvD3AjkwRnr5/yd0J0nsPxptoZuZ4fjOLpcD8BfWg/tdD8plz75Yn4evk0Yesz8/Xze9xHDCyvRblgWBDDch18SsgHu4IBB55Ev2ZxjWJ4iO8Tw2ADw5H3weinmB8R0j+KqBww1KwI3Xwtj9CPQzyO1uJTh/+YUkvUCXUgLrpyNfMgErnWPgR1mJqe27Bhh1RgcYDYOfLYicr7X9maUpvQBRweoIlYwi6sBSB1AxjHkxnT8HdXYosR1sQ5wy4wcHBx65BEpxdYsV0IARk0At4QSeW/wAcScdtTEovXcTD53TXm4uu692N/PO4I+Rmfj6s3045lydvJeuJu7Op7sPU2daMCR1VX3Vfgp1L8AvnI4ZNfElulQFS/wAx3P7T1K231efMKcFV/EsPQXMw3znKY/I5+s9v2ZuPfXpnwBOGfH/yENrx/QKyflOep4tVTVvix2VSBuQpIOkfiYghR6iet2eXpw23e6mts0nIZnwGQeahQqA/5QZxmrzVmHeK0RMS6yQYVurKGXdWAZT6GBnkvRVlllZZYF1jkiljVkh6RqxSRqyReEIQFtEPNDRLwMriIeaXEzuJzISYqwRzRNkD5v7V0lOO4gn/AKhS9f5XVcfQhh8p5OplOV89vlufljM63/iBw/8AhXAbaHodvUMHrB+tmPnOXV1UhmKqoRyxdgqgaCMkn1IE9LFbdYlgyV1aYaeGSuwhgTTcPdZDjB/ceh2nvcKjNhW0rZYdJZSErDAZrt3PhOoDHrtOf4K3OMbgjm3h+e+5HynvpRqrKMVww5ruVIIZWXIxkFQcHniRfiscRrmjfr4LMfC5JmLTWdeviOMBqBfIVVD5Hkl2GKqR5WIdv82JHYvEtSl1CO1NvFP9oArOl1NaKMAnzVN+vOes1Q4yss3+IDoLBcIt1ZHTqG2IPmceU8lez3UrxFnhZbXFa82tfSVZyfu1qGO3MnHIc+cPE1y15bR7UeH3/l1n4acNt1/xnx+38NVd3EKfBxfFhueTd3q/22BhJ47tPiAhW26q4WDSqW8HXY1u42CrjIyB6RCuQMAfp+8tRXglj77DDMTqcjy1dB6DaaeSvjEM3NbwlbsnjuLre2t3FRt08ZpoRVXNn8KwZOrSQUQkL1fOZPGcKt1lRdSzvxFK6ndnYeIctROJn7VuWkVcT92iw13EDJFHEYRz8FcVufgZ6FZC2r94pqvLA6hhdlII23YjHzlddV3ER1dTudbYvaXiOJHHW28KnD2K5SotcWVVRUw3jXdXDgdCCDuDiauyiFVUOFuUJZdXr70jvGIWwOAA6MVOCBtyIEi0ZGM7YP585k7RcolfE173cNnCk47+mwAWUk9NwjjyYZkTWaRuPimJi09WfsACxtZ3WjNdXlqOz2Y9B4R/VPbzuB9ZyvsdfgORl6hVUmRjx2ZZmI89m3+M6Si5WyQTufvAjHpvyl9o6q6vf7BuyrVHmjal/lY7/Rv+6eiZz3AWFLA/QDDeqnY/r+U6JhPM4iur7827DbddIEsolRLCULTBGpFrGoJIcsaIpBGiSLQhCBVolxHmLYQMriIcTU4mdxIGZhFWCaHEz2iQPF9rqtXA3/5Frv8Aj3Thj+WZ8zbDXU1MQQBfYV/G6gd1nzxhyB1Kg+U+w3Ud4j18u9qsr+GpSBPz/wATbZW/8cPVcCGzjIypwGRuRG20vpO8c1VTGskWdVY5znfP13nq8HxO2P3/AFnjcPxQvqW0YySdenkHHvfI5B+c38EdiR8W+HUzz8kPVxW29zhatW4d1yMOVYjORjccuXWOPZYI3ZyRy8ZyOWSM9dh9Izs4A1hsb+nLE1LXjf11b9TM8WmOsSvtWJ6TDy7uFsX3HOOWLAH/AE39JmYXDmAR5of1BnuOmck74+WdwQfgPzk2UIcgnJzvuCd+e81047NTx37/AFtkvwWG3hr3etOY7UYtRbWVtbvKWTSaychseR3IALAZGcDzni0dq8Bw4RabuI7x++e91d6fsyVqNK21sniY7nABAzjpmd2/Z6779Djric7b7JL9sPFI51iwMA/jTOANJXG67Z+ct/PTed3iFFuAisexM/GWrslO02NneVA1han4VuMtppsu7w4VHejUgJJXAwCc9Yu7tQNTYNCHTVbr03tQa8Ao2TcgAAOrzzjbnMva/s7cEROGutqIsLs4dtSkEsCFBCs2ojpt05Tf2Z2fxelPtVh4he5AY2lHLOlgsQirQMBSWbck5PXbHUcbaK725ngYm2tPA9mu0nKsjIFTX3g3AIawB32GdixLYOCNWJ23Z/DMVyBpU/i5n1Anmdr8MgZOK8IdWVLCedqscDJ6lWwRn1m6vtlFGAdbZxhDkkyLf1G34cVpHXzd1/p1eebWnp5evs3vTjOGK8twqnT5kKdp0qrhQM6sKBqwBqwOe05em4sCWwNtwDnHPBzOl4N9VSHzQf6SnFlvffNO3WfDWmuWNLgRglQIwLLmdZRHIItBHKJIYsYJVRLiSJhCECplGEYZUiAhxEOs1MIlxIGRxM9omx1ma0QEjbccxv8ASfMva/hRVxFtSZ0d6bFB3A1gMR+Zn04icN7bcNjidXSymuz5rlG/7AZo4afb0ozx7O3LLaBb3ZwFsC42CgOBty28QyPkJs4K8o/LqQevy3nicYpdwOecD4bRp4+xWOVWxQx0k5VwM7eIc/mDI4jBN55qruF4iKRFbO57OHde5/h/h56c9B5Cb24tT6Aef7ThOB9rdyrU2pjO4ZbA2PQYPKb6O36QAzNWqsMguSoOCep67cp5lsF4js9OM+O09JdX9ozy+fXnvtK4Y7DkQM78uu08jh+1FKhgysrDKsniUj0Ikn2h4deIXhtbNxTsqLUtbk5bBGpsaV28RyeUrmlvJ3z183rd05znG/5/H0leItrqH8SwKMDmQCTyG3Xlyk3UOw8djVg744cdP/sIz9AInhaOFTxIniyVZnyWUn8RbfH+s506283tHjuIbw8NVkci97Gpd/woBqY8/IfGN4F703LLqJwT3bOB6AEgCekbqf1GCdyB6j5/SSGrAIBAY7k5x5c8dR5SZ8jbPT2ejNqfVazEEmw6sdfCuwUfAbes3V0IoIOCMD4f7RY4lFyeW24HM77bRlLBts5zzPIH0kCy4x4eXIbY+I9f9p7/AGP/AIC+jOPoZ5dSADJwAMnn9fjPX7LTFK9NWp/qdpfgjqy8TPs/FrWMAlUEYomqGJZBHKJRRGqJIsJaQJaSCEIQCVMtIMChEUyx5EowgZXWZrVm5liLEkDEyzh/bo5uZce7wK4PkcsxHzDT6A1c8PtX2eS+xrGdlL1rXgKCAFGOvnLMVorbcq8lZmOj5TVRiwbe8P8At6n6Yl+0qNKKo9+w+H08z8t5349iKgc99Z/Yvr/rLWex1RsFhts8KBFXQuF8z8TNUZ8eu6icV9vmVvZ5Vcr7y7j5T2eyaXFYsoexDZlvA2ASRsSORbpnGdp2Tex1e/8AFs3P4FluzvZKuhCgtsZe8Z11Io06t9Ix0zk/OTGbFEn4eTTieE7EsQ6qLrqGsyWaojBbqShGnJ88SOyvZfiaLReOJWy4FyWtRrNRYaS27bNpyMjzM+hjsJBydv7RLDsVfxt/aJzN+HnvH1TEZ48XP0HjVH/QsP8AkZq/yYEfnLfb7BvZU6Y9/wAGsEfFC23xnQjslfxt9BLDssfjb6DaZr4eGnt0+bTTiOIr31LnO84ZyNkGtcAMe6bzBAPMdMiQ3DV6R4XDZByMkEA+XwnRP2NWwZXOtXYMy2KHXUBjUFbIU4J3GMzO/sxwx5Lp/k1KPoGxKJ4anhf9miOLv40/d49TISVrrd354rU2MOmTjfHTJm7hex+LOy1FFzn+K6V+nLJP5T0Oy+wU4e4XVswIQoVwMMCMbn6H5T3RafKROCkdp2fmrz4aeFR2RxWrDrVp8xdqA9SMA/KdElWlQo5KoHxxIWw+QjA2ek6rSI7K75LW7oRY5VlUEconThKiXAkASwkiRJhCAQhCAQhCBEqRLyDAWRFMseRKlYGVlimWa2WLZZAyMsoVmopFlJGhnKypWaCsqVgIxDEbohogKxDEbpkhICgJYLGBZYJAoFl1WXCRipJ0KKsaiyypGKsCFWNUQAlgJIAJMMSYBCEIBCEIBCEIBCEIESCJYyDAoVlCsaZUwElZQpHmUMgIKSpSPMqYCNENEcYQE6JOiNMgQKBJYJLiWECoSMCyRLCABZYCEtJABJhJgEIQgEIQgEIQgf/Z"),
//                                               fit: BoxFit.cover),
//                                         ),
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Magdi Yacoub",
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             "86 year old  Professional",
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                         "His honours and awards include the Bradshaw Lecture from the Royal College of Physicians in 1988, a knighthood in the 1992 New Year Honours, the Texas Heart Institute's Ray C. Fish Award for Scientific Achievement in Cardiovascular Disease in 1998, the International Society for Heart and Lung Transplantation Lifetime Achievement Award in 2004 ",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12)),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 150,
//                   color: Colors.white.withOpacity(.7),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.network(
//                         "https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg?size=338&ext=jpg&ga=GA1.2.145604237.1604566061",
//                         width: 50,
//                         height: 70,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("60+",
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: Colors.indigo,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 25)),
//                           Text("Export Doctor",
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: 17)),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(35),
//                         child: VerticalDivider(
//                           color: Colors.black.withOpacity(.2),
//                           width: 2,
//                         ),
//                       ),
//                       Image.network(
//                         "https://img.freepik.com/free-vector/group-young-people-posing-photo_52683-18824.jpg?size=338&ext=jpg&ga=GA1.2.145604237.1604566061",
//                         width: 50,
//                         height: 70,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("1000+",
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: Colors.indigo,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 25)),
//                           Text("Happy  Patient",
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: 17)),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(35),
//                         child: VerticalDivider(
//                           color: Colors.black.withOpacity(.2),
//                           width: 2,
//                         ),
//                       ),
//                       Image.network(
//                         "https://img.freepik.com/free-vector/winner-s-medal-gold-reward-medal-game-ui-premium_182268-19.jpg?size=338&ext=jpg&ga=GA1.2.145604237.1604566061",
//                         width: 50,
//                         height: 70,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "150+",
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: Colors.indigo,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 25),
//                           ),
//                           Text(
//                             "Award Winner",
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(fontSize: 17),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(35),
//                         child: VerticalDivider(
//                           color: Colors.black.withOpacity(.2),
//                           width: 2,
//                         ),
//                       ),
//                       Container(
//                         width: 150,
//                         height: 45,
//                         decoration: BoxDecoration(
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Center(
//                           child: Text(
//                             "Book Now",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                     child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   color: Colors.blueGrey[900],
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 100, right: 50),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 300,
//                               height: 350,
//                               decoration: BoxDecoration(
//                                   color: Colors.indigo.withOpacity(.7),
//                                   borderRadius: BorderRadius.circular(5)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(25),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Practo",
//                                         style: TextStyle(
//                                             fontSize: 35, color: Colors.white)),
//                                     Text(
//                                         "We are dreamers, thinkers and do-ers rolled into one.Together, we want to improve the healthcare experience for all humanity. We are guided by our values and driven by our motto to do great. These are not just principles for our products or our company, but they are a reflection of who we are as people.",
//                                         style: TextStyle(
//                                             color:
//                                                 Colors.white.withOpacity(.7))),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 30,
//                                           height: 30,
//                                           decoration: BoxDecoration(
//                                               color: Colors.blue,
//                                               borderRadius:
//                                                   BorderRadius.circular(5)),
//                                           child: Center(
//                                             child: Icon(
//                                               Icons.call,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Text("01227120519",
//                                             style: TextStyle(
//                                                 color: Colors.white
//                                                     .withOpacity(.7)))
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 30,
//                                           height: 30,
//                                           decoration: BoxDecoration(
//                                               color: Colors.blue,
//                                               borderRadius:
//                                                   BorderRadius.circular(5)),
//                                           child: Center(
//                                             child: Icon(
//                                               Icons.mail_outline,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Text("abanoubsam1999@gmail.com",
//                                             style: TextStyle(
//                                                 color: Colors.white
//                                                     .withOpacity(.7)))
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 50),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Quick Link\n",
//                                       style: TextStyle(
//                                           color: Colors.blue, fontSize: 20)),
//                                   Text(
//                                     "- About us\n\n"
//                                     "- Our Message\n\n"
//                                     "- Our Seniors\n\n"
//                                     "- Biog & News\n\n"
//                                     "- Contacts\n\n"
//                                     "- fag",
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.white.withOpacity(.7)),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 50),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Our Services\n",
//                                       style: TextStyle(
//                                           fontSize: 20, color: Colors.blue)),
//                                   Text(
//                                     "- Pediatrics\n\n"
//                                     "- Dermatology\n\n"
//                                     "- Cardiology\n\n"
//                                     "- Psychological\n\n"
//                                     "- Surgery\n\n"
//                                     "- Family Medicine\n\n",
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         color: Colors.white.withOpacity(.7)),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 50),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     width: 200,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.blue,
//                                         width: 2,
//                                         style: BorderStyle.solid,
//                                       ),
//                                     ),
//                                     child: OutlinedButton(
//                                       style: ButtonStyle(
//                                         overlayColor: MaterialStateProperty
//                                             .resolveWith<Color>(
//                                           (Set<MaterialState> states) {
//                                             if (states.contains(
//                                                 MaterialState.pressed)) {
//                                               return Colors.blue
//                                                   .withOpacity(0.5);
//                                             }
//                                             return Colors.blue
//                                                     .withOpacity(0.5) ??
//                                                 Colors.grey;
//                                           },
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "Find A Doctor",
//                                         style: TextStyle(
//                                             fontSize: 20, color: Colors.blue),
//                                       ),
//                                       onPressed: null,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Container(
//                                     width: 200,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.blue,
//                                         width: 2,
//                                         style: BorderStyle.solid,
//                                       ),
//                                     ),
//                                     child: OutlinedButton(
//                                       style: ButtonStyle(
//                                         overlayColor: MaterialStateProperty
//                                             .resolveWith<Color>(
//                                           (Set<MaterialState> states) {
//                                             if (states.contains(
//                                                 MaterialState.pressed)) {
//                                               return Colors.blue
//                                                   .withOpacity(0.5);
//                                             }
//                                             return Colors.blue
//                                                     .withOpacity(0.5) ??
//                                                 Colors.grey;
//                                           },
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "Career",
//                                         style: TextStyle(
//                                             fontSize: 20, color: Colors.blue),
//                                       ),
//                                       onPressed: null,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Container(
//                                     width: 200,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.blue,
//                                         width: 2,
//                                         style: BorderStyle.solid,
//                                       ),
//                                     ),
//                                     child: OutlinedButton(
//                                       style: ButtonStyle(
//                                         overlayColor: MaterialStateProperty
//                                             .resolveWith<Color>(
//                                           (Set<MaterialState> states) {
//                                             if (states.contains(
//                                                 MaterialState.pressed)) {
//                                               return Colors.blue
//                                                   .withOpacity(0.5);
//                                             }
//                                             return Colors.blue
//                                                     .withOpacity(0.5) ??
//                                                 Colors.grey;
//                                           },
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "Newsletter",
//                                         style: TextStyle(
//                                             fontSize: 20, color: Colors.blue),
//                                       ),
//                                       onPressed: null,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           textDirection: TextDirection.rtl,
//                           children: [
//                             Icon(
//                               Icons.tag_faces,
//                               color: Colors.white.withOpacity(.7),
//                               size: 20,
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Icon(
//                               Icons.add_location_alt_outlined,
//                               color: Colors.white.withOpacity(.7),
//                               size: 20,
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Icon(
//                               Icons.alarm,
//                               color: Colors.white.withOpacity(.7),
//                               size: 20,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Divider(
//                           color: Colors.white.withOpacity(.6),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "@2021 at Abanoub Samy",
//                               style: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.white.withOpacity(.7)),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
