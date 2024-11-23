import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Negara',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Country> countries = [
    Country(
      code: 'ID',
      name: 'Indonesia',
      description: 'Negara di Asia Tenggara.',
      flagUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Flag_of_Indonesia.svg/1280px-Flag_of_Indonesia.svg.png',
    ),
    Country(
      code: 'US',
      name: 'United States',
      description: 'Negara di Amerika Utara.',
      flagUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1920px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png',
    ),
  ];

  void addCountry(Country country) {
    setState(() {
      countries.add(country);
    });
  }

  void updateCountry(int index, Country country) {
    setState(() {
      countries[index] = country;
    });
  }

  void deleteCountry(int index) {
    setState(() {
      countries.removeAt(index);
    });
  }

  void openAddUpdateScreen({Country? country, int? index}) {
    final isEditing = country != null;
    final codeController = TextEditingController(text: country?.code ?? '');
    final nameController = TextEditingController(text: country?.name ?? '');
    final descriptionController =
        TextEditingController(text: country?.description ?? '');
    final flagUrlController =
        TextEditingController(text: country?.flagUrl ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Edit Negara' : 'Tambah Negara'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                decoration: InputDecoration(labelText: 'Deskripsi Negara'),
              ),
              TextField(
                controller: flagUrlController,
                decoration: InputDecoration(labelText: 'URL Bendera'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newCountry = Country(
                code: codeController.text,
                name: nameController.text,
                description: descriptionController.text,
                flagUrl: flagUrlController.text,
              );

              if (isEditing && index != null) {
                updateCountry(index, newCountry);
              } else {
                addCountry(newCountry);
              }

              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Perbarui' : 'Tambah'),
          ),
        ],
      ),
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
          return CountryCard(
            country: country,
            onEdit: () => openAddUpdateScreen(country: country, index: index),
            onDelete: () => deleteCountry(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddUpdateScreen(),
        child: Icon(Icons.add),
      ),
    );
  }
}

class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CountryCard({
    Key? key,
    required this.country,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(country.flagUrl),
        ),
        title: Text(country.name),
        subtitle: Text(country.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
