import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_api/Weather.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Weather> weatherData;

  String city = "Margilan";

  Future<Weather> getWeather(String city) async {
    Dio dio = Dio();
    var response = await dio.get(
        "https://api.weatherapi.com/v1/forecast.json?key=acb4a4de25aa41b784651422200510&q=${city}&days=3");
    print(response.data);
    return Weather.fromJson(response.data);
  }

  @override
  void initState() {
    weatherData = getWeather(city);
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Ob Havo"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    label: Text("shaharni kiriting..."),
                    border: OutlineInputBorder()),
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  weatherData = getWeather(searchController.value.text);
                });
              },
              child: Text(
                "Search",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.green,
            ),
            SizedBox(
              height: 100,
            ),
            FutureBuilder(
                future: weatherData,
                builder:
                    (BuildContext context, AsyncSnapshot<Weather> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Image.network(
                                  "https:${snapshot.data?.current?.condition?.icon}" ??
                                      ""),
                              Text(snapshot.data?.current?.tempC.toString() ??
                                  ""),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          height: 100,
                          child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.all(5),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Image.network(
                                        "https:${snapshot.data?.forecast?.forecastday?[index].day?.condition?.icon}" ??
                                            ""),
                                    Text(snapshot.data?.forecast
                                            ?.forecastday?[index].day?.avgtempC
                                            .toString() ??
                                        ""),
                                  ],
                                ),
                              );
                            },
                            itemCount:
                                snapshot.data?.forecast?.forecastday?.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(
                        child: CupertinoActivityIndicator(
                      radius: 50,
                      color: Colors.black,
                    ));
                  }
                }),
          ],
        ));
  }
}
