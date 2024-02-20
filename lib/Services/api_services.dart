import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whether/const/strings.dart';
import 'package:whether/modules/currentWhetherData.dart';
import 'package:whether/modules/hourleyweathermodel.dart';

Future<CurrentWhetherData> getCurrentWeather(lat , long) async{
  var link = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$apiKey&units=metric";
   final response = await http.get(Uri.parse(link));
   var data = jsonDecode(response.body);
   if(response.statusCode == 200){
     return CurrentWhetherData.fromJson(data);
   }else{
     return CurrentWhetherData.fromJson(data);
   }
}

Future<HorleyWatherdata> gethourleyweather(lat , long) async {
  var horleylink = "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=$apiKey&units=metric";
 final respone = await http.get(Uri.parse(horleylink));
 var data = jsonDecode(respone.body.toString());
 if(respone.statusCode == 200){
   return HorleyWatherdata.fromJson(data);
 }else{
 return HorleyWatherdata.fromJson(data);
 }

}
