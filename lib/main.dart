import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Negara',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CountryListPage(),
    );
  }
}

class Country {
  String code;
  String name;
  String description;
  String flagUrl;

  Country({
    required this.code,
    required this.name,
    required this.description,
    required this.flagUrl,
  });
}

class CountryListPage extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  List<Country> countries = [
    Country(
      code: 'ID',
      name: 'Indonesia',
      description: 'Negara kepulauan terbesar di dunia.',
      flagUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Flag_of_Indonesia.svg/1280px-Flag_of_Indonesia.svg.png',
    ),
    Country(
      code: 'US',
      name: 'Amerika Serikat',
      description: 'Negara dengan ekonomi terbesar di dunia.',
      flagUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1920px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png',
    ),
  ];

  void _addCountry(Country country) {
    setState(() {
      countries.add(country);
    });
  }

  void _editCountry(int index, Country updatedCountry) {
    setState(() {
      countries[index] = updatedCountry;
    });
  }

  void _deleteCountry(int index) {
    setState(() {
      countries.removeAt(index);
    });
  }

  void _showCountryForm({Country? country, int? index}) {
    final codeController = TextEditingController(text: country?.code);
    final nameController = TextEditingController(text: country?.name);
    final descriptionController = TextEditingController(text: country?.description);
    final flagUrlController = TextEditingController(text: country?.flagUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(country == null ? 'Tambah Negara' : 'Edit Negara'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(labelText: 'Kode Negara'),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama Negara'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                ),
                TextField(
                  controller: flagUrlController,
                  decoration: InputDecoration(labelText: 'URL Gambar Bendera'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final newCountry = Country(
                  code: codeController.text,
                  name: nameController.text,
                  description: descriptionController.text,
                  flagUrl: flagUrlController.text,
                );
                if (country == null) {
                  _addCountry(newCountry);
                } else if (index != null) {
                  _editCountry(index, newCountry);
                }
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Negara'),
      ),
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                country.flagUrl,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
              ),
              title: Text(country.name),
              subtitle: Text(country.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showCountryForm(country: country, index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteCountry(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCountryForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
