import 'package:fitness_dashboard_ui/admin_seide_menu/kullanicilar_sekme/kullanicilar.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/alinan_faturala_bloc/alinan_faturalar_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bankalar_bloc/bankalar_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/bloc/bloc/cekvesenet_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/cari_hesaplar_bloc/cari_hesap_bloc.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/malzemeler_bloc/malzemeler_bloc.dart';
import 'package:fitness_dashboard_ui/data/admin_side_bar_data.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/cari_hesap_list_page.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cariler_sekme/en_cok_satilan_cariler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/bankalar_sekme/bankalar_list_page.dart';
import 'package:fitness_dashboard_ui/side_menu_list/cek_ve_senet_sekme/cek_ve_senet.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/alinan_fatualar.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/faturla.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/en_cok_satilan_malzeme.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/gunluk_malzeme_alisi.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/gunluk_malzeme_satisi.dart';
import 'package:fitness_dashboard_ui/side_menu_list/faturalar_sekmeler/satis.faturalari.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/satilan_malzemeler.dart';
import 'package:fitness_dashboard_ui/side_menu_list/malzemeler_sekme/tum_malzemeler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_dashboard_ui/main.dart';

class AdminSideMenuWidget extends StatefulWidget {
  const AdminSideMenuWidget({super.key});

  @override
  State<AdminSideMenuWidget> createState() => _AdminSideMenuWidgetState();
}

class _AdminSideMenuWidgetState extends State<AdminSideMenuWidget> {
  int selectedIndex = 0;
  List<bool> expandedStates = [];

  @override
  void initState() {
    super.initState();
    expandedStates = List<bool>.filled(AdminSideMenuData().menu.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final data = AdminSideMenuData();

    return Container(
      padding: const EdgeInsets.only(bottom: 80,top: 80,right: 20,left: 10),
      color: const Color.fromRGBO(36, 64, 72, 50),
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
      ),
    );
  }

  Widget buildMenuEntry(AdminSideMenuData data, int index) {
    final isSelected = selectedIndex == index;
    final isExpanded = expandedStates[index];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(22.0),
            ),
            color: isSelected ? const Color.fromRGBO(68, 192, 186, 20) : Colors.transparent,
          ),
          child: InkWell(
            onTap: () => onMenuTap(index),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                  child: Icon(
                    data.menu[index].icon,
                    color: isSelected ? Colors.black : const Color.fromRGBO(68, 192, 186, 100),
                  ),
                ),
                Text(
                  data.menu[index].title,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.black : const Color.fromRGBO(68, 192, 186, 10),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color.fromRGBO(68, 192, 186, 100),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...buildSubMenuItems(index),
      ],
    );
  }

  List<Widget> buildSubMenuItems(int index) {
    // Example sub-menu list for each main menu item
    final subMenuItems = AdminSideMenuData().menu[index].subMenu ?? [];

    return subMenuItems.map((subItem) {
      return Padding(
        padding: const EdgeInsets.only(left: 30.0, top: 5, bottom: 5),
        child: InkWell(
          onTap: () => onSubMenuTap(index, subItem),
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: const Color.fromRGBO(68, 192, 186, 100)),
                Expanded(
  child: Text(
    subItem,
    softWrap: true,
    overflow: TextOverflow.visible,
    style: const TextStyle(
      fontSize: 14,
      color: Color.fromRGBO(68, 192, 186, 10),
    ),
  ),
),


              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void onMenuTap(int index) {
  // Get the selected menu item
  final menuItem = AdminSideMenuData().menu[index];

  // Check if the selected menu item has no sub-menu
  if (menuItem.subMenu == null || menuItem.subMenu!.isEmpty) {
    // If there is no sub-menu, perform navigation
    setState(() {
      selectedIndex = index;
    });

    // Add your navigation logic based on the selected index
    if (index == 0) {
      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => AdminBloc(ApiHandler())
                        ..add(FetchKullanicilar()),
                      child: KullanicilarPage(),
                    ),
                  ),
                );
    } else if (index == 5) {
      // Navigate to Cari Hesaplar (if no sub-menu exists)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => BankalarBloc(ApiHandler()),
            child: BankalarListPage(),
          ),
        ),
      );
    } else if (index == 4) {
      // Navigate to Satış Faturaları
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AlinanFaturalarBloc(ApiHandler()),
            child: SatisFaturalarPage(),
          ),
        ),
      );
    }else if (index == 6) {
      // Navigate to Satış Faturaları
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CekvesenetBloc(ApiHandler()),
            child: CekVeSenetPage(),
          ),
        ),
      );
    }else if (index == 8) {
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
                  selectedIndex = index;
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MyApp()));
              },
              child: const Text("Evet"),
            ),
          ],
        ),
      );
    }
    // Add other navigation cases as needed...
  } else {
    // If there is a sub-menu, toggle the expansion state
    setState(() {
      expandedStates[index] = !expandedStates[index];
    });
  }
}


  void onSubMenuTap(int parentIndex, String subItem) {
    if (parentIndex == 8) {
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MyApp()));
              },
              child: const Text("Evet"),
            ),
          ],
        ),
      );
    } else if (parentIndex == 1 && subItem == "Cari Hesaplar" ) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => CariHesapBloc(ApiHandler()),
              child: CariHesapListPage(),
            ),
          ),
        );
      } else if (parentIndex == 1 && subItem == "En Çok Satış Yapılan Cari Hesaplar Turar Bazlı") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => CariHesapBloc(ApiHandler())..add(
                        fetchEnCokSatilanCairler("tablePrefix", "tableSuffix", "0"), // Replace with actual parameters
                      ),
                      child: EnCokSatilanCariHesapListPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem == "Hareket Görmeyen Malzemeler") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) =>
                          MalzemelerBloc(ApiHandler())..add(FetchHmalzeme()),
                      child: AllItemsPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem == "Hangi Malzeme Kime Satıldı") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(FetchSatilanMalzeme()),
                      child: SatilanMalzemePage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem =="Tüm Malzemeler") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchTumMalzemeler()),
                      child: TumMalzemelerPage(),
                    ),
                  ),
                );
      }else if (parentIndex == 2 && subItem =="En Çok Satılan Mazlemeler") {
       Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchEnCokSatilanMalzemeler("","","0")),
                      child: EnCokSatilanMalzemeListPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem =="Günlük Malzeme Satışı") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchGunlukMalzemeSatisi("","","0")),
                      child: GunlukMalzemeSatisiListPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem =="Günlük Malzeme Alışı") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchGunlukMalzemeAlisi("","","0")),
                      child: GunlukMalzemeAlisiListPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 3 ) {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => AlinanFaturalarBloc(ApiHandler())
                        ..add(LoadAlinanFaturalar(prefix:  "",suffix: "")),
                      child: AlinanFaturalarPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem =="Tüm Malzemeler") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchTumMalzemeler()),
                      child: TumMalzemelerPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem =="Tüm Malzemeler") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchTumMalzemeler()),
                      child: TumMalzemelerPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem =="Tüm Malzemeler") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchTumMalzemeler()),
                      child: TumMalzemelerPage(),
                    ),
                  ),
                );
      } else if (parentIndex == 2 && subItem =="Tüm Malzemeler") {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => MalzemelerBloc(ApiHandler())
                        ..add(fetchTumMalzemeler()),
                      child: TumMalzemelerPage(),
                    ),
                  ),
                );
      }
  }
}





































