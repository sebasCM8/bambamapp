
import 'package:bambam_app/Models/producto_class.dart';
import 'package:bambam_app/Pages/home_page.dart';
import 'package:bambam_app/Pages/initial_page.dart';
import 'package:bambam_app/Pages/login_page.dart';
import 'package:bambam_app/Pages/productodet_page.dart';
import 'package:bambam_app/Pages/productos_page.dart';
import 'package:bambam_app/Pages/registro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: 'BAMBAM App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const InitialPage(),
        '/loginPage': (context) => const LoginPage(),
        '/registroPage': (context) => const RegistroPage(),
        '/homePage':(context) => const HomePage(),
        '/productosPage':(context) => const ProductosPage(),
        '/productoDetallePage':(context) => ProductoDetPage(prd: ModalRoute.of(context)!.settings.arguments as Producto)
      },
    );
  }
}
