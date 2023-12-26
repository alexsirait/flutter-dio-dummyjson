import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DioProjectPage extends StatefulWidget {
  const DioProjectPage({Key? key}) : super(key: key);

  @override
  _DioProjectPageState createState() => _DioProjectPageState();
}

class _DioProjectPageState extends State<DioProjectPage> {
  final Dio dio = Dio();
  String url = 'https://dummyjson.com';
  List data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await dioGet();
    await dioPost();
    await dioUpdate();
    await dioDelete();
  }

  Future<void> dioGet() async {
    try {
      final response = await dio.get('$url/products');
      if (response.statusCode == 200) {
        setState(() {
          data = response.data['products'];
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> dioPost() async {
    try {
      final response = await dio.post('$url/products/add',
          data: {'title': 'BMW Pencil'},
          options: Options(contentType: Headers.jsonContentType));
      print(response.data);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> dioUpdate() async {
    try {
      final response = await dio.put('$url/products/1',
          data: {'title': 'BMW Pencil'},
          options: Options(contentType: Headers.jsonContentType));
      print(response.data);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> dioDelete() async {
    try {
      final response = await dio.delete('$url/products/1');
      print(response.data);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Project'),
      ),
      body: FutureBuilder<void>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Text(data[index]['title']),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
