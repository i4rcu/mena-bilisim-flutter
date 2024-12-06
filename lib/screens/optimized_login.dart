import 'dart:typed_data';
import 'package:fitness_dashboard_ui/UserSession.dart';
import 'package:fitness_dashboard_ui/screens/admin_screen.dart';
import 'package:fitness_dashboard_ui/screens/main_screen.dart';
import 'package:fitness_dashboard_ui/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/login_bloc/login_bloc.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

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

            return _buildLoginForm(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
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
          const SizedBox(height: 80),
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
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: const Color.fromRGBO(34, 54, 69, 20),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 60),
                    _buildInputCard(),
                    const SizedBox(height: 20),
                    _buildRememberMeCheckbox(),
                    const SizedBox(height: 20),
                    _buildLoginButton(context),
                    const SizedBox(height: 20),
                    const Text("IP'nizi ayarlayın", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    _buildSettingsButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
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
          _buildInputField(controller: _usernameController, hintText: "Kullanıcı adı"),
          _buildInputField(
            controller: _passwordController,
            hintText: "Şifre",
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      {required TextEditingController controller, required String hintText, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600),
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

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: <Widget>[
        ValueListenableBuilder<bool>(
          valueListenable: _rememberMe,
          builder: (context, value, child) {
            return Checkbox(
              activeColor: Colors.orange[600],
              value: value,
              onChanged: (bool? newValue) {
                _rememberMe.value = newValue ?? false;
              },
            );
          },
        ),
        const Text("Beni Hatırla", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        context.read<LoginBloc>().add(LoginSubmitted(
              username: _usernameController.text,
              password: EncryptionHelper.encryptPassword(_passwordController.text),
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

  Widget _buildSettingsButton(BuildContext context) {
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