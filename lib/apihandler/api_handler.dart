import 'dart:convert';
import 'package:fitness_dashboard_ui/UserSession.dart';
import 'package:fitness_dashboard_ui/apihandler/model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHandler {
  var formatter = NumberFormat('000');
  var formatter1 = NumberFormat('00');
  String? baseUri;

  ApiHandler() {
    _loadBaseUri();
  }

  Future<void> _loadBaseUri() async {
    final prefs = await SharedPreferences.getInstance();
    final ipAddress =
        prefs.getString('ipAddress') ?? "http://95.70.188.118:9090/api";
    baseUri = "http://$ipAddress:9090/api";
  }

  Future<List<Firma>> getUserData() async {
    List<Firma> data = [];
    final uri = Uri.parse("$baseUri/FirmPeriods");

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Firma.fromJson(json)).toList();
      } else {
        print("Failed to fetch user data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return data;
  }

  Future<void> _ensureBaseUriLoaded() async {
    if (baseUri == null) {
      await _loadBaseUri();
    }
  }
  Future<List<Donem>> getDonem(int firmaId) async {
    await _ensureBaseUriLoaded();
    List<Donem> data = [];
    final uri = Uri.parse('$baseUri/FirmPeriods/$firmaId');

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final List<dynamic> jsonData = json.decode(response.body);
        data = jsonData.map((json) => Donem.fromJson(json)).toList();
      } else {
        print("Failed to fetch periods. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching periods: $e");
    }
    return data;
  }

  Future<Kullanici?> fetchUser(String username, String password) async {
    await _ensureBaseUriLoaded();
    final uri = Uri.parse('$baseUri/lisanslar/login');
    print(uri);
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return Kullanici.fromJson(jsonDecode(response.body));
      } else {
        print("Failed to fetch user. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      print(password);
      return null;
    }
  }

  Future<Lisnas?> fetchLicense(int userId) async {
    await _ensureBaseUriLoaded();
    final uri = Uri.parse('$baseUri/lisanslar/id?userId=$userId');

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Lisnas.fromJson(jsonDecode(response.body));
      } else {
        print("Failed to fetch license. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching license: $e");
      return null;
    }
  }

  Future<Firma> KullaniciFirmaGetir() async {
    await _ensureBaseUriLoaded();
    final response = await http.get(
      Uri.parse('$baseUri/kullanici/GetFirma/${UserSession().userId}'),
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = jsonDecode(response.body);

      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        dynamic firmaJson = jsonResponse.first;
        return Firma.fromJson(firmaJson);
      } else {
        throw Exception('Empty or unexpected response format');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Donem> KullaniciDonemGetir() async {
    await _ensureBaseUriLoaded();
    final response = await http.get(
      Uri.parse('$baseUri/kullanici/GetDonem/${UserSession().userId}'),
    );

    if (response.statusCode == 200) {
      dynamic jsonResponse = jsonDecode(response.body);

      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        dynamic firmaJson = jsonResponse.first;
        return Donem.fromJson(firmaJson);
      } else {
        throw Exception('Empty or unexpected response format');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Firma>> Firmalar() async {
    await _ensureBaseUriLoaded();
    final response = await http.get(Uri.parse('$baseUri/FirmPeriods'));
    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Firma.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<Donem>> DonemGetir(int? firma) async {
    await _ensureBaseUriLoaded();
    final response = await http.get(Uri.parse('$baseUri/FirmPeriods/$firma'));
    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Donem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load donem data');
    }
  }

  Future<void> updateSelectedValues(
      Firma firma, Donem donem, int? userid) async {
    await _ensureBaseUriLoaded();
    final response = await http.post(
      Uri.parse('$baseUri/kullanici/update/$userid'),
      body: jsonEncode(
          {'firma': firma.firma, 'donem': donem.donem, 'name': firma.name}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update selected values');
    }
  }

  Future<void> updateFirma(Firma firma) async {
    await _ensureBaseUriLoaded();
    final response = await http.post(
      Uri.parse('$baseUri/kullanici/UpdateFirma/${UserSession().userId}'),
      body: jsonEncode(firma.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Firma');
    }
  }

  Future<void> updateDonem(Donem donem) async {
    await _ensureBaseUriLoaded();
    final response = await http.post(
      Uri.parse('$baseUri/kullanici/UpdateDonem/${UserSession().userId}'),
      body: jsonEncode(donem.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Firma');
    }
  }

  Future<List<KasaDto>> fetchKasaDetails(
      int tablePrefix, int tableSuffix) async {
    final response = await http.get(Uri.parse(
        '$baseUri/FirmPeriods/GetKasaDetails/${formatter.format(tablePrefix).toString()}/${formatter1.format(tableSuffix).toString()}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => KasaDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Kasa details');
    }
  }

  Future<List<CariHesap>> fetchCariHesaplar(String? tablePrefix, String? tableSuffix) async {
  final url = '$baseUri/FirmPeriods/GetCariHesaplar/$tablePrefix/$tableSuffix';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => CariHesap.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load cari hesaplar');
  }
}
Future<List<EnCokSatilanCariler>> fetchEnCokSatilanCariHesaplar(String? tablePrefix, String? tableSuffix,String? days) async {
  final url = '$baseUri/FirmPeriods/enCokSatisCariHesaplar/$tablePrefix/$tableSuffix/$days';
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => EnCokSatilanCariler.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load cari hesaplar');
  }
}
  Future<List<CariHesapDetail>> fetchCariHesapDetails(
      String tablePrefix, String tableSuffix, int clientRef) async {
    final url =
        '$baseUri/FirmPeriods/GetCariHesapDetails/$tablePrefix/$tableSuffix/$clientRef';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => CariHesapDetail.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<Banka>> fetchBankaHesapDetails(String? tablePrefix, String? tableSuffix) async {
  final url = '$baseUri/FirmPeriods/GetBankaHesaplar/$tablePrefix/$tableSuffix';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Banka.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load banka hesap details');
  }
}

  Future<List<VirmanFisi>> fetchVirmanFisiDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/$invoice/44/44';
    try {
      final response = await http.get(Uri.parse(url));
   

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => VirmanFisi.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<BorcDekontu>> fetchBorcDekontuDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/$invoice/44/44';
    try {
      final response = await http.get(Uri.parse(url));
  

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => BorcDekontu.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<NakitTahsilat>> fetchNakitTahsilatDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/44/$tranno/44';
    try {
      final response = await http.get(Uri.parse(url));
    

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => NakitTahsilat.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<GelenHavale>> fetchGelenHavaleDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/44/$tranno/$logicalref';
    try {
      final response = await http.get(Uri.parse(url));


      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => GelenHavale.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<HizmetFaturasi>> fetchHizmetFaturasiDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/$invoice/44/44';
    try {
      final response = await http.get(Uri.parse(url));


      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => HizmetFaturasi.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<CekVeSenet>> fetchCekDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/$invoice/44/$logicalref';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => CekVeSenet.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<KrediKarti>> fetchKrediKartDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/$invoice/44/44';
    try {
      final response = await http.get(Uri.parse(url));


      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => KrediKarti.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<defaultCase>> fetchdefaultDetails(
      String? tablePrefix,
      String? tableSuffix,
      String? TrCode,
      int? invoice,
      String? tranno,
      int? logicalref) async {
    final url =
        '$baseUri/FirmPeriods/GetCariEkstreDetay/$tablePrefix/$tableSuffix/$TrCode/$invoice/44/44';
    try {
      final response = await http.get(Uri.parse(url));


      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => defaultCase.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cari hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load cari hesap details');
    }
  }

  Future<List<AlinanFatura>> fetchAlinanFaturalar(
      String tablePrefix, String tableSuffix) async {
    final url =
        '$baseUri/FirmPeriods/GetAlinanFatura/$tablePrefix/$tableSuffix';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => AlinanFatura.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load banka hesap details');
    }
  }

  Future<List<AlinanFatura>> fetchSatisFaturalar(
      String tablePrefix, String tableSuffix) async {
    final url = '$baseUri/FirmPeriods/GetSatisFatura/$tablePrefix/$tableSuffix';

    try {
      final response = await http.get(Uri.parse(url));


      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        print(jsonResponse.length);
        return jsonResponse.map((data) => AlinanFatura.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging
      throw Exception('Failed to load banka hesap details');
    }
  }

  Future<List<faturaDetay>> fetchFaturaDetay(
      String tablePrefix, String tableSuffix, int? id, int? tur) async {
    final url =
        '$baseUri/FirmPeriods/GetFaturaDetaylari/$tablePrefix/$tableSuffix/$id/$tur';

    try {
      final response = await http.get(Uri.parse(url));
  

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => faturaDetay.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e ewrwerwerwerwer'); // Debugging
      throw Exception(
          'Failed to load banka hesap detailssssssssssssssssssssssssssss');
    }
  }

  Future<List<Cek>> fetchCeks(String tablePrefix, String tableSuffix,
      String raportur // Single word, either specific or "Tümü"
      ) async {
    final List<Cek> allCeks =
        []; // Initialize an empty list to hold all Cek objects

    // Define the list of predefined values
    final List<String> predefinedValues = [
      'Portföydeki Çekler',
      'Portföydeki Senetler',
      'Ciro Edilen Çekler',
      'Ciro Edilen Senetler',
      'Tahsile(Takasa) Verilen Çekler',
      'Tahsile Verilen Senetler',
      'Teminata Verilen Çekler',
      'Teminata Verilen Senetler',
      'Kendi Çekimiz',
      'Kendi Senetlerimiz'
    ];

    // Check if raportur is "Tümü"
    if (raportur == "Tümü") {
      // Fetch data for all predefined values
      for (String value in predefinedValues) {
        final url =
            '$baseUri/FirmPeriods/GetCek/$value/$tablePrefix/$tableSuffix';

        try {
          final response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            List jsonResponse = json.decode(response.body);
            print(jsonResponse.length);
            // Add the fetched Cek objects to the allCeks list
            allCeks.addAll(
                jsonResponse.map((data) => Cek.fromJson(data)).toList());
          } else {
            print('Failed to load banka hesap details for $value');
          }
        } catch (e) {
          print(
              'Error occurred while fetching data for $value: $e'); // Debugging
        }
      }
    } else {
      // Fetch data for the specific raportur value
      final url =
          '$baseUri/FirmPeriods/GetCek/$raportur/$tablePrefix/$tableSuffix';

      try {
        final response = await http.get(Uri.parse(url));


        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          // Add the fetched Cek objects to the allCeks list
          allCeks
              .addAll(jsonResponse.map((data) => Cek.fromJson(data)).toList());
        } else {
          throw Exception('Failed to load banka hesap details');
        }
      } catch (e) {
        print(
            'Error occurred while fetching data for $raportur: $e'); // Debugging
        throw Exception('Failed to load banka hesap details');
      }
    }

    return allCeks; // Return the combined list
  }
  Future<List<HMalzeme>> HMalzemebilgileri(
      String tablePrefix, String tableSuffix) async {
    final url =
        '$baseUri/FirmPeriods/HmalzemeBilgisi/$tablePrefix/$tableSuffix';

    try {
      final response = await http.get(Uri.parse(url));

      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        return jsonResponse.map((data) => HMalzeme.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e ewrwerwerwerwer'); // Debugging
      throw Exception(
          'Failed to load banka hesap detailssssssssssssssssssssssssssss');
    }
  }
  Future<List<HangiMalzemeKimeSatildi>> SatilanMalzeme(
      String tablePrefix, String tableSuffix) async {
    final url =
        '$baseUri/FirmPeriods/SatilanMalzeme/$tablePrefix/$tableSuffix';

    try {
      final response = await http.get(Uri.parse(url));

      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        return jsonResponse.map((data) => HangiMalzemeKimeSatildi.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e ewrwerwerwerwer'); // Debugging
      throw Exception(
          'Failed to load banka hesap detailssssssssssssssssssssssssssss');
    }
  }
  Future<List<EnCokSatilanMalzeme>> fetchEnCokStailanMal(String? tablePrefix, String? tableSuffix,String? days) async {
  final url = '$baseUri/FirmPeriods/enCokSatilanMalzemeler/$tablePrefix/$tableSuffix/$days';
  print(url);
  final response = await http.get(Uri.parse(url));

  
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => EnCokSatilanMalzeme.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load cari hesaplar');
  }
}
Future<List<GunlukMalzemeSatisi>> 
fetchGunlukMalzemeSatisi(String? tablePrefix, String? tableSuffix,String? days) async {
  final url = '$baseUri/FirmPeriods/gunlukMalzemeSatisi/$tablePrefix/$tableSuffix/$days';

  final response = await http.get(Uri.parse(url));

  
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => GunlukMalzemeSatisi.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load cari hesaplar');
  }
}
Future<List<GunlukMalzemeAlisi>> fetchGunlukMalzemeAlisi(String? tablePrefix, String? tableSuffix,String? days) async {
  final url = '$baseUri/FirmPeriods/gunlukMalzemeAlisi/$tablePrefix/$tableSuffix/$days';

  final response = await http.get(Uri.parse(url));

  
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => GunlukMalzemeAlisi.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load cari hesaplar');
  }
}
  Future<List<TumMalzemeler>> TumMalzeme(
      String tablePrefix, String tableSuffix) async {
    final url =
        '$baseUri/FirmPeriods/TumMalzeme/$tablePrefix/$tableSuffix';

    try {
      final response = await http.get(Uri.parse(url));

      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        return jsonResponse.map((data) => TumMalzemeler.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e ewrwerwerwerwer'); // Debugging
      throw Exception(
          'Failed to load banka hesap detailssssssssssssssssssssssssssss');
    }
  }
  Future<List<Kullanicilar>> Tumkullanicilar(
      String tablePrefix, String tableSuffix) async {
    final url =
        '$baseUri/kullanici/Kullanicilar';

    try {
      final response = await http.get(Uri.parse(url));

      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        return jsonResponse.map((data) => Kullanicilar.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e ewrwerwerwerwer'); // Debugging
      throw Exception(
          'Failed to load banka hesap detailssssssssssssssssssssssssssss');
    }
  }
  Future<List<Raporlar>> TumRaporlar(
      String tablePrefix, String tableSuffix) async {
    final url =
        '$baseUri/kullanici/Raporlar';

    try {
      final response = await http.get(Uri.parse(url));
 
      
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
    
        return jsonResponse.map((data) => Raporlar.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load banka hesap details');
      }
    } catch (e) {
      print('Error occurred: $e ewrwerwerwerwer'); // Debugging
      throw Exception(
          'Failed to load banka hesap detailssssssssssssssssssssssssssss');
    }
  }



Future<List<bool>> Yetkiler(String tablePrefix, int id) async {
  final url = '$baseUri/kullanici/YetkiliMenuler/$id';

  try {
    // Perform the HTTP GET request
    final response = await http.get(Uri.parse(url));



    // Check if the response status is 200 OK
    if (response.statusCode == 200) {
      // Decode the JSON array response into a dynamic list
      List<dynamic> jsonResponse = json.decode(response.body);

      // Map each value (1 or 0) to its boolean equivalent (true or false)
      return jsonResponse.map<bool>((data) {
        if (data == 1) {
          return true;  // Map 1 to true
        } else if (data == 0) {
          return false; // Map 0 to false
        } else {
          // If you receive unexpected data, throw an error
          throw Exception('Unexpected value in response: $data');
        }
      }).toList();
    } else {
      // If the response is not 200, throw an error with the status code
      throw Exception('Failed to load YetkiliMenuler: ${response.statusCode}');
    }
  } catch (e) {
    // Catch any errors and print for debugging purposes
    print('Error occurred: $e');
    throw Exception('Failed to load YetkiliMenuler');
  }
}
Future<List<Raporlar>> KullaniciRaporlari(int id) async {
  final url = '$baseUri/kullanici/KullanicininYetkiliRaporlar/$id/1';

  try {
    final response = await http.get(Uri.parse(url));



    if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        print(response.body);
        return jsonResponse.map((data) => Raporlar.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Kullanici Raporlari: ${response.statusCode}');
    }
  } catch (e) {
    // Catch any errors and print for debugging purposes
    print('Error occurred: $e');
    throw Exception('Failed to load Kullanici Raporlari');
  }
}

Future<List<RaporYetkiler>> RaporYetkileri(int id) async {
  final url = '$baseUri/kullanici/YetkiliRaporlar/$id';

  try {
    final response = await http.get(Uri.parse(url));



    if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        print(response.body);
        return jsonResponse.map((data) => RaporYetkiler.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load YetkiliRaporlar: ${response.statusCode}');
    }
  } catch (e) {
    // Catch any errors and print for debugging purposes
    print('Error occurred: $e');
    throw Exception('Failed to load YetkiliRaporlar');
  }
}



  Future<bool> UpdateUser(int id, String username, String password, String lisansTarihi, String lisansBitisTarihi,List<bool> checkboxes,List<RaporYetkiler> raporlar) async {
  await _ensureBaseUriLoaded();
  final uri = Uri.parse('$baseUri/lisanslar/updateUser');
  try {
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'kullaniciAd': username,
        'sifre': password,
        'lisansTarihi': lisansTarihi,
        'lisansBitisTarihi': lisansBitisTarihi,
        'checkboxes': checkboxes,
        'raporYetkiler' : raporlar
      }),
    );

    if (response.statusCode == 200) {
      print("User updated successfully.");
      return true;
    } else {
      print("Failed to update user. Status code: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error updating user: $e");
    return false;
  }
}
Future<bool> UpdateRapor(int id, String raporAdi, String raporSorgusu) async {
  await _ensureBaseUriLoaded();
  final uri = Uri.parse('$baseUri/lisanslar/updateRapor');

  try {
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'rapor_id': id,
        'rapor_adi': raporAdi,
        'rapor_sorgusu': raporSorgusu,
        
      }),
    );

    if (response.statusCode == 200) {
      print("User updated successfully.");
      return true;
    } else {
      print("Failed to update user. Status code: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error updating user: $e");
    return false;
  }
}
Future<bool> DeleteUser(int id) async {
  await _ensureBaseUriLoaded();
  final uri = Uri.parse('$baseUri/lisanslar/deleteUser/$id');

  try {
        final response = await http.delete(uri);


    if (response.statusCode == 200) {
      print("User deleted successfully.");
      return true;
    } else {
      print("Failed to update user. Status code: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error updating user: $e");
    return false;
  }
}
Future<bool> DeleteRapor(int id) async {
  await _ensureBaseUriLoaded();
  final uri = Uri.parse('$baseUri/lisanslar/deleteRapor/$id');

  try {
        final response = await http.delete(uri);


    if (response.statusCode == 200) {
      print("User deleted successfully.");
      return true;
    } else {
      print("Failed to update user. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error updating user: $e");
    return false;
  }
}
void AddUser( String username, String password, String lisansTarihi, String lisansBitisTarihi,List<bool> menuler) async {
  await _ensureBaseUriLoaded();
  final uri = Uri.parse('$baseUri/lisanslar/addUser');
  print(uri);

  try {
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
  'id': 0,
  'kullaniciAdi': username,
  'sifre': password,
  'lisansTarihi': lisansTarihi,
  'lisansBitisTarihi': lisansBitisTarihi,
  'permissions': menuler // If backend expects integers
}),

    );

    if (response.statusCode == 200) {
      print("Response body: ${response.body}");

      print("User Added successfully.");
      return;
    } else {
      print("Failed to Add user. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return ;
    }
  } catch (e) {
    print("Error Adding user: $e");
    return ;
  }
}
void AddRapor(
    String raporAdi, String raporSorgusu) async {
  await _ensureBaseUriLoaded(); // Ensure base URI is loaded
  final uri = Uri.parse('$baseUri/kullanici/save-query'); // Replace with your actual API endpoint

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'rapor_adi': raporAdi,
        'rapor_sorgusu': raporSorgusu,
      }),
    );

    if (response.statusCode == 200) {
      print("Response body: ${response.body}");
      print("Rapor added successfully.");
      return;
    } else {
      print("Failed to add rapor. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return;
    }
  } catch (e) {
    print("Error adding rapor: $e");
    return;
  }
}
  Future<List<Map<String, dynamic>>> getDataTableForReport(String raporSorgusu, String table , String donem) async {
      await _ensureBaseUriLoaded();
    final uri = Uri.parse('$baseUri/kullanici/executeDynamicQuery'); // Replace with your actual API endpoint

  try {
    // Make the API request
   final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firma': table,
        'donem': donem,
        'queryTemplate':raporSorgusu
      }),
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List<dynamic>;
      print(response.body);
      if (jsonData.isEmpty) {
        return [];
      }

      // Map the response to List<Map<String, dynamic>> format
      List<Map<String, dynamic>> result = jsonData.map<Map<String, dynamic>>((row) {
        return Map<String, dynamic>.from(row as Map<String, dynamic>);
      }).toList();

      return result;
    } else {
      // Return an empty list if the status code is not 200
      return [];
    }
  } catch (e) {
    print(e);
    // Return an empty list if an exception occurs
    return [];
  }
}




}


/*8QL1kCqODJd8CRif/8uZpw==           8
ZXEnVV6XpBv2kyhjVAvuhg==           3*/