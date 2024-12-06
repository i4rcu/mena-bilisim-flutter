import 'package:fitness_dashboard_ui/UserSession.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/login_bloc/login_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:fitness_dashboard_ui/util/responsive.dart';
import 'package:fitness_dashboard_ui/widgets/dashboard_widget.dart';
import 'package:fitness_dashboard_ui/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  final prefs = SharedPreferences.getInstance();

  MainScreen({super.key});

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
          BlocProvider(create: (context) => LoginBloc()),
          BlocProvider(create: (context) => DropdownBloc(ApiHandler())),
          BlocProvider(create: (context) => MalzemelerBloc(ApiHandler())),
          BlocProvider(create: (context) => CariHesapBloc(ApiHandler())),
          BlocProvider(create: (context) => AdminBloc(ApiHandler())..add(FetchYetkiler(UserSession().userId!))),
        ],
        child:
         SafeArea(
           child: Scaffold(
            backgroundColor: Color.fromRGBO(34, 54, 69, 100),
            drawer: !isDesktop
                ? const SizedBox(
                    width: 250,
                    child: SideMenuWidget(),
                  )
                : const SizedBox(
                    width: 250,
                    child: SideMenuWidget(),
                  ),
            endDrawer: Responsive.isMobile(context)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    //child: const SummaryWidget(),
                  )
                : null,
            body: SafeArea(
              child: Row(
                children: [
                  if (isDesktop)
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: SideMenuWidget(),
                      ),
                    ),
                  Expanded(
                    flex: 9,
                    child: DashboardWidget(),
                  ),
                  /*if (isDesktop)
                    Expanded(
                      flex: 1,
                      child: SummaryWidget(),
                    ),*/
                ],
              ),
            ),
                   ),
         )));
  }
} 