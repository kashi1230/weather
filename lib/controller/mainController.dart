
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:whether/Services/api_services.dart';

class  MainController extends GetxController{
  @override
  void onInit() async{
    await getUserLocation();
    currentweatherdata = getCurrentWeather(lattitude.value , longitude.value);
    hourleywetherdata = gethourleyweather(lattitude.value, longitude.value);
    super.onInit();
  }

  var isdark = false.obs;
  var currentweatherdata;
  var hourleywetherdata;
  var lattitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isloaded = false.obs;

  changeTheme(){
    isdark.value = !isdark.value;
    Get.changeThemeMode(isdark.value ? ThemeMode.dark : ThemeMode.light);

  }

  getUserLocation() async {
    bool isLocationEnable ;
    LocationPermission userPermission;

    isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnable){
      return Future.error("Please Enable Your Location");
    }
    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.deniedForever){
      return Future.error("Permission Denied Forever");
    }else if (userPermission == LocationPermission.denied){
      userPermission = await Geolocator.requestPermission();
      if(userPermission == LocationPermission.denied){
        return Future.error("Permission is denied");
      }
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value){
      lattitude.value = value.latitude;
      longitude.value = value.longitude;
      isloaded.value = true;
    });

  }

}