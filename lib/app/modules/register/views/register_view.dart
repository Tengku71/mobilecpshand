import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SignEase',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(fontSize: 20, color: Colors.orange),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Register',
                style: GoogleFonts.lobster(
                  textStyle:
                      const TextStyle(fontSize: 40, color: Colors.orange),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama',
                  style: TextStyle(fontSize: 20, color: Colors.orange),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Nama',
                  hintText: 'Masukkan nama Anda',
                ),
                onChanged: (value) => controller.updateName(value),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'TTL',
                  style: TextStyle(fontSize: 20, color: Colors.orange),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: Obx(
                      () => TextField(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Lahir',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: controller.birthDate.value == null
                              ? 'Pilih tanggal'
                              : controller.birthDate.value!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            controller.updateBirthDate(pickedDate);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Obx(
                      () => TextField(
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: controller.gender.value.isEmpty
                              ? 'Pilih jenis kelamin'
                              : controller.gender.value,
                        ),
                        readOnly: true,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 150,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('Laki-laki'),
                                      onTap: () {
                                        controller.updateGender('Laki-laki');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Perempuan'),
                                      onTap: () {
                                        controller.updateGender('Perempuan');
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(fontSize: 20, color: Colors.orange),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Email',
                  hintText: 'Masukkan email Anda',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.updateEmail(value),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Alamat',
                  style: TextStyle(fontSize: 20, color: Colors.orange),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Alamat',
                  hintText: 'Masukkan alamat Anda',
                ),
                onChanged: (value) => controller.updateAddress(value),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 20, color: Colors.orange),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Password',
                  hintText: 'Masukkan password Anda',
                ),
                obscureText: true,
                onChanged: (value) => controller.updatePassword(value),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  controller.register();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text(
                  'Daftar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 138, height: 2, color: Colors.black),
                  SizedBox(width: 20),
                  Text('OR'),
                  SizedBox(width: 20),
                  Container(width: 120, height: 2, color: Colors.black),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar('Info', 'Google Sign-In belum diimplementasi');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/google.png', width: 30, height: 30),
                    SizedBox(width: 10),
                    Text(
                      'Daftar menggunakan Google',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
