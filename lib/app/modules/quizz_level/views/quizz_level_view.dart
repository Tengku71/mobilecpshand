import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/quizz_level/controllers/quizz_level_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';

class QuizzLevelView extends GetView<QuizzLevelController> {
  const QuizzLevelView({super.key});

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
                  child: Obx(() => Row(
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
                ),
              ),
              SizedBox(height: 20),

              // Quiz Level Section
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "QUIZ Level",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Monospace',
                      ),
                    ),
                    SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                          onPressed: () {
                            // Navigate to quiz level when a button is pressed
                            // Get.toNamed(Routes.QUIZZ_LEVEL_DETAIL,
                            //     parameters: {'level': (index + 1).toString()});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
