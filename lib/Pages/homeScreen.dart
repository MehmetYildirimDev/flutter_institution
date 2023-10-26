import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_institutions_testcase/Pages/detailsScreen.dart';
import 'package:flutter_institutions_testcase/model/institution.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String connectionStatus = 'Bilinmiyor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
                decoration: const InputDecoration(
                  hintText: "Search...",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder<List<Institution>>(
                  future: _institutionList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (!snapshot.hasData) {
                      return const Text('Veriler yükleniyor...');
                    } else {
                      var institutionList = snapshot.data!;
                      var items = searchText == ""
                          ? (institutionList)
                          : (filteredItems.isNotEmpty ? filteredItems : []);
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          var institution = items[index];
                          return ListTile(
                            title: Text(institution.title.toString()),
                            subtitle: Text(institution.email.toString()),
                            leading: Text(institution.code.toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      detailsScreen(institution),
                                ),
                              );
                            },
                          );
                        },
                        itemCount: items.length,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<List<Institution>> _getKamuKurumList() async {
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

  late final Future<List<Institution>> _institutionList;
  String searchText = "";
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _institutionList = _getKamuKurumList();
  }

  List<Institution> filteredItems = [];

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

// Bağlantıyı kontrol etmek için bu fonksiyonu kullanabilirsiniz.
  Future<void> initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectionStatus = 'Mobil İnternet Var';
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connectionStatus = 'Wi-Fi İnternet Var';
      });
    } else {
      setState(() {
        connectionStatus = 'İnternet Yok';
        // İnternet yoksa burada kullanıcıya hata mesajını gösterebilirsiniz.
      });
    }
    debugPrint(connectionStatus.toString());
  }
}
