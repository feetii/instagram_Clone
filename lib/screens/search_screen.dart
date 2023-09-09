import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScren extends StatefulWidget {
  const SearchScren({super.key});

  @override
  State<SearchScren> createState() => _SearchScrenState();
}

class _SearchScrenState extends State<SearchScren> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: InputDecoration(labelText: ' Search for a User'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers =true;
              });
            },
            /*onTapOutside: (PointerDownEvent event) {
              setState(() {
                isShowUsers = false;
              });
            },*/
          ),
        ),
        body: isShowUsers ? FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: searchController.text)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Afficher un indicateur de progression circulaire pendant la connexion
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Afficher un indicateur de progression circulaire pendant la connexion
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: (snapshot.data! as dynamic).docs[index]['uid'],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photoUrl'] ?? ''),
                      radius: 16,
                    ),
                    title:
                        Text((snapshot.data! as dynamic).docs[index]['username'] ?? ''),
                  ),
                );
              },
            );
          },
        ):FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Afficher un indicateur de progression circulaire pendant la connexion
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return MasonryGridView.count(
              crossAxisCount:3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => Image.network(
                (snapshot.data! as dynamic).docs[index]['postUrl'],
                fit: BoxFit.cover,
              ),

              shrinkWrap: false,
              mainAxisSpacing: 7.0,
              crossAxisSpacing: 7.0,
            );
          },
        ),

    );
  }
}
