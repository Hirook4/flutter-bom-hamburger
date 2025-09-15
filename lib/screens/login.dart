import 'package:flutter/material.dart';
import 'package:bom_hamburguer/_utils/color_theme.dart';
import 'package:bom_hamburguer/screens/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /* Controller do campo name (como é um app apenas para demonstração, os campos de email e senha não serão validados) */
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.primaryColor,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 200),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "BOM HAMBURGUER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: ColorTheme.quaternaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorTheme.quaternaryColor,
                  ),
                  decoration: InputDecoration(
                    labelText: "name",
                    labelStyle: TextStyle(color: ColorTheme.quaternaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorTheme.tertiaryColor,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorTheme.tertiaryColor),
                    ),
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: ColorTheme.quaternaryColor,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: ColorTheme.quaternaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorTheme.quaternaryColor,
                  ),
                  decoration: InputDecoration(
                    labelText: "email",
                    labelStyle: TextStyle(color: ColorTheme.quaternaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorTheme.tertiaryColor,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorTheme.tertiaryColor),
                    ),
                    prefixIcon: Icon(
                      Icons.mail_outlined,
                      color: ColorTheme.quaternaryColor,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: ColorTheme.quaternaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorTheme.quaternaryColor,
                  ),
                  decoration: InputDecoration(
                    labelText: "password",
                    labelStyle: TextStyle(color: ColorTheme.quaternaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorTheme.tertiaryColor,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorTheme.tertiaryColor),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline_sharp,
                      color: ColorTheme.quaternaryColor,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: ColorTheme.quaternaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTheme.tertiaryColor,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Efetuando Login"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(name: _nameController.text),
                          ),
                        );
                      });
                    },
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: ColorTheme.quaternaryColor),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "esqueci a senha",
                    style: TextStyle(
                      color: ColorTheme.quaternaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
