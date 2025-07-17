import 'package:flutter/material.dart';


class customSizedBox extends StatelessWidget {
  AssetImage assetImage;
  String text;
  VoidCallback? path;
   customSizedBox({super.key, required this.assetImage, required this.text,  this.path});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
                      height: 156,
                      width: 160,
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: assetImage, fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                              TextButton.icon(
                                onPressed:path
                                ,
                                label: Text(text),
                                icon: Icon(Icons.arrow_circle_right_sharp),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
}}