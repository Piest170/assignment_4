import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(AssignmentApp4());
}

class AssignmentApp4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Covid-19 Information'),
              centerTitle: true,
            ),
            backgroundColor: Colors.blue[200],
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/Covid19-Viruses.jpg'),
                      fit: BoxFit.cover)),
              child: Display(),
            )));
  }
}

Future<Covid19> fetchCovid19() async {
  final response = await http.get(
      Uri.parse('https://static.easysunday.com/covid-19/getTodayCases.json'));

  if (response.statusCode == 200) {
    return Covid19.formJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get Data!');
  }
}

class Covid19 {
  final String country;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int todayRecovered;
  final int hospitalized;
  final int newHospitalized;
  final String updateDate;

  Covid19(
      {required this.country,
      required this.cases,
      required this.todayCases,
      required this.deaths,
      required this.todayDeaths,
      required this.recovered,
      required this.todayRecovered,
      required this.hospitalized,
      required this.newHospitalized,
      required this.updateDate});

  factory Covid19.formJson(Map<String, dynamic> json) {
    return Covid19(
        country: json['country'],
        cases: json['cases'],
        todayCases: json['todayCases'],
        deaths: json['deaths'],
        todayDeaths: json['todayDeaths'],
        recovered: json['recovered'],
        todayRecovered: json['todayRecovered'],
        hospitalized: json['Hospitalized'],
        newHospitalized: json['NewHospitalized'],
        updateDate: json['UpdateDate']);
  }
}

class Display extends StatefulWidget {
  const Display({Key? key}) : super(key: key);

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  late Future<Covid19> information;

  @override
  void initState() {
    super.initState();
    information = fetchCovid19();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<Covid19>(
            future: information,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        color: Colors.green[600],
                        alignment: Alignment.topRight,
                        child: Text(
                          'Recent Update ' + snapshot.data!.updateDate,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 25),
                      Column(
                        children: <Widget>[
                          Image.asset(
                            'images/thailand-flag.png',
                            width: 200,
                            height: 150,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                            child: Text(snapshot.data!.country,
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white ,fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(80),
                            child: ElevatedButton(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(Icons.search),
                                      const Text(
                                        'View Information',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ]),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue[200]),
                                      margin: EdgeInsets.all(10),
                                      child: Table(
                                        border: TableBorder.all(),
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text('รายการ',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text('ยอดรวมวันนี้',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text('ยอดรวมทั้งหมด',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              )
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text('ผู้ติดเชื้อ',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.todayCases}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.cases}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text('ผู้เสียชีวิต',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.todayDeaths}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.deaths}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    'ผู้ที่อยู่ระหว่างการรักษา',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.newHospitalized}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.hospitalized}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    'ผู้ที่รักษาหายแล้ว',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.todayRecovered}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Text(
                                                    '${snapshot.data!.recovered}',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }));
  }
}
