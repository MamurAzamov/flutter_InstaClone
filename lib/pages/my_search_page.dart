import 'package:flutter/material.dart';
import 'package:insta_clone/pages/users_page.dart';

import '../model/member_model.dart';
import '../services/db_service.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  bool isLoading = false;
  var searchController = TextEditingController();
  List<Member> items = [];

  void _apiSearchMembers(String keyword) {
    setState(() {
      isLoading = true;
    });
    DBService.searchMembers(keyword).then((users) => {
      _respSearchMembers(users),
    });
  }

  void _respSearchMembers(List<Member> members) {
    if(mounted) {
      setState(() {
      items = members;
      isLoading = false;
    });
    }
  }

  void _apiFollowMember(Member someone) async {
    setState(() {
      isLoading = true;
    });
    await DBService.followMember(someone);
    if(mounted) {
      setState(() {
      someone.followed = true;
      isLoading = false;
    });
    }
    DBService.storePostsToMyFeed(someone);
  }

  void _apiUnFollowMember(Member someone) async {
    setState(() {
      isLoading = true;
    });
    await DBService.unfollowMember(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DBService.removePostsFromMyFeed(someone);
  }

  @override
  void initState() {
    super.initState();
    _apiSearchMembers("");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Search", style: TextStyle(
            color: Colors.black, fontFamily: "Billabong", fontSize: 25),),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7)
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.black87),
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      icon: Icon(Icons.search, color: Colors.grey,),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index){
                      return _itemOfMember(items[index]);
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

  Widget _itemOfMember(Member member){
    return Container(
      height: 90,
      child: Row(
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
              borderRadius: BorderRadius.circular(22.5),
              child: member.img_url.isEmpty ? const Image(
                image: AssetImage("assets/images/avatarInsta.png"),
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ): Image.network(
                member.img_url,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              )
            ),
          ),
          const SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, UserPage.id);
                },
                child: Text(member.fullname, style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 3,),
              Text(member.email, style: const TextStyle(color: Colors.black54),),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    if(member.followed){
                      _apiUnFollowMember(member);
                    }else{
                      _apiFollowMember(member);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.blue
                    ),
                    child: Center(
                      child: member.followed ? const Text("Following",style: TextStyle(
                          color: Colors.white),): const Text("Follow",style: TextStyle(
                          color: Colors.white),),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
