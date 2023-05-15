import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/services/db_service.dart';

import '../model/post_model.dart';

class MyFeedPage extends StatefulWidget {
  final PageController? pageController;
  const MyFeedPage({Key? key, this.pageController}) : super(key: key);

  @override
  State<MyFeedPage> createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  List<Post> items = [];

  _apiLoadFeeds(){
    setState(() {
      isLoading = true;
    });
    DBService.loadFeeds().then((value) => {
      _resLoadFeeds(value),
    });
  }

  _resLoadFeeds(List<Post> posts){
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DBService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadFeeds();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Instagram", style: TextStyle(
            color: Colors.black, fontFamily: 'Billabong', fontSize: 30),),
        actions: [
          IconButton(
            onPressed: (){
              widget.pageController!.animateToPage(
                  2, duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            },
            icon: const Icon(Icons.camera_alt),
            color: const Color.fromRGBO(245, 96, 64, 1),
          )
        ],
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
                        fit: BoxFit.cover,
                      ): Image.network(
                        post.img_user,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
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
                      if(!post.liked){
                        _apiPostLike(post);
                      }else{
                        _apiPostUnLike(post);
                      }
                    },
                    icon: post.liked ? const Icon(
                      EvaIcons.heart,
                      color: Colors.red,
                    ): const Icon(
                      EvaIcons.heartOutline,
                      color: Colors.black,
                    )
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
