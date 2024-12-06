import 'package:fitness_dashboard_ui/bloc/bloc/bankalar_bloc/bankalar_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_event.dart';
import 'package:fitness_dashboard_ui/util/responsive.dart';
import 'package:fitness_dashboard_ui/widgets/activity_details_card.dart';
import 'package:fitness_dashboard_ui/widgets/bankalar_kart.dart';
import 'package:fitness_dashboard_ui/widgets/bar_graph_widget.dart';
import 'package:fitness_dashboard_ui/widgets/cari_heasplar_kart.dart';
import 'package:fitness_dashboard_ui/widgets/header_widget.dart';
import 'package:fitness_dashboard_ui/widgets/line_chart_card.dart';
import 'package:fitness_dashboard_ui/widgets/summary_widget.dart';
import 'package:fitness_dashboard_ui/widgets/buttons.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/dropdown_bloc/dropdown_bloc.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                BankalarBloc(ApiHandler())..add(FetchBankalar())),
        BlocProvider(
            create: (context) =>
                DropdownBloc(ApiHandler())..add(LoadDropdownData())),
        BlocProvider(
            create: (context) =>
                CariHesapBloc(ApiHandler())..add(FetchCariHesaplar("", ""))),
        BlocProvider(
            create: (context) =>
                CariHesapBloc(ApiHandler())..add(fetchEnCokSatilanCairler("", "","1"))),
      ],
      child : MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 18),
              const HeaderWidget(),
              const SizedBox(height: 18),
              Buttons(isDesktop: isDesktop),
              const SizedBox(height: 0),
              // Conditional layout based on isDesktop
              Container(
                width: isDesktop
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width,
                child: isDesktop
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1, // Flexible for desktop
                            child: ActivityDetailsCard(isDesktop: isDesktop),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: CariHeasplarKart(isDesktop: isDesktop),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: BankalarKart(isDesktop: isDesktop),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ActivityDetailsCard(isDesktop: isDesktop),
                              ),
                              const SizedBox(width: 1),
                              Expanded(
                                flex: 1,
                                child: CariHeasplarKart(isDesktop: isDesktop),
                              ),
                            ],
                          ),
                          const SizedBox(height: 0),
                          BankalarKart(isDesktop: isDesktop),
                        ],
                      ),
              ),
              const SizedBox(height: 1),
              // Make charts smaller on desktop
              SizedBox(
                width: isDesktop
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width,
                child: const LineChartCard(),
              ),
              const SizedBox(height: 1),
              SizedBox(
                width: isDesktop
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width,
                child: const BarGraphCard(),
              ),
              const SizedBox(height: 18),
              if (Responsive.isTablet(context)) const SummaryWidget(),
            ],
          ),
        ),
      ),
    ));
  }
}