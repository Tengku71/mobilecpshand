import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/leaderboard/controllers/leaderboard_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

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
              Get.toNamed(Routes.HOME);
              break;
            case 2:
              Get.toNamed(Routes.PROFILE);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(Icons.transcribe_outlined, color: Colors.white),
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
        child: Column(
          children: [
            // Image Banner
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg2.png"),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Top 1 Leaderboard Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Rayhan Abdul Razak",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("TOP 1 Leaderboard"),
                      ],
                    ),
                  ),
                  const Column(
                    children: [
                      Text("Point 100"),
                      Icon(Icons.emoji_events_outlined),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Leaderboard Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Leaderboard",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Leaderboard List Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text("Rayhan Abdul Razak"),
                  ),
                  const Text("Point 100"),
                  const SizedBox(width: 4),
                  const Icon(Icons.emoji_events_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
