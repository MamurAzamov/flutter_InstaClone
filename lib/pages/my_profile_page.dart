import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/db_service.dart';
import 'package:insta_clone/services/file_service.dart';

import '../model/member_model.dart';
import '../model/post_model.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool isLoading = false;
  int axisCount = 2;
  List<Post> items = [];
  File? _image;
  String fullname = "", email = "", img_url = "";
  int count_posts = 10, count_followers = 1415, count_following = 100;
  final ImagePicker _picker = ImagePicker();

  String image_1 = "https://images.unsplash.com/photo-1512971064777-efe44a486ae0";
  String image_2 = "https://images.unsplash.com/photo-1493119508027-2b584f234d6c";
  String image_3 = "https://images.unsplash.com/photo-1646617747566-b7e784435a48";

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    _apiChangedPhoto();
  }
  _imgFromCamera() async {
    XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(photo!.path);
    });
    _apiChangedPhoto();
  }

  void _apiChangedPhoto() {
    if(_image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadUserImage(_image!).then((downloadUrl) => {
      _apiUpdateUser(downloadUrl),
    });
  }

  _apiUpdateUser(String downloadUrl) async {
    Member member = await DBService.loadMember();
    member.img_url = downloadUrl;
    await DBService.updateMember(member);
    _apiLoadMember();
  }

  @override
  void initState() {
    super.initState();
    items.add(Post(image_1, "Sheikh Zayed Mosque in Abu Dhabi"));
    items.add(Post(image_2, "Mobile Development with Flutter"));
    items.add(Post(image_3, "Draw a picture"));
    _apiLoadMember();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Pick Photo'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _apiLoadMember() {
    setState(() {
      isLoading = true;
    });
    DBService.loadMember().then((value) => {
      _showMemberInfo(value),
    });
  }

  void _showMemberInfo(Member member){
    setState(() {
      isLoading = false;
      this.fullname = member.fullname;
      this.email = member.email;
      this.img_url = member.img_url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(
            color: Colors.black, fontFamily: "Billabong", fontSize: 25),),
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: const Icon(Icons.exit_to_app),
            color: const Color.fromRGBO(245, 96, 64, 1),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    _showPicker(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            border: Border.all(
                              width: 1.5,
                              color: const Color.fromRGBO(245, 96, 64, 1),
                            )
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: img_url == null || img_url.isEmpty
                            ? const Image(
                            image: AssetImage("assets/images/avatarInsta.png"),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ): Image.network(
                            img_url,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Icon(Icons.add_circle, color: Colors.purple,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 10,),
                Text(fullname.toUpperCase(), style: const TextStyle(
                  color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                const SizedBox(height: 3,),
                Text(email, style: const TextStyle(
                    color: Colors.black54,fontSize: 14,fontWeight: FontWeight.normal),),
                
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(count_posts.toString(),style: const TextStyle(
                                  color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 3,),
                              const Text("POSTS",style: TextStyle(
                                  color: Colors.grey,fontSize: 14,fontWeight: FontWeight.normal),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(count_followers.toString(),style: const TextStyle(
                                  color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 3,),
                              const Text("FOLLOWERS",style: TextStyle(
                                  color: Colors.grey,fontSize: 14,fontWeight: FontWeight.normal),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(count_following.toString(),style: const TextStyle(
                                  color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 3,),
                              const Text("FOLLOWING",style: TextStyle(
                                  color: Colors.grey,fontSize: 14,fontWeight: FontWeight.normal),)
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
                          onPressed: (){
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
                          onPressed: (){
                            setState(() {
                              axisCount = 2;
                            });
                          },
                          icon: const Icon(Icons.grid_view),
                        ),
                      ),
                    )
                  ],
                ),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: axisCount
                    ),
                    itemCount: items.length,
                    itemBuilder: (ctx, index){
                      return _itemOfPost(items[index]);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _itemOfPost(Post post){
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.img_post,
              placeholder: (contex, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (contex, url, error) => const Icon(Icons.error),
              fit:  BoxFit.cover,
            ),
          ),
          const SizedBox(height: 3,),
          Text(post.caption, style: TextStyle(
              color: Colors.black87.withOpacity(0.7)),maxLines: 2,)
        ],
      ),
    );
  }
}
