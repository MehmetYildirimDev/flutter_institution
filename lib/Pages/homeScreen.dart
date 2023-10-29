import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_institutions_testcase/Pages/detailsScreen.dart';
import 'package:flutter_institutions_testcase/model/institution.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String connectionStatus = 'unknown';
  String searchText = "";
  late final Future<List<Institution>> _institutionList;
  List<Institution> filteredItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _searchField(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Institutions',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: _listViewBuilder(),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _institutionList = _getInstitutionList();
  }

  FutureBuilder<List<Institution>> _listViewBuilder() {
    return FutureBuilder<List<Institution>>(
      future: _institutionList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (!snapshot.hasData) {
          return const Text('Datas Uploading...');
        } else {
          var institutionList = snapshot.data!;
          var items = searchText == ""
              ? (institutionList)
              : (filteredItems.isNotEmpty ? filteredItems : []);
          return ListView.builder(
            itemBuilder: (context, index) {
              var institution = items[index];
              return Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade200,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Text(
                      institution.title.toString(),
                      textAlign: TextAlign.left,
                    ),
                    subtitle: Text(institution.email.toString()),
                    leading: const Icon(
                      Icons.apartment,
                      size: 30,
                      color: Colors.deepOrange,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepOrange,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (redContext) => detailsScreen(institution),
                          ));
                    },
                  ),
                ),
              );
            },
            itemCount: items.length,
          );
        }
      },
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        onChanged: (value) {
          _runFilter(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/icons/Search.svg'),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          hintText: "Search...",
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Institution App',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
  }

  Future<List<Institution>> _getInstitutionList() async {
    try {
      var response = await Dio().get(
          'https://gist.githubusercontent.com/berkanaslan/35511991222bfc0914cd4c2c031057e2/raw/');
      List<Institution> institutionList = [];
      if (response.statusCode == 200) {
        String jsonVeriler = response.data;
        List<dynamic> jsonData = json.decode(jsonVeriler);
        institutionList = jsonData.map((e) => Institution.fromMap(e)).toList();
      }
      return institutionList;
    } on DioError catch (e) {
      return Future.error(e.message);
    }
  }

  void _runFilter(String value) {
    searchText = value.toString();
    final items = _institutionList;
    items.then((institutionList) {
      setState(() {
        filteredItems = institutionList
            .where((item) =>
                item.title.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    });
  }

  Future<void> initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = 'There is mobile internet';
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = 'There is Wi-Fi internet';
      });
    } else {
      setState(() {
        connectionStatus = 'There is not internet';
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Network Error'),
              content: Text('Internet is not available'),
            );
          },
        );
      });
    }
  }
}
