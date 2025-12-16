import 'package:flutter/material.dart';
import 'resernas.dart';
import 'resena.dart';
import 'perfil.dart';

class ProductosPage extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const ProductosPage({super.key, required this.usuario});

  final List<Map<String, dynamic>> productos = const [
    {'nombre':'Audífonos','precio':350,'imagen':'assets/images/audifonos.jfif','descripcion':'Excelente sonido y diseño moderno'},
    {'nombre':'Teléfono','precio':4200,'imagen':'assets/images/Telefono.jpg','descripcion':'Smartphone rápido y moderno'},
    {'nombre':'Laptop','precio':9500,'imagen':'assets/images/Laptop.jpg','descripcion':'Ideal para estudio y trabajo'},
    {'nombre':'Bocina','precio':800,'imagen':'assets/images/Bocina.jpg','descripcion':'Sonido potente y portátil'},
    {'nombre':'Escultura gótica','precio':1200,'imagen':'assets/images/Escultura.jpg','descripcion':'Decoración artística estilo gótico'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A0F0F),
        title: const Text("Productos", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/Fondo.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return _productoCard(
                context,
                nombre: producto['nombre'],
                descripcion: producto['descripcion'],
                precio: producto['precio'],
                imagen: producto['imagen'],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResernasPage(usuario: usuario)));
          if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResenaPage(usuario: usuario)));
          if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PerfilPage(usuario: usuario)));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget _productoCard(BuildContext context,
      {required String nombre, required String descripcion, required int precio, required String imagen}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: AssetImage(imagen), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 15),
          Text(nombre, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(descripcion, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text('\$$precio MXN', style: const TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra simulada'))),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Comprar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResernasPage(usuario: usuario))),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
            child: const Text('Ver reseñas', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
