import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOME);
              break;
            case 1:
              Get.toNamed(Routes.TRANSCRIBE);
              break;
            case 2:
              Get.toNamed(Routes.PROFILE);
              break;
            default:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.transcribe_outlined,
                color: Colors.white,
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(217, 217, 217, 1),
                  image: DecorationImage(
                    image: AssetImage("assets/bg1.png"),
                    fit: BoxFit.fitWidth,
                    opacity: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "HI ${controller.user.value.name}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 99, 181),
                                ),
                              ),
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    controller.user.value.profileImage),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Menu Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _menuCard(
                    "Edukasi",
                    Icons.book_outlined,
                    Colors.white,
                    0,
                    () {
                      Get.toNamed(Routes.EDUKASI);
                    },
                  ),
                  _menuCard(
                    "Leaderboard",
                    Icons.leaderboard_outlined,
                    Colors.white,
                    1,
                    () {
                      Get.toNamed(Routes.LEADERBOARD);
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // CTA Card
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.groups_2_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ayo Coba sekarang !",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "Mulai belajar dengan lebih mudah dan menyenangkan",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white70)),
                        ],
                      ),
                    ),
                    Text("Start",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Kuiz section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Kuiz ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(">>",
                        style: TextStyle(fontSize: 20, color: Colors.blue)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 150, // You can adjust the height as needed
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to another page using Get.toNamed
                            Get.toNamed(Routes
                                .QUIZZ_LEVEL); // Replace '/yourRouteName' with your actual route
                          },
                          child: Image.asset(
                            "assets/medals.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.QUIZZ_TIMER);
                          },
                          child: Image.asset(
                            "assets/quizz.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
      String title, IconData icon, Color color, int index, VoidCallback onTap) {
    return Obx(() {
      bool isSelected = controller.selectedIndex.value == index;

      return GestureDetector(
        onTap: () {
          controller.selectedIndex.value = index;
          onTap();
        },
        child: Container(
          height: 110,
          width: 100,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: isSelected ? color : Colors.blue),
                SizedBox(height: 30),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
