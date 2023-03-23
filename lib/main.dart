import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _contactList = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  _loadContacts() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=100'));
    if (response.statusCode == 200) {
      setState(() {
        _contactList = json.decode(response.body)['results'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'รายชื่อผู้ติดต่อ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('รายชื่อผู้ติดต่อ'),
        ),
        body: ListView.builder(
          itemCount: _contactList.length,
          itemBuilder: (BuildContext context, int index) {
            final contact = _contactList[index];
            return SizedBox(
              height: 90,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(contact['picture']['large']),
                ),
                // leading: Image.network(contact['picture']['large']),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${contact['name']['first']} ${contact['name']['last']}'),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${contact['phone']}'),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('${contact['email']}')
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactDetail(contact: contact)),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContactDetail extends StatelessWidget {
  final dynamic contact;

  const ContactDetail({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('ข้อมูลผู้ติดต่อ'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(contact['picture']['large']),
                  radius: 60.0,
                ),
                const SizedBox(height: 20.0),
                Text(
                  '${contact['name']['first']} ${contact['name']['last']}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          ListTile(
            title: Row(
              children: [
                const Text('เบอร์โทรศัพท์'),
                const SizedBox(
                  width: 10,
                ),
                Text(contact['phone'])
              ],
            ),
            // subtitle: Text(contact['phone']),
          ),
          ListTile(
            title: Row(
              children: [
                const Text('อีเมล'),
                const SizedBox(
                  width: 10,
                ),
                Text(contact['email'])
              ],
            ),
            // subtitle: Text(contact['phone']),
          ),
        ],
      ),
    );
  }
}
