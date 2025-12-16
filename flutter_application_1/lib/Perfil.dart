import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'productos.dart';
import 'resernas.dart';
import 'resena.dart';
import 'login.dart';
import 'admin.dart'; 

class PerfilPage extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const PerfilPage({super.key, required this.usuario});

  void _cerrarSesion(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _itemPerfil({required String texto, required VoidCallback onTap, Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(texto, style: TextStyle(color: color, fontSize: 18)),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleNotificaciones(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notificaciones') ?? false;

    final action = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(enabled ? 'Desactivar notificaciones' : 'Activar notificaciones'),
        content: Text(enabled
            ? '¿Deseas desactivar las notificaciones?'
            : '¿Deseas activar las notificaciones?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí')),
        ],
      ),
    );

    if (action == true) {
      await prefs.setBool('notificaciones', !enabled);
      final mensaje = !enabled ? 'Notificaciones activadas' : 'Notificaciones desactivadas';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A0F0F),
        title: const Text(
          'Perfil',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.black),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario['nombre'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            usuario['correo'],
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _itemPerfil(texto: 'Lenguaje', onTap: () {}),
                      _itemPerfil(texto: 'Notificaciones', onTap: () => _toggleNotificaciones(context)),
                      _itemPerfil(texto: 'Cerrar sesión', color: Colors.red, onTap: () => _cerrarSesion(context)),

                      _itemPerfil(
                        texto: 'Administrar DB',
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AdminResenasPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResernasPage(usuario: usuario)));
          if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResenaPage(usuario: usuario)));
          if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductosPage(usuario: usuario)));
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
}
