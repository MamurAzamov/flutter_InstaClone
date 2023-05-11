import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';

class MyLikesPage extends StatefulWidget {
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {

  bool isLoading = false;
  List<Post> items = [];
  String image_1 = "https://images.unsplash.com/photo-1512971064777-efe44a486ae0";
  String image_2 = "https://images.unsplash.com/photo-1493119508027-2b584f234d6c";
  String image_3 = "https://images.unsplash.com/photo-1646617747566-b7e784435a48";

  @override
  void initState() {
    super.initState();
    items.add(Post(image_1, "Sheikh Zayed Mosque in Abu Dhabi"));
    items.add(Post(image_2, "Mobile Development with Flutter"));
    items.add(Post(image_3, "Draw a picture"));
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
                        child: const Image(
                          image: AssetImage("assets/images/avatarInsta.png"),
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Azamov Mamur", style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),),
                          SizedBox(height: 3,),
                          Text("2023-05-03  13:23", style: TextStyle(
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
                    onPressed: (){},
                    icon: const Icon(EvaIcons.heart, color: Colors.red,),
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
