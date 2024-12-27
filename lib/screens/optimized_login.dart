import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/login_bloc/login_bloc.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_dashboard_ui/screens/admin_screen.dart';
import 'package:fitness_dashboard_ui/screens/main_screen.dart';
import 'package:fitness_dashboard_ui/screens/settings.dart';
import 'package:fitness_dashboard_ui/UserSession.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPageOptimized extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageOptimized> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _rememberMe = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';
    _rememberMe.value = prefs.getBool('rememberMe') ?? false;
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe.value) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', _rememberMe.value);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', _rememberMe.value);
    }
  }

  void _navigateBasedOnRole(String role) {
    if (role == "User") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else if (role == "Admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(36, 64, 72, 50),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              UserSession().userId = state.userId;
              _saveUserData();
              _navigateBasedOnRole(state.kullanici_vasfi);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.orange[900]),
              );
            }

            return _buildLoginForm(context, screenWidth, screenHeight);
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromRGBO(255, 87, 34, 1),
              Color.fromRGBO(255, 87, 34, 0.9),
              Color.fromRGBO(255, 87, 34, 0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Giriş", style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10),
                  Text("Hoş Geldiniz", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: screenHeight * 0.8,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(34, 54, 69, 20),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.08),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    InputCard(
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    RememberMeCheckbox(rememberMe: _rememberMe),
                    const SizedBox(height: 20),
                    LoginButton(
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    const Text("IP'nizi ayarlayın", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    SettingsButton(),
                    const SizedBox(height: 20),
                    WhatsAppButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputCard extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const InputCard({
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(225, 95, 27, .3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          InputField(controller: usernameController, hintText: "Kullanıcı adı"),
          InputField(controller: passwordController, hintText: "Şifre", obscureText: true),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const InputField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
          ),
        ),
      ),
    );
  }
}

class RememberMeCheckbox extends StatelessWidget {
  final ValueNotifier<bool> rememberMe;

  const RememberMeCheckbox({required this.rememberMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ValueListenableBuilder<bool>(
          valueListenable: rememberMe,
          builder: (context, value, child) {
            return Checkbox(
              activeColor: Colors.orange[600],
              value: value,
              onChanged: (bool? newValue) {
                rememberMe.value = newValue ?? false;
              },
            );
          },
        ),
        const Text("Beni Hatırla", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginButton({
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        context.read<LoginBloc>().add(LoginSubmitted(
              username: usernameController.text,
              password: EncryptionHelper.encryptPassword(passwordController.text),
            ));
      },
      height: 50,
      color: Colors.orange[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: const Center(
        child: Text(
          "Giriş",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => Settings()),
        );
      },
      height: 50,
      color: const Color.fromRGBO(65, 190, 184, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: const Center(
        child: Text(
          "Ayarlar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class WhatsAppButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _openWhatsApp,
      height: 50,
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: const Center(
        child: Text(
          "Teknik Destek",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final phone = "+905373947885"; // Your WhatsApp number
    final message = Uri.encodeComponent("Merhaba, destek için yazıyorum.");
    final url = "https://wa.me/$phone?text=$message";
    await launchUrl(Uri.parse(url));
  }
}

class EncryptionHelper {
  static final key = encrypt.Key(Uint8List.fromList(
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]));
  static final iv = encrypt.IV(Uint8List.fromList(
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]));

  static String encryptPassword(String password) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  static String decryptPassword(String encryptedPassword) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
    return decrypted;
  }
}