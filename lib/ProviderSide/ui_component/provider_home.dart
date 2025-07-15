import 'package:flutter/material.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {

  String name='';
  String id='';
  String email='';
  String proftype='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }
  void get() async{
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      name= prefs.getString('name')!;
      id = prefs.getString('id')!;
      email = prefs.getString('email')!;
      proftype = prefs.getString('provider') ?? '';
    });
  }
void soo(){
  print(proftype);
}
  void Logout() async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('keepLoggedIn2');
    setState(() {
      goto.openUserOrProvider();
    });
    print('hello');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: 'Welcome ',
            style: TextStyle(fontSize: 20,color: Color.fromARGB(177, 255, 255, 255)),
            children:[ TextSpan(
              text: ' $name',
              style: const TextStyle(fontSize:30, fontWeight: FontWeight.bold,color: Colors.white)
            )]
          ),
          
        ),
        backgroundColor: const Color.fromRGBO(46, 68, 176, 1),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Container(
            
            child: Padding(padding: EdgeInsets.only(left: 0,right: 0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 156,
                      width: 160,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/schedule_appointment.png'), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  goto.openScheduleAppointment();
                                },
                                label: Text('Schedule'),
                                icon: Icon(Icons.arrow_circle_right_sharp),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      height: 156,
                      width: 160,
                      child: Card(
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
                                      image: AssetImage('assets/images/pending_appointment.png'), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  goto.openProviderViewAppointmentList(id: id, proftype: proftype);
                                },
                                label: Text('Patients'),
                                icon: Icon(Icons.arrow_circle_right_sharp),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),

                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 156,
                      width: 160,
                      child: Card(
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
                                      image: AssetImage('assets/images/cancel_appointment.png'), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  goto.openRejectedappointment(id: id,proftype: proftype);
                                },
                                label: Text('Rejected'),
                                icon: Icon(Icons.arrow_circle_right_sharp),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // jxjx
                    SizedBox(
                      height: 156,
                      width: 160,
                      child: Card(
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
                                      image: AssetImage('assets/images/completed_appointment.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                 goto.openCompletedAppointments(id: id, proftype: proftype);
                                },
                                label: Text('completed'),
                                icon: Icon(Icons.arrow_circle_right_sharp),
                              ),
                            ],
                          ),
                        )
                      )
                    ), 
                  ],
                ),

                SizedBox(height: 20,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 156,
                      width: 160,
                      child: Card(
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
                                      image: AssetImage('assets/images/earnings.jpg'), fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                label: Text('Earnings'),
                                icon: Icon(Icons.arrow_circle_right_sharp),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // jxjx
                    SizedBox(
                      height: 156,
                      width: 160,
                      child: Card(
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
                                      image: AssetImage('assets/images/logout.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Logout();
                                },
                                label: Text('Logout'),
                                icon: Icon(Icons.arrow_circle_right_sharp),
                              ),
                            ],
                          ),
                        )
                      )
                    ), 
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