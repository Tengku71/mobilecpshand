import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/edit_profile/controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: controller.user.value.name);
    final emailController = TextEditingController(text: controller.user.value.email);
    final imageController = TextEditingController(text: controller.user.value.profileImage);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imageController.text),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                controller.updateUser(
                  nameController.text,
                  emailController.text,
                  imageController.text,
                );
                Get.back();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
