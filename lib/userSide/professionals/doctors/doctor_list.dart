import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect2/controllers/radioController.dart';
import 'package:health_connect2/controllers/rangeController.dart';
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
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String startValue='';
  String endValue='';
  String selectedOption='best_offer';

  final radioController controller= Get.put(radioController());
  final rangeController controller2= Get.put(rangeController());

  @override
  void initState() {
    super.initState();
    doctors = fetchDocs();
    searchController.addListener(_searchChanged);
  }

  Future<List<Map<String, dynamic>>> fetchDocs() async {
    var api = baseApi();
    var response = await api.get('doc_data.php');
    try {
      if (response is List && response.isNotEmpty) {
        List jsonResponse = response;
        return List<Map<String, dynamic>>.from(jsonResponse);
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
    try {
      var api = baseApi();
      var response =
          await api.get('doc_search.php', queryParams: {'search': searchValue});
      if (response is List && response.isNotEmpty) {
        return response.cast<Map<String, dynamic>>();
      } else {
        throw Exception(response['message'] ?? 'No results');
      }
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _filterDoctors(String max_val, min_val, max_exp, min_exp)async{
    try{
      var api= baseApi();
      var response= await api.get('doc_search.php', queryParams:{
        'max_price':max_val.toString(),
        'min_price':min_val.toString(),
        'max_exp':max_exp.toString(),
        'min_exp':min_exp.toString(),
      });
      if(response is List && response.isNotEmpty){
        return response.cast<Map<String, dynamic>>();
      } else if (response is Map && response.containsKey('message')) {
      
      throw Exception(response['message']);
    } else {
        throw Exception(response['message'] ?? 'No results');
      }
    }catch(e){
      throw Exception('Failed to Filter: $e');
    }
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
            : Text(
                'Find Your Doctors',
                style: TextStyle(color: Colors.white),
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // filter portion
              InkWell(
                onTap: (){
                  Get.bottomSheet(Container(
                    height: 700,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: StatefulBuilder(builder: (context, setstate){
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Filter',style: Theme.of(context).textTheme.headlineMedium,),
                                TextButton(onPressed: (){
                                  controller.ondispose();
                                  controller2.resetRange();
                                  Get.back();}, child: Text('clear',style: Theme.of(context).textTheme.headlineSmall,))
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12,),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Price Range',style: Theme.of(context).textTheme.bodyMedium,),
                                        Obx(()=>
                                        Text('${controller2.rangevalues.value.start} - ${controller2.rangevalues.value.end}',style: Theme.of(context).textTheme.headlineMedium,)
                                        )
                                      ],
                                    ),
                                    
                                    rangeSlider(max: '500', min: '100', onChanged: (RangeValues v){}),
                                  ],
                                ),
                              )),

                              SizedBox(height: 5,),

                              // offer section
                              Container(
                                decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12,),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Offers',style: Theme.of(context).textTheme.bodyMedium),
                                
                                    Obx((){
                                    String selectedd= controller.selectedOption.value;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemCount: controller.offers.length,
                                      itemBuilder: (context, index){
                                        final isSelected= controller.offersValue[index] == selectedd;

                                        return ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(controller.offers[index]),
                                          leading: Icon(isSelected? Icons.radio_button_checked:Icons.radio_button_off, color: isSelected?Colors.amberAccent:Colors.black,),
                                          onTap: () {
                                            controller.selectOption(controller.offersValue[index]);
                                          },
                                        );
                                      });})
                                  ],
                                ),
                              ),
                              ),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 40),
                                  backgroundColor: Colors.amber,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
                                ),
                                onPressed: (){Get.back();}, child: Text('Apply'))
                          ],
                        ),
                      );
                    }),
                  ));
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color:  Color.fromARGB(255, 109, 68, 255)
                  ),
                  width: MediaQuery.of(context).size.width * .5,
                  height: 50,
                  child: Center(
                    child: Text('Filter'),
                  ),
                ),
              ),
              
              // sort ortion
              InkWell(
                child: Container(
                  decoration: const BoxDecoration(
                    color:  Color.fromARGB(255, 255, 143, 68)
                  ),
                  width: MediaQuery.of(context).size.width * .5,
                  height: 50,
                  child: Center(
                    child: Text('Sort'),
                  ),
                ),
              ),
            ],
          ),
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final doctor = snapshot.data![index];
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
                                Text(
                                    'Available Time: ${doctor['availability_slot_time']}'),
                                Text(
                                    'From: ${doctor['availability_slot_days']}'),
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
