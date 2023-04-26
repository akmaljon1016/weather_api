import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_api/Weather.dart';

void main() {
  runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<Weather> weatherData;

  Future<Weather> getWeather() async {
    Dio dio = Dio();
    var response = await dio.get(
        "https://api.weatherapi.com/v1/forecast.json?key=acb4a4de25aa41b784651422200510&q=Margilan");
    print(response.data);
    return Weather.fromJson(response.data);
  }

  @override
  void initState() {
    weatherData = getWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ob Havo"),
      ),
      body: FutureBuilder(
          future: weatherData,
          builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
            if(snapshot.hasData){
              return Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        Image.network(
                            snapshot.data?.current?.condition?.icon ?? ""),
                        Text(snapshot.data?.current?.tempC.toString() ?? ""),
                      ],
                    ),
                  )
              );
            }
            else{
              return Center(child: CupertinoActivityIndicator(radius: 50,color: Colors.black,));
            }
          }),
    );
  }
}
