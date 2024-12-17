import 'dart:io';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/alinan_faturala_bloc/alinan_faturalar_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:fitness_dashboard_ui/httpOverRides.dart';
import 'package:fitness_dashboard_ui/screens/optimized_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  
import 'package:fitness_dashboard_ui/bloc/bloc/login_bloc/login_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr', 'TR'),
        const Locale('en', 'US'),
      ],
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginBloc()),
          BlocProvider(create: (context) => DropdownBloc(ApiHandler())),
          BlocProvider(create: (context) => MalzemelerBloc(ApiHandler())),
          BlocProvider(create: (context) => CariHesapBloc(ApiHandler())),
          BlocProvider(create: (context) => AlinanFaturalarBloc(ApiHandler())),
          BlocProvider(create: (context) => AdminBloc(ApiHandler()))

        ],
        child: LoginPageOptimized(),
      ),
    );
  }
}
