import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyUploadPage extends StatefulWidget {
  final PageController? pageController;
  const MyUploadPage({Key? key, this.pageController}) : super(key: key);

  @override
  State<MyUploadPage> createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  bool isLoading = false;
  var captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  _uploadNewPost(){
    String caption = captionController.text.toString().trim();
    if(caption.isEmpty) return;
    if(_image == null) return;
    _moveToFeed();
  }

  _moveToFeed(){
    setState(() {
      isLoading = false;
    });
    captionController.text = "";
    _image = null;
    widget.pageController!.animateToPage(
        0, duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn);
  }

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
  }
  _imgFromCamera() async {
    XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(photo!.path);
    });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("UpLoad", style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: (){
              _uploadNewPost();
            },
            icon: const Icon(Icons.drive_folder_upload),
            color: const Color.fromRGBO(245, 96, 64, 1),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      _showPicker(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.4),
                      child: _image == null ? const Center(
                        child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey,),
                      ) : Stack(
                        children: [
                          Image.file(
                            _image!, width:
                          double.infinity, height:
                          double.infinity,
                          fit: BoxFit.cover,),
                          Container(
                            width: double.infinity,
                            color: Colors.black12,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  icon: const Icon(Icons.highlight_remove),
                                  color: Colors.white,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextField(
                      controller: captionController,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: "Caption",
                          hintStyle:
                          TextStyle(fontSize: 17, color: Colors.black38)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading? const Center(
            child: CircularProgressIndicator(),
          ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}
