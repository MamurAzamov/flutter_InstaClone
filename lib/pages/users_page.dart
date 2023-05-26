import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../model/member_model.dart';
import '../model/post_model.dart';
import '../services/db_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  static const String id = 'user_page';


  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLoading = false;
  int axisCount = 2;
  List<Post> items = [];
  String fullname = "", email = "", img_url = "";
  int count_posts = 0, count_followers = 0, count_following = 0;

  void _apiLoadMember() {
    setState(() {
      isLoading = true;
    });
    DBService.loadMember().then((value) => {
      _showMemberInfo(value),

    });
  }

  void _showMemberInfo(Member member) {
    setState(() {
      isLoading = false;
      fullname = member.fullname;
      email = member.email;
      img_url = member.img_url;
      count_following = member.following_count;
      count_followers = member.followers_count;
    });
  }
  _apiLoadPosts() {
    DBService.loadPosts().then((value) => {
      _resLoadPosts(value),
    });
  }

  _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_posts = posts.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadMember();
    _apiLoadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.chevron_left,color: Colors.black,size: 30,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "User",
            style: TextStyle(
                color: Colors.black,fontWeight: FontWeight.w400, fontFamily: "Billabong", fontSize: 30),
          ),

        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromRGBO(193, 53, 132, 1),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: img_url == null || img_url.isEmpty
                                  ? const Image(
                                image: AssetImage(
                                    'assets/images/avatarInsta.png' ),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                img_url,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        ],
                      )),
                  const SizedBox(height: 10,),
                  Text(
                    fullname.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3,),
                  Text(
                    email,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),

                  //#mycounts
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  count_posts.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3,),
                                const Text(
                                  "POSTS",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  count_followers.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3,),
                                const Text(
                                  "FOLLOWERS",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  count_following.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3,),
                                const Text(
                                  "FOLLOWING",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                axisCount = 1;
                              });
                            },
                            icon: const Icon(Icons.list_alt),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                axisCount = 2;
                              });
                            },
                            icon: const Icon(Icons.grid_view),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: axisCount),
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return _itemOfPost(items[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _itemOfPost(Post post) {
    return GestureDetector(
        onLongPress: (){
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: post.img_post,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 3,),
              Text(
                post.caption,
                style: TextStyle(color: Colors.black87.withOpacity(0.7)),
                maxLines: 2,
              )
            ],
          ),
        )
    );
  }
}