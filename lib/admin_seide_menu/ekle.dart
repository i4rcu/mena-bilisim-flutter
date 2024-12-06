import 'package:fitness_dashboard_ui/EncryptionHelper.dart';
import 'package:fitness_dashboard_ui/admin_seide_menu/kullanicilar_sekme/kullanicilar.dart';
import 'package:fitness_dashboard_ui/apihandler/api_handler.dart';
import 'package:fitness_dashboard_ui/bloc/bloc/admin_bloc/bloc/admin_bloc.dart';
import 'package:fitness_dashboard_ui/screens/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KullaniciEkle extends StatefulWidget {
  KullaniciEkle();

  @override
  _KullaniciEkleState createState() => _KullaniciEkleState();
}

class _KullaniciEkleState extends State<KullaniciEkle> {
  late TextEditingController _kullaniciAdController;
  late TextEditingController _sifreController;
  late TextEditingController _lisansTarihiController;
  late TextEditingController _lisansBitisTarihiController;

  // List of checkboxes
  List<String> _checkboxOptions = [
    'Dashboard',
    'Cari Hesap',
    'Malzemeler',
    'Alış Faturaları',
    'Satış Faturaları',
    'Bankalar',
    'Çek Ve Senet',
    'Raporlar',
  ];

  // List to track the selected options
  List<bool> _checkboxValues = List.generate(8, (index) => false);

  @override
  void initState() {
    super.initState();
    _kullaniciAdController = TextEditingController();
    _sifreController = TextEditingController();
    _lisansTarihiController = TextEditingController();
    _lisansBitisTarihiController = TextEditingController();
  }

  // Function to show a date picker
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.tryParse(controller.text) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Locale('tr')
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Validation Function
  bool _validateInputs() {
    String errorMessage = '';

    if (_kullaniciAdController.text.isEmpty) {
      errorMessage = 'Kullanıcı Adı boş olamaz.';
    } else if (_sifreController.text.isEmpty) {
      errorMessage = 'Şifre boş olamaz.';
    } else if (_lisansTarihiController.text.isEmpty) {
      errorMessage = 'Lisans Tarihi seçilmelidir.';
    } else if (_lisansBitisTarihiController.text.isEmpty) {
      errorMessage = 'Lisans Bitiş Tarihi seçilmelidir.';
    } else {
      
     
    }

    if (errorMessage.isNotEmpty) {
      // Show the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(ApiHandler()),
      child:  MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.9)), // Force text scale factor to 1.0
    child: SafeArea(
      child:Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: Text('Kullanıcı Ekle',style: TextStyle(color: Colors.white),),
            backgroundColor: Color.fromRGBO(36, 64, 72, 1),
          ),
                backgroundColor: Color.fromRGBO(36, 64, 72, 1),
        
          body: BlocListener<AdminBloc, AdminState>(
            listener: (context, state) {
              String message;
        
              if (state is KullaniciAdded) {
                message = 'Kullanıcı başarıyla eklendi.';
                Navigator.of(context).pop(); // Close page on success
        
                // Fetch users again after successful update
                context.read<AdminBloc>().add(FetchKullanicilar());
              } else if (state is KullaniciAddError) {
                message = 'Kullanıcı eklenemedi. Lütfen tekrar deneyin.';
              } else {
                return; // Do nothing for other states
              }
        
              // Show the SnackBar
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Kullanici Ad Text Field
                    TextField(
                      controller: _kullaniciAdController,
                      decoration: InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    // Sifre Text Field
                    TextField(
                      controller: _sifreController,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.white),
                      obscureText: true, // Hide password input
                    ),
                    SizedBox(height: 16.0),
                    // Lisans Tarihi Date Picker
                    TextField(
                      controller: _lisansTarihiController,
                      decoration: InputDecoration(
                        labelText: 'Lisans Tarihi',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectDate(context, _lisansTarihiController),
                      style: TextStyle(color: Colors.white),
                      readOnly: true, // Opens date picker on tap
                    ),
                    SizedBox(height: 16.0),
                    // Lisans Bitis Tarihi Date Picker
                    TextField(
                      controller: _lisansBitisTarihiController,
                      decoration: InputDecoration(
                        labelText: 'Lisans Bitiş Tarihi',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () =>
                          _selectDate(context, _lisansBitisTarihiController),
                      style: TextStyle(color: Colors.white),
                      readOnly: true, // Opens date picker on tap
                    ),
                    SizedBox(height: 16.0),
                    // Checkboxes
                    Column(
          children: List.generate(_checkboxOptions.length, (index) {
            return Padding(
        padding: const EdgeInsets.all(3.0),
        child: CheckboxListTile(
          title: Text(_checkboxOptions[index],style: TextStyle(color: Colors.white),),
          value: _checkboxValues[index],
          onChanged: (bool? value) {
            setState(() {
              _checkboxValues[index] = value ?? false;
            });
          },
          activeColor: Color.fromRGBO(241, 108, 39, 1), // Checked color
          tileColor: Color.fromRGBO(54, 78, 96, 0.2), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
          ),
          
        ),
            );
          }),
        ),
                    SizedBox(height: 16.0),
                    // Submit Button
                    ElevatedButton(
                      child: Text('Ekle',style: TextStyle(color: Colors.white,fontSize: 16)),
                                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(241, 108, 39, 20))),
        
                      onPressed: () {
          if (_validateInputs()) {
            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => AdminBloc(ApiHandler())..add(FetchKullanicilar()),
                child: AdminScreen(),
              ),
            ),
          );
            // Parse and convert dates to yyyy-MM-dd format
            DateTime lisansTarihi = DateFormat('dd/MM/yyyy').parse(_lisansTarihiController.text);
            DateTime lisansBitisTarihi = DateFormat('dd/MM/yyyy').parse(_lisansBitisTarihiController.text);
            print(lisansTarihi);
            print(lisansBitisTarihi);
            // Format the dates to yyyy-MM-dd
            String formattedLisansTarihi = DateFormat('yyyy-MM-dd').format(lisansTarihi);
            String formattedLisansBitisTarihi = DateFormat('yyyy-MM-dd').format(lisansBitisTarihi);
            print(formattedLisansTarihi);
            print(formattedLisansBitisTarihi);
          print(DateEncryptor().encrypt(lisansTarihi));
          print(DateEncryptor().encrypt(lisansBitisTarihi));
            // Trigger AddKullanici event with formatted dates using existing Bloc
            context.read<AdminBloc>().add(
        AddKullanici(
          _kullaniciAdController.text,
          EncryptionHelper.encryptPassword(_sifreController.text),
          DateEncryptor().encrypt((lisansTarihi)),  // Passing formatted lisansTarihi
          DateEncryptor().encrypt(lisansBitisTarihi),  // Passing formatted lisansBitisTarihi
          _checkboxValues,  // Checkbox values
        ),
            );


          }
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı Bilgileri Başarıyla Eklendi.')),);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => AdminBloc(ApiHandler())..add(FetchKullanicilar()),
                child: AdminScreen(),
              ),
            ),
          );
          
        },
        
        
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _kullaniciAdController.dispose();
    _sifreController.dispose();
    _lisansTarihiController.dispose();
    _lisansBitisTarihiController.dispose();
    super.dispose();
  }
}
