import 'package:flutter/material.dart';
import 'package:health_connect2/completed_appointments.dart';
import 'package:health_connect2/provider_view_appointment_list.dart';
import 'package:health_connect2/rejected_appointments.dart';
import 'package:health_connect2/schedual_appointment.dart';
import 'package:health_connect2/user_or_provider.dart';
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
    await prefs.remove('keepMeLoggedIn2');
    setState(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserOrProvider()));
    });
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleAppointment()));
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
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderViewAppointmentList(profId:id, proftype: proftype)));
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RejectedAppointments(profId:id, proftype: proftype)));
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedAppointments(profId:id, proftype: proftype)));
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

/**
 * ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleAppointment()));
          }, child: Text('Schedual appointment')),

          SizedBox(height: 20,),

          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderViewAppointmentList(profId:id, proftype: proftype)));
          }, child: Text('Pending Appointments')),

          SizedBox(height: 20,),

          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => RejectedAppointments(profId:id, proftype: proftype)));
          }, child: Text('Rejected Appointments')),

          SizedBox(height: 20,),

           ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CompletedAppointments(profId:id, proftype: proftype)));
          }, child: Text('Completed Appointments')),

          SizedBox(height: 20,),

          ElevatedButton(onPressed: (){
            Logout();
          }, child: Text('logout')),
        
 */