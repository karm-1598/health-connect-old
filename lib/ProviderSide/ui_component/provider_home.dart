import 'package:flutter/material.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/sizedBox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:health_connect2/controllers/theme_controller.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  String name = '';
  String id = '';
  String email = '';
  String proftype = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  void get() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      id = prefs.getString('id')!;
      email = prefs.getString('email')!;
      proftype = prefs.getString('provider') ?? '';
    });
  }

  void soo() {
    print(proftype);
  }

  void Logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('keepLoggedIn2');
    setState(() {
      goto.openUserOrProvider();
    });
    print('hello');
  }

  final themeData themeController=Get.put(themeData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
              text: 'Welcome ',
              style: TextStyle(
                  fontSize: 20, color: Color.fromARGB(177, 255, 255, 255)),
              children: [
                TextSpan(
                    text: ' $name',
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ]),
        ),
        actions: [
          Obx(()=>
                    IconButton(
                      iconSize: 35,
                      onPressed: (){
                    themeController.changeTheme();
                  }, icon: themeController.isDark.value?Icon(Icons.light_mode,):Icon(Icons.dark_mode)),
                  ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Column(
              children: [
                 
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customSizedBox(
                        assetImage: AssetImage('assets/images/schedule_appointment.png'),
                        text: 'Schedule',
                        path: () {
                          goto.openScheduleAppointment();
                        }),
                    customSizedBox(
                        assetImage:
                            AssetImage('assets/images/pending_appointment.png'),
                        text: 'Patients',
                        path: () {
                          goto.openProviderViewAppointmentList(
                              id: id, proftype: proftype);
                        })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customSizedBox(
                        assetImage:
                            AssetImage('assets/images/cancel_appointment.png'),
                        text: 'Rejected',
                        path: () {
                          goto.openRejectedappointment(
                              id: id, proftype: proftype);
                        }),
                    // jxjx

                    customSizedBox(
                        assetImage: AssetImage('assets/images/completed_appointment.png'),
                        text: 'Completed',
                        path: () {
                          goto.openCompletedAppointments(
                              id: id, proftype: proftype);
                        }),
                  ],
                ),
                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customSizedBox(
                        assetImage: AssetImage('assets/images/earnings.jpg'),
                        text: 'Earnings',
                        path: () {}),
                    // jxjx

                    customSizedBox(
                        assetImage: AssetImage('assets/images/logout.png'),
                        text: 'Logout',
                        path: () {
                          Logout();
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
