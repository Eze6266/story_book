// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:test_code/details_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getdata() async {
    http.Response response =
        await http.get(Uri.parse('https://media.abeti.xyz/api/v1/media-list'));
    print(response.statusCode);
    var data = jsonDecode(response.body);
    // print(data);
    List<User> users = [];
    for (var u in data) {
      User user = User(
          title: u['Title'],
          year: u['Year'],
          imageUrl: u['ImageUrl'],
          description: u['Description'],
          audio: u['AudioUrl']);
      users.add(user);
    }
    print(users.length);

    return users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Story Book',
          style: GoogleFonts.gabriela(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        elevation: 5,
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Container(
            child: Card(
          color: Colors.blue,
          child: FutureBuilder(
            future: getdata(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text('Loading...'),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: 100,
                          width: 80 * size.width / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green,
                          ),
                          child: Row(
                            children: [
                              Image(
                                image:
                                    NetworkImage(snapshot.data[index].imageUrl),
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        snapshot.data[index].title,
                                        style: GoogleFonts.gabriela(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Year :  ',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index].year,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        var title = snapshot.data[index].title;
                                        var img = snapshot.data[index].imageUrl;
                                        var description =
                                            snapshot.data[index].description;
                                        var audio = snapshot.data[index].audio;
                                        Navigator.of(context).push(
                                            PageAnimationTransition(
                                                page: DetailsPage(
                                                  title: title,
                                                  img: img,
                                                  description: description,
                                                  audio: audio,
                                                ),
                                                pageAnimationType:
                                                    BottomToTopTransition()));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Read more',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        )),
      ),
    );
  }
}

class User {
  String title;
  String year;
  String imageUrl;
  String description;
  String audio;
  User({
    required this.title,
    required this.year,
    required this.imageUrl,
    required this.audio,
    required this.description,
  });
}
