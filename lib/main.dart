
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:whether/const/Colors.dart';
import 'package:whether/const/images.dart';
import 'package:whether/const/strings.dart';
import 'package:whether/controller/mainController.dart';
import 'package:whether/modules/currentWhetherData.dart';
import 'package:whether/modules/hourleyweathermodel.dart';
import 'package:whether/ourthemes.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: CustomThemes.lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: CustomThemes.darkTheme,
      home: const WeatherApp(),
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {


    var theme = Theme.of(context);
    var date = DateFormat('_EEE'"_""MMM_y_").format(DateTime.now());
    var controller = Get.put(MainController());


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: date.text.color(theme.primaryColor).make(),
        backgroundColor: Colors.transparent,
        elevation: 1,
        actions: [
          Obx(
          ()=> IconButton(
                onPressed: (){
                  controller.changeTheme();
                },
                icon:  Icon(controller.isdark.value ? Icons.light_mode : Icons.dark_mode, color: theme.iconTheme.color,
            )),
          ),
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_vert,
                color: theme.iconTheme.color,
              ))
        ],
      ),
      body: Obx(()=>
        controller.isloaded.value == true ?
        Container(
          padding: const EdgeInsets.all(12),
            child: FutureBuilder<CurrentWhetherData>(
              future: controller.currentweatherdata,
              builder: (BuildContext context, AsyncSnapshot<CurrentWhetherData> snapshot){
                if(snapshot.hasData){
                  // CurrentWhetherData data = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "${snapshot.data!.name}""$degree".text.uppercase.fontFamily("poppins_bold").size(32).color(theme.primaryColor).letterSpacing(3).make(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/wather/${snapshot.data!.weather![0].icon}.png",
                              height: 80,
                              width: 80,
                            ),
                            RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "${snapshot.data!.main!.temp}$degree",
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 40,
                                          fontFamily: 'poppins'
                                      )
                                  ),
                                  TextSpan(
                                      text: "${snapshot.data!.weather![0].main}",
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          letterSpacing: 3,
                                          fontSize: 14,
                                          fontFamily: 'poppins'
                                      )
                                  )
                                ]
                            ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.expand_less_rounded,color: theme.iconTheme.color),
                                label: "${snapshot.data!.main!.tempMax}$degree".text.color(theme.iconTheme.color).make()
                            ),
                            TextButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.expand_more_rounded,color: theme.iconTheme.color),
                                label: "${snapshot.data!.main!.tempMin}$degree".text.color(theme.iconTheme.color).make()
                            )
                          ],
                        ),
                        10.heightBox,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:List.generate(
                                3, (index){
                              var iconlist = [clouds,humidity,windspeed];
                              var values = ["${snapshot.data!.clouds!.all}" ," ${snapshot.data!.main!.humidity}" ," ${snapshot.data!.wind!.speed} km/h",];
                              return Column(
                                  children: [
                                    Image.asset(
                                        iconlist[index],width: 60,height: 60
                                    ).box.
                                    padding(const EdgeInsets.all(8)).
                                    gray200.rounded.
                                    make(),
                                    10.heightBox,
                                    values[index].text.color(theme.primaryColor).make()
                                  ]
                              );
                            }
                            )),
                        10.heightBox,
                        const Divider(),
                        10.heightBox,
                        FutureBuilder<HorleyWatherdata>(
                            future:controller.hourleywetherdata,
                            builder: (BuildContext context ,AsyncSnapshot<HorleyWatherdata>  snapshot){
                              if(snapshot.hasData){
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.list.length > 6 ? 6 : snapshot.data!.list.length,
                                      itemBuilder: (BuildContext , int index){
                                         var time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.data!.list[index].dt*1000));
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                            color: dividerColor,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                               time.text.color(theme.primaryColor).make(),
                                              Image.asset(
                                                "assets/wather/${snapshot.data!.list[index].weather[0].icon}.png",width: 80,
                                              ),
                                              "${snapshot.data!.list[index].main.temp}$degree".text.color(theme.primaryColor).make(),
                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                );
                              }else{
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                        ),



                        10.heightBox,
                        const Divider(),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Next 7 Days".text.color(theme.primaryColor).size(16).make(),
                            TextButton(
                              onPressed: (){},
                              child: "View All".text.color(theme.primaryColor).make(),

                            )
                          ],
                        ),

                        FutureBuilder <HorleyWatherdata>(
                            future: controller.hourleywetherdata,
                            builder:(BuildContext ,AsyncSnapshot<HorleyWatherdata>snapshot){
                              if(snapshot.hasData){
                                return  ListView.builder(
                                    itemCount:snapshot.data!.list.length > 6 ? 6 : snapshot.data!.list.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext , int index){
                                      var day = DateFormat("EEEE").format(DateTime.now().add(Duration(days: index +1)));
                                      return Card(
                                        color: theme.cardColor,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(child: day.text.color(theme.primaryColor).make()),
                                              Expanded(
                                                child: TextButton.icon(
                                                    onPressed: null,
                                                    icon:  Image.asset("assets/wather/${snapshot.data!.list[0].weather[0].icon}.png",width: 40),
                                                    label: "${snapshot.data!.list[index].main.temp}$degree".text.color(theme.primaryColor).make()),
                                              ),
                                              RichText(
                                                  text:TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: "${snapshot.data!.list[index].main.tempMin}$degree/",
                                                            style: TextStyle(
                                                                color: theme.primaryColor,
                                                                fontFamily: "poppins",
                                                                fontSize: 16
                                                            )
                                                        ),
                                                        TextSpan(
                                                            text: "${snapshot.data!.list[index].main.tempMax}$degree",
                                                            style: TextStyle(
                                                                fontFamily: "poppins",
                                                                color: theme.iconTheme.color,
                                                                fontSize: 16
                                                            )
                                                        )
                                                      ]
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                              }
                              else{
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                        )
                      ],
                    ),
                  );

                }else{
                  return const Center(child : CircularProgressIndicator());
                }

              },
            )
            )
            : const Center(child: CircularProgressIndicator())
      ),);
  }
}

