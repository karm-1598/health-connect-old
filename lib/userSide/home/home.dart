import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/userSide/home/googlemap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_connect2/controllers/theme_controller.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  Future<List<Map<String, dynamic>>> appointments = Future.value([]);
  String name = '';
  String email = '';
  String id = '';
  String imagePath='';
  var api = baseApi();
  bool isLoading= true;

  @override
  void initState() {
    super.initState();
    intial();
    
  }

  Future<void> intial() async {
    await get();
    appointments = getAppointments(id);
  }

  Future<void> get() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      email = prefs.getString('email')!;
      id = prefs.getString('id')!;
      
    });
    
  }
  


  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('keepLogedIn');
    setState(() {
      goto.openUserOrProvider();
    });
  }

 
  Future<List<Map<String, dynamic>>> getAppointments(String uid) async {
    print(uid);

    
    var appointements = await api.post('user_pending_confirmed_appointment.php', {'user_id': uid});

    try {
      var jsonResponse = appointements;

      if (jsonResponse['status'] == true &&
          jsonResponse['appointments'] is List) {
        return List<Map<String, dynamic>>.from(jsonResponse['appointments']);
      } else {
        throw Exception(jsonResponse['message'] ?? 'No Appointments found');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(
          'Failed to parse Appointment details. Response might be invalid JSON.');
    }
  }

     


  @override
  Widget build(BuildContext context) {
    themeData themeController= Get.put(themeData());
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: 'Welcome,  ',
            
            children: [
              TextSpan(
                  text: '$name ', )
            ],
          ),
        ),
        
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(height: 30,),
              CarouselSlider(
                items: [
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/slider1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/slider2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/slider3.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/slider4.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: ()=>goto.openDocList(),
                        child: SizedBox(
                          height: 156,
                          width: 130,
                          child: Card(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    height: 90,
                                    width: 90,
                                    decoration:const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/doctor.png'),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  Text('Doctors', style:Theme.of(context).textTheme.titleMedium ,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => goto.openNurseList(),
                        child: SizedBox(
                          height: 156,
                          width: 130,
                          child: Card(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            elevation: 4,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/nurse.png'),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                 SizedBox(height: 12,),
                                  Text('Nurses', style:Theme.of(context).textTheme.titleMedium ,),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => goto.openLabList(),
                        child: SizedBox(
                          height: 156,
                          width: 130,
                          child: Card(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            elevation: 4,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    height: 90,
                                    width: 90,
                                    decoration:const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/labs.png'),
                                          fit: BoxFit.cover),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  Text('Laboratries', style:Theme.of(context).textTheme.titleMedium ,overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // jxjx
                      InkWell(
                        onTap: () => goto.openPhysioList(),
                        child: SizedBox(
                            height: 156,
                            width: 130,
                            child: Card(
                                color: Theme.of(context).colorScheme.surfaceContainer,
                                elevation: 4,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 90,
                                        width: 90,
                                        
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/physiotherapist.png'),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                      ),
                                      SizedBox(height: 12,),
                                  Text('Physiotherapist', style:Theme.of(context).textTheme.titleMedium ,overflow: TextOverflow.ellipsis,)
                                    ],
                                  ),
                                ))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Upcoming Appointments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: appointments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Appointments found'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final appointment = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Card(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(Icons.person,
                                        size: 40, color: Colors.white),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text: 'Patient: ',
                                            style: TextStyle(fontSize: 16),
                                            children: [
                                              TextSpan(
                                                text: '$name ',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text.rich(
                                          TextSpan(
                                            text:
                                                '${appointment['profession_type']}: ',
                                            style: TextStyle(fontSize: 16),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${appointment['provider_name']} ${appointment['provider_lastname']} ',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Reason: ',
                                            style: TextStyle(fontSize: 16),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${appointment['reason']}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Status: ',
                                            style: TextStyle(fontSize: 16),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${appointment['status']}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text.rich(
                                TextSpan(
                                  text: 'Booked on: ',
                                  style: TextStyle(fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${appointment['date']} at ${appointment['time']}',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ]),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Stack(
              children:[ UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                  
                ),
                accountName: Text(name),
                accountEmail: Text(email),
                decoration:
                    BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
                arrowColor: Colors.white,
              ),

                Positioned(
                  left: 245,
                  height: 30,
                  child: Obx(()=>
                    IconButton(
                      iconSize: 35,
                      onPressed: (){
                    themeController.changeTheme();
                  }, icon: themeController.isDark.value?Icon(Icons.light_mode,):Icon(Icons.dark_mode)),
                  ),)
              
              ]
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('User Profile'),
              onTap: () {
                goto.openUserProfile(id: id);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_turned_in_outlined),
              title: Text('Completed Appointments'),
              onTap: () {
                goto.openUserCompletedAppintements(id: id);
              },
            ),
            ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text('Cancelled Appointments'),
              onTap: () {
                goto.openCancelledappointements(id: id);
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('About Us'),
              onTap: () {
                goto.openAbotus();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                logout();
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.location_on),
            //   title: Text('Google Map'),
            //   onTap: (){
            //     // Get.to(()=>Googlemap());
            //   },
            // ),
           
          ],
        ),
      ),
    );
  }
}
