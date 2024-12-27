import 'package:fitness_dashboard_ui/UserSession.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/alinan_faturala_bloc/alinan_faturalar_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bankalar_bloc/bankalar_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bloc/bloc/cekvesenet_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:fitness_dashboard_ui/screens/main_screen.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_list_page.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/en_cok_satilan_cariler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/bankalar_sekme/bankalar_list_page.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/hareketli_cariler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/hareketsiz_cariler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cek_ve_senet_sekme/cek_ve_senet.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/alinan_fatualar.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/faturla.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/en_cok_satilan_malzeme.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/gunluk_malzeme_alisi.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/gunluk_malzeme_satisi.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/satis.faturalari.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/satilan_malzemeler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/tum_malzemeler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/raporlar_sekme/rapor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/main.dart';
import 'package:fitness_dashboard_ui/data/side_menu_data.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;
  List<bool> expandedStates = [];
  List<bool> yetki = [];

  @override
  void initState() {
    super.initState();
    expandedStates = List<bool>.filled(SideMenuData().menu.length, false);
    context.read<AdminBloc>().add(FetchYetkiler(UserSession().userId!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdminBloc(ApiHandler())..add(FetchYetkiler(UserSession().userId!)),
      child:MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is YetkilerFetched) {
            yetki = state
                .checkboxes; // Assuming YetkiLoaded contains the yetki list
            final data = SideMenuData();
            final filteredMenu = data.menu
                .asMap()
                .entries
                .where((entry) => yetki[entry.key] == true)
                .map((entry) {
              final menuItem = entry.value;

              // Filter submenus if they exist
              final filteredSubMenu = menuItem.subMenu
                  ?.where((subMenuItem) =>
                      true /* Add logic for submenu filtering if needed*/)
                  .toList();

              // Return the filtered MenuModel, including the filtered subMenu
              return MenuModel(
                icon: menuItem.icon,
                title: menuItem.title,
                subMenu:
                    filteredSubMenu, // Filtered submenu, or null if no submenu
              );
            }).toList();

            expandedStates = List<bool>.filled(filteredMenu.length, false);

            return Container(
  padding: const EdgeInsets.only(bottom: 80, top: 80, right: 20, left: 10),
  color: const Color.fromRGBO(36, 64, 72, 50),
  child: ListView.builder(
    itemCount: filteredMenu.length,
    itemBuilder: (context, index) {
      final menuItem = filteredMenu[index];

      if (menuItem.subMenu != null) {
        // If `subMenu` is not null, build an ExpansionTile with submenu items
        return ExpansionTile(
          leading: Icon(
            menuItem.icon,
            color: Color.fromRGBO(65, 190, 184, 20),
          ),
          collapsedIconColor: Color.fromRGBO(65, 190, 184, 20),
          collapsedTextColor: Color.fromRGBO(65, 190, 184, 20),
          iconColor: Color.fromRGBO(65, 190, 184, 20),
          title: Text(
            menuItem.title,
            style: TextStyle(color: Color.fromRGBO(65, 190, 184, 20)),
          ),
          children: menuItem.subMenu!.map((subMenuItem) {
            return ListTile(
              title: Text(
                "- $subMenuItem",
                style: TextStyle(color: Color.fromRGBO(65, 180, 190, 20)),
              ),
              onTap: () {
                onSubMenuTap(index, subMenuItem, menuItem.title);
              },
            );
          }).toList(),
        );
      } else {
        // If `subMenu` is null, build a regular ListTile
        return ListTile(
          leading: Icon(
            menuItem.icon,
            color: Color.fromRGBO(65, 190, 184, 20),
          ),
          title: Text(
            menuItem.title,
            style: TextStyle(color: Color.fromRGBO(65, 190, 184, 20)),
          ),
          onTap: () {
            onMenuTap(index,  menuItem.title);
          },
        );
      }
    },
  ),
);

          } else if (state is YetkilerFetching) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Error loading menu'));
          }
        },
      ),
    ));
  }

  

 
  void onMenuTap(int index, String adi) {
    final menuItem = SideMenuData().menu.firstWhere(
          (item) => item.title == adi,
        );
    if (menuItem.subMenu == null || menuItem.subMenu!.isEmpty) {
      setState(() {
        selectedIndex = index;
      });
      if (adi == "Alış Faturaları") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => AlinanFaturalarBloc(ApiHandler())
                ..add(LoadAlinanFaturalar(prefix: "", suffix: "")),
              child: AlinanFaturalarPage(),
            ),
          ),
        );
      } else if (adi == "Bankalar") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => BankalarBloc(ApiHandler()),
              child: BankalarListPage(),
            ),
          ),
        );
      } else if (adi == "Dashboard") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MainScreen(),
          ),
        );
      } else if (adi == "Satış Faturaları") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => AlinanFaturalarBloc(ApiHandler()),
              child: SatisFaturalarPage(),
            ),
          ),
        );
      } else if (adi == "Çek Ve Senet") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => CekvesenetBloc(ApiHandler()),
              child: CekVeSenetPage(),
            ),
          ),
        );
      } else if (adi == "Raporlar") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => AdminBloc(ApiHandler())
                ..add(FetchKullaniciRaporlari(UserSession().userId)),
              child: ReportsPage(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        expandedStates[index] = !expandedStates[index];
      });
    }
  }

  void onSubMenuTap(int parentIndex, String subItem, String adi) {
    if (adi == "Çıkış") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Onaylama"),
          content: const Text("Çıkış Yapmak ister misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hayır"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  selectedIndex = parentIndex;
                });
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => MyApp()));
              },
              child: const Text("Evet"),
            ),
          ],
        ),
      );
    } else if (adi == "Cari Hesaplar" && subItem == "Cari Hesaplar") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CariHesapBloc(ApiHandler()),
            child: CariHesapListPage(),
          ),
        ),
      );
      
    } else if (adi == "Cari Hesaplar" && subItem == "Hareketli Cari Hesaplar") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CariHesapBloc(ApiHandler()),
            child: ClientTotalsPage(),
          ),
        ),
      );
    }else if (adi == "Cari Hesaplar" && subItem == "Hareketsiz Cari Hesaplar") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CariHesapBloc(ApiHandler()),
            child: HareketsizCarilerPage(),
          ),
        ),
      );
    }else if (adi == "Cari Hesaplar" &&
        subItem == "En Çok Satış Yapılan Cari Hesaplar Turar Bazlı") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CariHesapBloc(ApiHandler())
              ..add(
                fetchEnCokSatilanCairler("tablePrefix", "tableSuffix",
                    "0"), // Replace with actual parameters
              ),
            child: EnCokSatilanCariHesapListPage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" &&
        subItem == "Hareket Görmeyen Malzemeler") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => MalzemelerBloc(ApiHandler())..add(FetchHmalzeme()),
            child: AllItemsPage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" && subItem == "Hangi Malzeme Kime Satıldı") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                MalzemelerBloc(ApiHandler())..add(FetchSatilanMalzeme()),
            child: SatilanMalzemePage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" && subItem == "Tüm Malzemeler") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                MalzemelerBloc(ApiHandler())..add(fetchTumMalzemeler()),
            child: TumMalzemelerPage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" && subItem == "En Çok Satılan Mazlemeler") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => MalzemelerBloc(ApiHandler()),
            child: EnCokSatilanMalzemeListPage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" && subItem == "Günlük Malzeme Satışı") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => MalzemelerBloc(ApiHandler())
              ..add(fetchGunlukMalzemeSatisi("", "", "0")),
            child: GunlukMalzemeSatisiListPage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" && subItem == "Günlük Malzeme Alışı") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => MalzemelerBloc(ApiHandler())
              ..add(fetchGunlukMalzemeAlisi("", "", "0")),
            child: GunlukMalzemeAlisiListPage(),
          ),
        ),
      );
    } else if (adi == "Alış Faturaları") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => AlinanFaturalarBloc(ApiHandler())
              ..add(LoadAlinanFaturalar(prefix: "", suffix: "")),
            child: AlinanFaturalarPage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" && subItem == "Tüm Malzemeler") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                MalzemelerBloc(ApiHandler())..add(fetchTumMalzemeler()),
            child: TumMalzemelerPage(),
          ),
        ),
      );
    } else if (adi == "Malzemeler" && subItem == "Tüm Malzemeler") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                MalzemelerBloc(ApiHandler())..add(fetchTumMalzemeler()),
            child: TumMalzemelerPage(),
          ),
        ),
      );
    } else if (parentIndex == 2 && subItem == "Tüm Malzemeler") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                MalzemelerBloc(ApiHandler())..add(fetchTumMalzemeler()),
            child: TumMalzemelerPage(),
          ),
        ),
      );
    } else if (parentIndex == 2 && subItem == "Tüm Malzemeler") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                MalzemelerBloc(ApiHandler())..add(fetchTumMalzemeler()),
            child: TumMalzemelerPage(),
          ),
        ),
      );
    }
  }
}
