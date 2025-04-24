import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/core/widget/profile_image.dart';
import 'package:social_media_app/features/auth/view/screen/login_screen.dart';
import 'package:social_media_app/features/auth/view_model/profile_view_model.dart';

// استيراد ProfileViewModel
class ProfileScreen extends StatelessWidget {
  final UserModle user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    final nameController = TextEditingController(text: user.name);
    final aboutController = TextEditingController(text: user.about);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: mq.width, height: mq.height * .03),
                GestureDetector(
                  onTap: () => _showBottomSheet(context, mq, profileViewModel),
                  child:
                      profileViewModel.imagePath != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: Image.file(
                              File(profileViewModel.imagePath!),
                              width: mq.height * .2,
                              height: mq.height * .2,
                              fit: BoxFit.cover,
                            ),
                          )
                          : ProfileImage(
                            size: mq.height * .2,
                            username: user.name,
                            imageUrl: user.profileImageUrl,
                          ),
                ),

                SizedBox(height: mq.height * .03),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
                SizedBox(height: mq.height * .05),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'eg. Happy Singh',
                    label: Text('Name'),
                  ),
                ),
                SizedBox(height: mq.height * .02),
                TextFormField(
                  controller: aboutController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.info_outline, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: 'eg. Feeling Happy',
                    label: Text('About'),
                  ),
                ),
                SizedBox(height: mq.height * .05),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * .06),
                  ),
                  onPressed: () async {
                    // تحديث الاسم والوصف في Firebase
                    await profileViewModel.updateProfile(
                      nameController.text,
                      aboutController.text,
                    );

                    // إذا كانت صورة جديدة تم اختيارها، رفعها إلى Firebase
                    if (profileViewModel.imagePath != null) {
                      await profileViewModel.uploadProfilePicture(
                        File(profileViewModel.imagePath!),
                      );
                    }
                  },
                  icon: const Icon(Icons.edit, size: 28, color: Colors.blue),
                  label: const Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(
    BuildContext context,
    Size mq,
    ProfileViewModel profileViewModel,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: mq.height * .03,
            bottom: mq.height * .05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: mq.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        profileViewModel
                            .pickImageFromGallery, // استخدام pickImageFromGallery من ProfileViewModel
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .3, mq.height * .15),
                    ),
                    child: const Icon(
                      Icons.photo,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        profileViewModel
                            .pickImageFromCamera, // استخدام pickImageFromCamera من ProfileViewModel
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .3, mq.height * .15),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
