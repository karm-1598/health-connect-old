
import 'package:get/get.dart';
import 'package:health_connect2/about_us.dart';
import 'package:health_connect2/book_appointment.dart';
import 'package:health_connect2/completed_appointments.dart';
import 'package:health_connect2/doc_individual_profile.dart';
import 'package:health_connect2/doctor_list.dart';
import 'package:health_connect2/doctor_registration.dart';
import 'package:health_connect2/home.dart';
import 'package:health_connect2/lab+individual_profile.dart';
import 'package:health_connect2/lab_book_appointment.dart';
import 'package:health_connect2/lab_list.dart';
import 'package:health_connect2/lab_registration.dart';
import 'package:health_connect2/nurse_book_appointment.dart';
import 'package:health_connect2/nurse_individual_profile.dart';
import 'package:health_connect2/nurse_list.dart';
import 'package:health_connect2/nurse_registration.dart';
import 'package:health_connect2/physio_book_appointment.dart';
import 'package:health_connect2/physio_individual_profile.dart';
import 'package:health_connect2/physio_list.dart';
import 'package:health_connect2/physio_registration.dart';
import 'package:health_connect2/provider_home.dart';
import 'package:health_connect2/provider_login.dart';
import 'package:health_connect2/provider_view_appointment_list.dart';
import 'package:health_connect2/rejected_appointments.dart';
import 'package:health_connect2/schedual_appointment.dart';
import 'package:health_connect2/user_cancelled_appointments.dart';
import 'package:health_connect2/user_completed_appointments.dart';
import 'package:health_connect2/user_login.dart';
import 'package:health_connect2/user_or_provider.dart';
import 'package:health_connect2/user_profile.dart';

class goto{
  static Transition transition = Transition.circularReveal;
  static Duration duration = const Duration(milliseconds: 500);

  static gobackHome(){
    Get.off(home_screen());
  }

  static openhome_screen(){
    Get.to(home_screen());
  }

  static openUserOrProvider(){
    Get.to(UserOrProvider());
  }

  static openUserLogin(){
    Get.to(user_login());
  }
  
  static openDocList(){
    Get.to(DocList());
  }

  static openNurseList(){
    Get.to(NurseList());
  }

  static openPhysioList(){
    Get.to(PhysioList());
  }

  static openLabList(){
    Get.to(LabList());
  }

  static openUserProfile({required String id}){
    Get.to(UserProfile(studentId:id,));
  }

  static openUserCompletedAppintements({required String id}){
    Get.to(UserCompletedAppointments(userId: id));
  }

  static openCancelledappointements({required String id}){
    Get.to(UserCancelledAppointments(userId: id));
  }

  static openAbotus(){
    Get.to(AboutUsPage());
  }

  static openDocBookAppointment({required String id}){
    Get.to(BookAppointment(docId: id));
  }

  static openDocIndividualProfile({required String id}){
    Get.to(DocIndividualProfile(docId: id));
  }

  static openLabBookappointment({required String id}){
    Get.to(LabBookAppointment(labId: id));
  }

  static openLabIndividualProfile({required String id}){
    Get.to(LabIndividualProfile(labId: id));
  }

  static openNurseIndividualProfile({required String id}){
    Get.to(NurseIndividualProfile(nurseId: id));
  }

  static openNurseBookAppointment({required String id}){
    Get.to(NurseBookAppointment(nurseId: id));
  }

  static openPhysioBookAppointment({required String id}){
    Get.to(PhysioBookAppointment(physiotherapistId: id));
  }

  static openPhysioIndividualProfile({required String id}){
    Get.to(PhysioIndividualProfile(physiotherapistId: id));
  }

  // routes for Provider part

  static gobackProviderHome(){
    Get.off(ProviderHome());
  }

  static openProviderHome(){
    Get.to(ProviderHome());
  }
  
  static openProviderLogin(){
    Get.to(providerLogin());
  }

  static openScheduleAppointment(){
    Get.to(ScheduleAppointment());
  }

  static openProviderViewAppointmentList({required String id,required String proftype}){
    Get.to(ProviderViewAppointmentList(profId: id, proftype: proftype,));
  }

  static openRejectedappointment({required String id,proftype}){
    Get.to(RejectedAppointments(profId: id, proftype: proftype));
  }

  static openCompletedAppointments({required String id,required String proftype}){
    Get.to(CompletedAppointments(profId: id, proftype: proftype));
  }

  static openDocResgistration(){
    Get.to(doc_registration());
  }

  static openNurseRegistration(){
    Get.to(NurseRegistration());
  }

  static openLabRegistration(){
    Get.to(lab_registration());
  }

  static openPhysioRegistration(){
    Get.to(PhysioRegistration());
  }
}