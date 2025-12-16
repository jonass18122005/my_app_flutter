import 'package:flutter/material.dart';
import 'database/db_helper.dart';

class AdminResenasPage extends StatefulWidget {
  const AdminResenasPage({super.key});

  @override
  State<AdminResenasPage> createState() => _AdminResenasPageState();
}

class _AdminResenasPageState extends State<AdminResenasPage> {
  List<Map<String, dynamic>> resenas = [];

  @override
  void initState() {
    super.initState();
    cargarResenas();
  }

  Future<void> cargarResenas() async {
    final data = await DBHelper.obtenerResenas();
    setState(() => resenas = data);
  }

  Future<void> eliminarResena(int id) async {
    final db = await DBHelper.database;
    await db.delete('resenas', where: 'id = ?', whereArgs: [id]);
    await cargarResenas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Reseñas'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: resenas.length,
        itemBuilder: (context, index) {
          final r = resenas[index];
          return Card(
            color: Colors.black.withOpacity(0.75),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                r['comentario'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < r['estrellas'] ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => eliminarResena(r['id']),
              ),
            ),
          );
        },
      ),
    );
  }
}
