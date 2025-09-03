import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect2/controllers/radioController.dart';
import 'package:health_connect2/controllers/rangeController.dart';
import 'package:health_connect2/controllers/ratingController.dart';
import 'package:health_connect2/controllers/sortingController.dart';
import 'package:health_connect2/network/commonApi_fun.dart';
import 'package:health_connect2/routes/app_navigator.dart';
import 'package:health_connect2/widgets/rangeSlider.dart';
import 'package:health_connect2/widgets/speechToText.dart';

class DocList extends StatefulWidget {
  const DocList({super.key});

  @override
  State<DocList> createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  late Future<List<Map<String, dynamic>>> doctors;
  List<Map<String, dynamic>> allDoctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];

  TextEditingController searchController = TextEditingController();
  final ScrollController scroll=ScrollController();
  bool isSearching = false;
  String startValue = '';
  String endValue = '';
  String selectedOption = 'best_offer';

  final radioController controller = Get.put(radioController());
  final rangeController controller2 = Get.put(rangeController());
  final Ratingcontroller controller3=Get.put(Ratingcontroller());
  final Sortingcontroller controller4=Get.put(Sortingcontroller());

  @override
  void initState() {
    super.initState();
    doctors = fetchDocs();
    searchController.addListener(_searchChanged);
  }

  void scrolltotop() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (scroll.hasClients) {
      scroll.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
      );
    }
  });
}


  Future<List<Map<String, dynamic>>> fetchDocs() async {
    var api = baseApi();
    var response = await api.get('doc_data.php');
    try {
      if (response is List && response.isNotEmpty) {
        List<Map<String, dynamic>> jsonResponse =
            List<Map<String, dynamic>>.from(response);
        allDoctors = jsonResponse;
        filteredDoctors = List.from(allDoctors);
        return filteredDoctors;
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _searchDoctors(String searchValue) async {
  if (searchValue.trim().isEmpty) {
    throw Exception('Please enter a search term');
  }
  
  var api = baseApi();
  var response = await api.get('doc_search.php', queryParams: {'search': searchValue});
  
  try {
    if (response is List && response.isNotEmpty) {
      List<Map<String, dynamic>> jsonResponse =
          List<Map<String, dynamic>>.from(response);
      
      // Update filtered doctors with search results
      filteredDoctors = jsonResponse;
      return filteredDoctors;
    } else {
      // Handle empty results or non-list response
      filteredDoctors = [];
      throw Exception('No doctors found matching your search');
    }
  } catch (e) {
    throw Exception('Failed to search doctors: $e');
  }
}

void sortDoctors(String selecteOption){
  String sortDoc=controller4.selectedOption.value;
  switch(sortDoc){
    case'charges_low_to_high':
      setState(() {
        filteredDoctors.sort((a,b)=>int.parse(a['avg_consultation_fee'].toString()).compareTo(int.parse(b['avg_consultation_fee'].toString())));
      });
      break;
    case 'charges_high_to_low':
      setState(() {
          filteredDoctors.sort((a,b)=>int.parse(b['avg_consultation_fee'].toString()).compareTo(int.parse(a['avg_consultation_fee'].toString())));
        });
        break;
      case 'exp_low_to_high':
        setState(() {
          filteredDoctors.sort((a,b)=>int.parse(a['experience'].toString()).compareTo(int.parse(b['experience'].toString())));
        });
        break;
      case 'exp_high_to_low':
        setState(() {
          filteredDoctors.sort((a,b)=>int.parse(b['experience'].toString()).compareTo(int.parse(a['experience'].toString())));
        });
        break;
  }
}

  void filterDoctors(double minFee, maxFee) {
    setState(() {
      filteredDoctors = allDoctors.where((doc) {
        double price =
            double.tryParse(doc['avg_consultation_fee'].toString()) ?? 0;
        return price >= minFee && price <= maxFee;
      }).toList();

      doctors = Future.value(filteredDoctors);
    });
  }

  void clearfilterDoctors() {
    setState(() {
      filteredDoctors = allDoctors;
      doctors = Future.value(allDoctors);
    });
  }

  void filterDoctorsExp(double minExp, maxExp) {
    setState(() {
      filteredDoctors = allDoctors.where((doc) {
        int experience =
            int.tryParse(doc['experience'].toString()) ?? 0;
        return experience >= minExp && experience <= maxExp;
      }).toList();

      doctors = Future.value(filteredDoctors);
    });
  }

  void clearfilterDoctorsExp() {
    setState(() {
      filteredDoctors = allDoctors;
      doctors = Future.value(allDoctors);
    });
  }

  void _searchChanged() {
    String searchText = searchController.text.trim();
    if (searchText.isNotEmpty) {
      setState(() {
        doctors = _searchDoctors(searchText);
      });
    } else {
      setState(() {
        doctors = fetchDocs();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchController.removeListener(_searchChanged);
    scroll.dispose();
  }

  void dialogBox() {
    return dialogBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Speechtotext(onResult: (text) {
                        searchController.text = text;
                      }),
                      IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            isSearching = false;
                          });
                        },
                        icon: Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
            : Text('Find Your Doctors',style: TextStyle(color: Colors.white),),
        actions: [
          if (!isSearching)
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // filter portion
              InkWell(
                onTap: () {
                  Get.bottomSheet(
                    isScrollControlled: true,
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                )),
                          ),
                          Expanded(
                            child: Container(
                              decoration:  BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10)
                                  ),
                              child:
                                  StatefulBuilder(builder: (context, setstate) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Filter',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                controller.ondispose();
                                                controller2.resetRange();
                                                clearfilterDoctors();
                                                controller3.clearRating();
                                                controller2.resetRangeExp();
                                                Get.back();
                                              },
                                              child: Text(
                                                'clear',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ))
                                        ],
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black12,
                                              ),
                                              borderRadius:BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Price Range',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    Obx(() => Text(
                                                          '${controller2.rangevalues.value.start} - ${controller2.rangevalues.value.end}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                        ))
                                                  ],
                                                ),
                                                rangeSlider(
                                                    max: '1000',
                                                    min: '100',
                                                    controllerValue: controller2.rangevalues,
                                                    onChanged:
                                                        (RangeValues v) {}),
                                              ],
                                            ),
                                          )),

                                      const SizedBox(height: 5,),

                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black12,
                                              ),
                                              borderRadius:BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Experience',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    Obx(() => Text(
                                                          '${controller2.rangevaluesExp.value.start} - ${controller2.rangevaluesExp.value.end}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                        ))
                                                  ],
                                                ),
                                                rangeSlider(max: '20', min: '1', onChanged: (RangeValues v){}, controllerValue: controller2.rangevaluesExp,)
                                              ],
                                            ),
                                          )),


                                      const SizedBox(height: 10,),

                                      // rating bar
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black12,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Rating',style: Theme.of(context).textTheme.bodyMedium,),
                                              Obx(()=>
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Wrap(
                                                      spacing: 8,
                                                      children: [
                                                        ...List.generate(5, (index){
                                                      bool isSelected=index<controller3.ratingStar.value;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          controller3.ratingStar.value=index+1;
                                                          print(controller3.ratingStar.value);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.black26),
                                                            borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(3.0),
                                                            child: isSelected?Icon(Icons.star_rounded,size: 18,color:Colors.amber):
                                                            Icon(Icons.star_outline_rounded,size: 18,color:Colors.grey),
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                      ],
                                                    ),
                                                    Text(controller3.ratingStar.value.toString(),style: Theme.of(context).textTheme.headlineMedium,)
                                                  ],
                                                )
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 40),
                                    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10))),
                                onPressed: () {
                                  filterDoctors(
                                      controller2.rangevalues.value.start,
                                      controller2.rangevalues.value.end);
                                  filterDoctorsExp(
                                    controller2.rangevaluesExp.value.start, 
                                    controller2.rangevaluesExp.value.end);
                                      scrolltotop();
                                  Get.back();
                                },
                                
                                child: Text('Apply',style: TextStyle(color: Theme.of(context).inputDecorationTheme.fillColor),)),
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(8),),
                      border: Border.all(color: Colors.black12)
                      ),
                      
                  width: 150,
                  height: 50,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Filter'),Icon(Icons.filter_list)],
                    ),
                  
                ),
              ),

              // sort portion
              InkWell(
                onTap: (){
                  Get.bottomSheet(                    
                        Container(                          
                          height: MediaQuery.of(context).size.height*0.51,                          
                          padding: EdgeInsets.all(15),
                          
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:BorderRadius.all(Radius.circular(10))
                            ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                  Text('Sort By',style: Theme.of(context).textTheme.headlineMedium,),
                                  const SizedBox(height: 10,),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Obx((){
                                      String selectedd=controller4.selectedOption.value;
                                      return ListView.separated(
                                                            
                                        shrinkWrap: true,
                                        separatorBuilder:(context, index) {
                                          return const Divider(
                                            color: Colors.black12,
                                            thickness: 1,
                                          );
                                        },
                                        physics:NeverScrollableScrollPhysics(),
                                        itemCount: controller4.sorting.length,
                                        itemBuilder: (context,index){
                                        final isselected=controller4.sortingValues[index]==selectedd;
                                        return ListTile(
                                          title: Text(controller4.sorting[index],
                                          style: isselected?Theme.of(context).textTheme.headlineSmall:
                                                  Theme.of(context).textTheme.bodyMedium,),
                                          leading: Icon(isselected? Icons.radio_button_checked: 
                                                                    Icons.radio_button_off,color: isselected?Theme.of(context).appBarTheme.backgroundColor : Colors.black,
                                                              ),
                                          onTap: () {
                                            controller4.selectOption(controller4.sortingValues[index]);
                                            
                                          },
                                        );
                                        
                                      });
                                    }),
                                    )
                                  ],
                                                                
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 40),
                                    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10))),
                                onPressed: () {
                                  sortDoctors(controller4.selectedOption.value.toString());
                                  Get.back();
                                  scrolltotop();
                                },
                                child: Text('Close', style: TextStyle(color: Theme.of(context).inputDecorationTheme.fillColor),),),
                          )
                              ]),
                          
                        ),
                        
                      
                    isScrollControlled: true,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(8),),
                      border: Border.all(color: Colors.black12)
                      ),
                      
                  width: 150,
                  height: 50,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Sort'),Icon(Icons.sort)],
                    ),
                  
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: doctors,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No doctors found'));
                } else {
                  return ListView.builder(
                    controller: scroll,
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
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
                                          Text(
                                            'Dr. ${doctor['name']} ${doctor['lastname']}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(doctor['qualification']),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${doctor['experience']} years experience',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text.rich(
                                  TextSpan(
                                    text: 'Charges: ',
                                    children: [
                                      TextSpan(
                                        text:
                                            '${doctor['avg_consultation_fee']} INR',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('Available Time: ${doctor['availability_slot_time']}'),
                                Text('From: ${doctor['availability_slot_days']}'),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        goto.openDocBookAppointment(
                                            id: doctor['id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Circular border radius
                                        ),
                                      ),
                                      child: Text('Book Appointment'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        goto.openDocIndividualProfile(
                                            id: doctor['id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('View Profile'),
                                    ),
                                  ],
                                )
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
          ),
        ],
      ),
    );
  }
}
