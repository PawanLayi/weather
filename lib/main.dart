import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherProvider>(create: (_) => WeatherProvider()),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WeatherScreen(),
      ),
    );
  }
}

class WeatherService {
  final String apiKey = 'faa242e4eab81c4aee7f85c72e22b0ce';
  late WeatherFactory _weatherFactory;

  WeatherService() {
    _weatherFactory = WeatherFactory(apiKey);
  }

  Future<Weather> fetchWeather(String cityName) async {

    return await _weatherFactory.currentWeatherByCityName(cityName);
  }
}

class WeatherProvider with ChangeNotifier {
  WeatherService _weatherService = WeatherService();
  Weather? _weather;

  Weather? get weather => _weather;
   ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dataFound(context){
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("City Not Found ")));;

  }
  Future<void> fetchWeather(String cityName,context) async {
    try {
      _weather = await _weatherService.fetchWeather(cityName);
      notifyListeners();
    } catch (e) {
      // Show toast notification with the error message
      dataFound(context);
    }
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  List<Widget>  locationTempImage(double temp){
    List<Widget> imageUi=[];
    if(temp>35.00){
      imageUi.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height : MediaQuery.of(context).size.height*.2,
            width: MediaQuery.of(context).size.width*.40,
            child: Image.asset("assets/max-temp.png",fit: BoxFit.fitWidth)),
      ));
    }
    else if(temp<30.00){
      imageUi.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height : MediaQuery.of(context).size.height*.2,
            width: MediaQuery.of(context).size.width*.40,
            child: Image.asset("assets/lightrain.png",fit: BoxFit.fitWidth)),
      ));
    }
    else if(temp<20.00){
      imageUi.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height : MediaQuery.of(context).size.height*.2,
            width: MediaQuery.of(context).size.width*.40,
            child: Image.asset("assets/heavyrain.png",fit: BoxFit.fitWidth)),
      ));
    }
    else{
      imageUi.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height : MediaQuery.of(context).size.height*.2,
            width: MediaQuery.of(context).size.width*.40,
            child: Image.asset("assets/heavycloud.png",fit: BoxFit.fitWidth)),
      ));
    }
    return imageUi;

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.weather;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             SizedBox(
              height: MediaQuery.of(context).size.height*.60,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height*.23,
                      width: MediaQuery.of(context).size.width*.99,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50),
                          )),
                      child:Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.center,
                                colors: [
                                  Color(0xffa9c1f5),
                                  Color(0xff6696f5),
                                ]),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(.1),
                                offset: const Offset(0, 25),
                                blurRadius: 3,
                                spreadRadius: -10,
                              ),
                            ]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              weather == null ? Text('Add city',style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = const LinearGradient(
                                    colors: <Color>[
                                      Colors.pinkAccent,
                                      Colors.deepPurpleAccent,
                                      Colors.red
                                      //add more color here.
                                    ],
                                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                              ))
                                  :   SizedBox(
                                width: MediaQuery.of(context).size.width*.40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(weather!.areaName.toString(),style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()..shader = const LinearGradient(
                                            colors: <Color>[
                                              Colors.pinkAccent,
                                              Colors.deepPurpleAccent,
                                              Colors.red
                                              //add more color here.
                                            ],
                                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                                      )),
                                    ),
                                    Text(
                                      ' T ${weather?.temperature?.celsius?.toStringAsFixed(1)}°C',
                                      style: const TextStyle(fontSize: 24),
                                    ),

                                  ],
                                ),
                              ) ,
                              weather != null ?Column(
                                children: locationTempImage(weather!.temperature!.celsius!),
                                // children: locationTempImage(20.00),
                              ):
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height : MediaQuery.of(context).size.height*.2,
                                    width: MediaQuery.of(context).size.width*.40,
                                    child: Image.asset("assets/heavycloud.png",fit: BoxFit.fitWidth)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height:  150,
                      width: size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50),
                          )),
                      child:Container(
                        width: size.width * .7,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.center,
                                colors: [
                                  Color(0xffa9c1f5),
                                  Color(0xff6696f5),
                                ]),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(.1),
                                offset: const Offset(0, 25),
                                blurRadius: 3,
                                spreadRadius: -10,
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            width: size.width * .8,
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                weatherItem(
                                  text: 'Wind Speed',
                                  value: "${weather != null ?weather?.windSpeed:""} m/s",
                                  unit: 'km/h',
                                  imageUrl: 'assets/windspeed.png',
                                ),
                                weatherItem(
                                    text: 'Humidity',
                                    value:"${weather != null ?weather?.humidity:""}%",
                                    unit: '',
                                    imageUrl: 'assets/humidity.png'),
                                weatherItem(
                                  text: 'Max Temp',
                                  value:  "${weather != null ?weather?.tempMax?.celsius?.toStringAsFixed(1):""}°C",
                                  unit: 'C',
                                  imageUrl: 'assets/max-temp.png',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _cityController,
                style: const TextStyle(
                  color: Colors.deepPurpleAccent,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter city Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                weatherProvider.fetchWeather(_cityController.text,context);
              },
              child: const Text('Get Weather'),
            ),
          ],
        ),
      ),
    );
  }
}

class weatherItem extends StatelessWidget {
  const weatherItem({
    Key? key,
    required this.value, required this.text, required this.unit, required this.imageUrl,
  }) : super(key: key);

  final  String ?value;
  final String ?text;
  final String? unit;
  final String ?imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text!, style: const TextStyle(
          color: Colors.black54,
        ),),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Color(0xffE0E8FB),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(imageUrl!),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(value.toString() + unit!, style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),)
      ],
    );
  }
}