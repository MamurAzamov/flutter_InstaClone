import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/services/db_service.dart';

import '../model/post_model.dart';

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {

  bool isLoading = false;
  List<Post> items = [];

  void _apiLoadLikes(){
    setState(() {
      isLoading = true;
    });
    DBService.loadLikes().then((value) => {
      _resLoadPost(value),
    });
  }

  void _resLoadPost(List<Post> posts){
    if(mounted) setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostUnLike(Post post){
    setState(() {
      isLoading = true;
      post.liked = false;
    });
    DBService.likePost(post, false).then((value) => {
      _apiLoadLikes(),
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadLikes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text("Likes", style: TextStyle(
              color: Colors.black, fontFamily: 'Billabong', fontSize: 30),),
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, index){
                  return _itemOfPost(items[index]);
                }
            ),
            isLoading ? const Center(
              child: CircularProgressIndicator(),
            ): const SizedBox.shrink()
          ],
        )
    );
  }

  Widget _itemOfPost(Post post){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: post.img_user.isEmpty ? const Image(
                          image: AssetImage("assets/images/avatarInsta.png"),
                          width: 40,
                          height: 40,
                        ): Image.network(
                          post.img_user,
                          width: 40,
                          height: 40,
                        )
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.fullname, style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),),
                          const SizedBox(height: 3,),
                          Text(post.date, style: const TextStyle(
                              fontWeight: FontWeight.normal),),
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: (){

                    },
                  )
                ],
              )
          ),
          const SizedBox(height: 8,),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            imageUrl: post.img_post,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),

          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      _apiPostUnLike(post);
                    },
                    icon: post.liked ? const Icon(
                      EvaIcons.heart,
                      color: Colors.red,
                    ): const Icon(
                      EvaIcons.heartOutline,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: (){

                    },
                    icon: const Icon(EvaIcons.messageCircleOutline),
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: const Icon(EvaIcons.paperPlane,),
                  )
                ],
              )
            ],
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: RichText(
                softWrap: true,
                overflow: TextOverflow.visible,
                text: TextSpan(
                    text: "${post.caption}",
                    style: const TextStyle(color: Colors.black)
                )
            ),
          )
        ],
      ),
    );
  }
}
