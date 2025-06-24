import 'package:flutter/material.dart';
import 'package:health_connect2/provider_login.dart';
import 'package:health_connect2/user_login.dart';

class UserOrProvider extends StatefulWidget {
  const UserOrProvider({super.key});

  @override
  State<UserOrProvider> createState() => _UserOrProviderState();
}

class _UserOrProviderState extends State<UserOrProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(46, 68, 176, 0.629),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Card(
                color: Color.fromRGBO(212, 240, 232, 1),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 130,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/healthcare_provider.jpeg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const providerLogin(),
                            ),
                          );
                        },
                        label: Text('Healthcare Providers'),
                        icon: Icon(Icons.arrow_circle_right_sharp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Card(
                color: Color.fromRGBO(212, 240, 232, 1),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 130,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/user_login.jpeg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const user_login(),
                            ),
                          );
                        },
                        label: Text('Users'),
                        icon: Icon(Icons.arrow_circle_right_sharp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
