import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key)
  ;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {

  List <dynamic> _resources = [];

  @override
  void initState(){
    super.initState();
    _fetchResources();
  }

  void _fetchResources() async {
    final response = await http.get(Uri.parse('https://api.sampleapis.com/codingresources/codingResources'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)as List;
      setState(() {
        _resources = data;
      });
    } else{
      throw Exception('Failed to load resources');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
      ),
      body: _resources.isEmpty
      ?  const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _resources.length,
        itemBuilder: (context, index){
          final resource = _resources[index];
          return InkWell(
            onTap: () => {_launchURL(resource['url'])},
            child: Card(
              child: ListTile(
                title: Text(resource['description']),
                subtitle: Text(resource['url']),
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1547721064-da6cfb341d50"
                  ),
                ),
                trailing: Text(resource['types'].join(', ')),
              ),
            ),
          );
        },
      )

    );
  }
}
