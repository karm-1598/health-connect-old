
import 'package:get/get.dart';
import 'package:health_connect2/ProviderSide/ui_component/select_category.dart';
import 'package:health_connect2/userSide/common/about_us.dart';
import 'package:health_connect2/userSide/appointment/book_appointment.dart';
import 'package:health_connect2/ProviderSide/ui_component/completed_appointments.dart';
import 'package:health_connect2/userSide/professionals/doctors/doc_individual_profile.dart';
import 'package:health_connect2/userSide/professionals/doctors/doctor_list.dart';
import 'package:health_connect2/ProviderSide/registration/doctor_registration.dart';
import 'package:health_connect2/userSide/home/home.dart';
import 'package:health_connect2/userSide/professionals/laboratries/lab+individual_profile.dart';
import 'package:health_connect2/userSide/appointment/lab_book_appointment.dart';
import 'package:health_connect2/userSide/professionals/laboratries/lab_list.dart';
import 'package:health_connect2/ProviderSide/registration/lab_registration.dart';
import 'package:health_connect2/userSide/appointment/nurse_book_appointment.dart';
import 'package:health_connect2/userSide/professionals/nurses/nurse_individual_profile.dart';
import 'package:health_connect2/userSide/professionals/nurses/nurse_list.dart';
import 'package:health_connect2/ProviderSide/registration/nurse_registration.dart';
import 'package:health_connect2/userSide/appointment/physio_book_appointment.dart';
import 'package:health_connect2/userSide/professionals/physiotherapists/physio_individual_profile.dart';
import 'package:health_connect2/userSide/professionals/physiotherapists/physio_list.dart';
import 'package:health_connect2/ProviderSide/registration/physio_registration.dart';
import 'package:health_connect2/ProviderSide/ui_component/provider_home.dart';
import 'package:health_connect2/ProviderSide/login/provider_login.dart';
import 'package:health_connect2/ProviderSide/ui_component/provider_view_appointment_list.dart';
import 'package:health_connect2/ProviderSide/ui_component/rejected_appointments.dart';
import 'package:health_connect2/ProviderSide/ui_component/schedual_appointment.dart';
import 'package:health_connect2/userSide/appointment/user_cancelled_appointments.dart';
import 'package:health_connect2/userSide/appointment/user_completed_appointments.dart';
import 'package:health_connect2/userSide/auth/user_login.dart';
import 'package:health_connect2/userSide/auth/user_registration.dart';
import 'package:health_connect2/userSide/userProfile/user_update.dart';
import 'package:health_connect2/user_or_provider.dart';
import 'package:health_connect2/userSide/userProfile/user_profile.dart';

class goto{
  static Transition transition = Transition.circularReveal;
  static Duration duration = const Duration(milliseconds: 500);

  static gobackHome(){
    Get.off(()=> home_screen());
  }

  static openhome_screen(){
    Get.to(()=> home_screen());
  }

  static openUserOrProvider(){
    Get.off(()=> UserOrProvider());
  }

  static openUserLogin(){
    Get.to(()=> user_login());
  }

  static openUserRegistration(){
    Get.to(()=> register());
  }
  
  static openDocList(){
    Get.to(()=> DocList());
  }

  static openNurseList(){
    Get.to(()=> NurseList());
  }

  static openPhysioList(){
    Get.to(()=> PhysioList());
  }

  static openLabList(){
    Get.to(()=> LabList());
  }

  static openUserProfile({required String id}){
    Get.to(()=> UserProfile(studentId:id,));
  }

  static openUserUpdate(String id,name,email,address,mobile){
    Get.to(()=> UserUpdate(id: id, name: name, email: email, address: address, mobile: mobile));
  }

  static openUserCompletedAppintements({required String id}){
    Get.to(()=> UserCompletedAppointments(userId: id));
  }

  static openCancelledappointements({required String id}){
    Get.to(()=> UserCancelledAppointments(userId: id));
  }

  static openAbotus(){
    Get.to(()=> AboutUsPage());
  }

  static openDocBookAppointment({required String id}){
    Get.to(()=> BookAppointment(docId: id));
  }

  static openDocIndividualProfile({required String id}){
    Get.to(()=> DocIndividualProfile(docId: id));
  }

  static openLabBookappointment({required String id}){
    Get.to(()=> LabBookAppointment(labId: id));
  }

  static openLabIndividualProfile({required String id}){
    Get.to(()=> LabIndividualProfile(labId: id));
  }

  static openNurseIndividualProfile({required String id}){
    Get.to(()=> NurseIndividualProfile(nurseId: id));
  }

  static openNurseBookAppointment({required String id}){
    Get.to(()=> NurseBookAppointment(nurseId: id));
  }

  static openPhysioBookAppointment({required String id}){
    Get.to(()=> PhysioBookAppointment(physiotherapistId: id));
  }

  static openPhysioIndividualProfile({required String id}){
    Get.to(()=> PhysioIndividualProfile(physiotherapistId: id));
  }

  // routes for Provider part

  static gobackProviderHome(){
    Get.off(()=> ProviderHome());
  }

  static openProviderHome(){
    Get.off(()=> ProviderHome());
  }

  static goSelectCategory(){
    Get.to(()=> select_category());
  }
  
  static openProviderLogin(){
    Get.to(()=> providerLogin());
  }

  static openScheduleAppointment(){
    Get.to(()=> ScheduleAppointment());
  }

  static openProviderViewAppointmentList({required String id,required String proftype}){
    Get.to(()=> ProviderViewAppointmentList(profId: id, proftype: proftype,));
  }

  static openRejectedappointment({required String id,proftype}){
    Get.to(()=> RejectedAppointments(profId: id, proftype: proftype));
  }

  static openCompletedAppointments({required String id,required String proftype}){
    Get.to(()=> CompletedAppointments(profId: id, proftype: proftype));
  }

  static openDocResgistration(){
    Get.to(()=> doc_registration());
  }

  static openNurseRegistration(){
    Get.to(()=> NurseRegistration());
  }

  static openLabRegistration(){
    Get.to(()=> lab_registration());
  }

  static openPhysioRegistration(){
    Get.to(()=> PhysioRegistration());
  }
}