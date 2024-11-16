import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/util/responsive.dart';
import 'package:fitness_dashboard_ui/widgets/admin_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatelessWidget {
  final prefs = SharedPreferences.getInstance();

  AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('tr', 'TR'),
          const Locale('en', 'US'),
        ],
        title: 'Dashborad UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        
        home:MultiBlocProvider(
        providers: [
           BlocProvider(create: (context) => AdminBloc(ApiHandler()))
        ],
        child:
         Scaffold(
          backgroundColor: Color.fromRGBO(34, 54, 69, 100),
          drawer: !isDesktop
              ? const SizedBox(
                  width: 250,
                  //child: AdminSideMenuWidget(),
                )
              : null,
          endDrawer: Responsive.isMobile(context)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  //child: const SummaryWidget(),
                )
              : null,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 7,
                  child: AdminDashboardWidget(),
                ),
              ],
            ),
          ),
        )));
  }
}
