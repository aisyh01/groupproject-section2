// AISYAH BINTI AHMAD 2017484
// NUR FARAAYUNI SUFEA BINTI MOHD SUPIAN 2015002
// NUR SYAZWANA BINTI TAJUDDIN 2011242


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

const String apiKey = '60e49a0976a942f191273350232206';
const String baseUrl = 'https://api.weatherapi.com/v1';

class WeatherData {
  final String location;
  final double temperature;
  final String condition;
  final String iconUrl;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });
}


class ForecastData {
  final String location;
  final String date;
  final double temperature;
  final String condition;
  final String iconUrl;

  ForecastData({
    required this.location,
    required this.date,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/detail': (context) => WeatherDetailPage(location: ''),
        '/forecast': (context) => ForecastPage(location: ''),
        '/invalid': (context) => InvalidPage(),
      },
    );
  }
}

//--------------------------------WELCOME PAGE----------------------------
class WelcomePage extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();

  String description = ' Search Any Location';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Discover the Weather in Your City',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'eg. Los Angeles',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 30),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherDetailPage(
                            location: locationController.text,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 9, 53, 28),
                    ),
                    child: Text('Search Location'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForecastPage(
                            location: locationController.text,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 9, 53, 28),
                    ),
                    child: Text('Forecast'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//--------------------------------WEATHER DETAILS PAGE----------------------------
class WeatherDetailPage extends StatefulWidget {
  final String location;

  WeatherDetailPage({required this.location});

  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  WeatherData? _weatherData;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      final url =
          Uri.parse('$baseUrl/current.json?key=$apiKey&q=${widget.location}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);

      setState(() {
        _weatherData = WeatherData(
          location: jsonData['location']['name'],
          temperature: double.parse(jsonData['current']['temp_c'].toString()),
          condition: jsonData['current']['condition']['text'],
          iconUrl: 'https:${jsonData['current']['condition']['icon']}',
        );
      });

      } else {
        Navigator.pushReplacementNamed(context, '/invalid');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/cloud.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: _weatherData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Todays Report',
                    style: TextStyle(
                      fontSize: 30, 
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.8),
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Image.network('${_weatherData!.iconUrl}',
                  height: 100,
                  width: 100,
                  ),
                  Text(
                    'Location: ${_weatherData!.location}',
                    style: TextStyle(fontSize: 20, color: Colors.black, height: 2),
                  ),
                  Text(
                    'Temperature: ${_weatherData!.temperature}°C',
                    style: TextStyle(fontSize: 20, color: Colors.black, height: 2),
                  ),
                  Text(
                    'Condition: ${_weatherData!.condition}',
                    style: TextStyle(fontSize: 19, color: Colors.black, height: 2),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 241, 160, 212),
                      foregroundColor: Colors.black,  
                    ),
                    child: Text('Back',),
                  ),
                ],
              )
            : Text(
                _errorMessage.isNotEmpty ? _errorMessage : 'Loading...',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
      ),
    );
  }
}

//--------------------------------FORECAST PAGE----------------------------
class ForecastPage extends StatefulWidget {
  final String location;

  ForecastPage({required this.location});

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  List<ForecastData>? _forecastList;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchForecastData();
  }

  Future<void> fetchForecastData() async {
    try {
      final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=${widget.location}&days=7');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final forecastList = jsonData['forecast']['forecastday'] as List<dynamic>;

        setState(() {
          _forecastList = forecastList.map((data) {
            return ForecastData(
              location: jsonData['location']['name'],
              date: data['date'],
              temperature: double.parse(data['day']['avgtemp_c'].toString()),
              condition: data['day']['condition']['text'],
              iconUrl: 'https:${data['day']['condition']['icon']}',

            );
          }).toList();
        });
      } else {
        Navigator.pushReplacementNamed(context, '/invalid');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/cloud.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: _forecastList != null && _forecastList!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '7-Day Forecast for ${_forecastList![0].location}:',
                    style: TextStyle(
                      fontSize: 20, 
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.8),
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Temperature',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Condition',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: _forecastList!.map((forecast) {
                      return DataRow(cells: [
                        DataCell(Text(forecast.date)),
                        DataCell(Text('${forecast.temperature}°C')),
                        DataCell(Image.network('${forecast.iconUrl}',
                        height: 45,
                        width: 45,
                  ),)
                      ]);
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 241, 160, 212),
                      foregroundColor: Colors.black,  
                    ),
                    child: Text('Back'),
                  ),
                ],
              )
            : Text(
                _errorMessage.isNotEmpty ? _errorMessage : 'Loading...',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
      ),
    );
  }
}


//--------------------------------INVALID PAGE----------------------------
class InvalidPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/bowing.gif",
            height: 180.0,
            width: 180.0,
            ),
            SizedBox(height: 16.0),
            Text('Oops! Something went wrong!', 
            style: TextStyle(
              fontSize: 25, 
              color: Colors.black)
              ),
            Text('Wrong city name', 
            style: TextStyle(
              fontStyle: FontStyle.italic, 
              fontSize: 18, 
              color: Colors.red)
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
