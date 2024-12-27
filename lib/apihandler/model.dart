

class Firma {
  final int firma;
  final String name;

  Firma({
    required this.firma,
    required this.name,
  });

  factory Firma.empty() => Firma(
        firma: 0,
        name: '',
      );

  factory Firma.fromJson(Map<String, dynamic> json) => Firma(
        firma: json['firma'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "firma": firma,
        "name": name,
      };
}

class Donem {
  final int donem;

  Donem({
    required this.donem,
  });

  factory Donem.empty() => Donem(
        donem: 0,
      );

  factory Donem.fromJson(Map<String, dynamic> json) => Donem(
        donem: json['donem'],
      );

  Map<String, dynamic> toJson() => {
        "donem": donem,
      };
}

class Kullanici {
  int id;
  String kullaniciAd;
  String kullaniciVasfi;
  String sifre;

  Kullanici({
    required this.id,
    required this.kullaniciAd,
    required this.sifre,
    required this.kullaniciVasfi
  });

  factory Kullanici.fromJson(Map<String, dynamic> json) => Kullanici(
        id: json["id"],
        kullaniciAd: json["kullanici_ad"],
        sifre: json["sifre"],
        kullaniciVasfi: json["kullanici_vasfi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kullanici_ad": kullaniciAd,
        "sifre": sifre,
        "kullanici_vasfi" : kullaniciVasfi
      };
}

class Lisnas {
  final int id;
  final String name;
  final String licenseStartDate;
  final String licenseEndDate;
  Lisnas({
    required this.id,
    required this.name,
    required this.licenseStartDate,
    required this.licenseEndDate,
  });

  factory Lisnas.fromJson(Map<String, dynamic> json) {
    return Lisnas(
      id: json['id'],
      name: json['kullanici_ad'],
      licenseStartDate: json['lisans_tarihi'],
      licenseEndDate: json['lisans_bitis_tarihi'],
    );
  }
}



class KasaDto {
  final int logicalRef;
  final String code;
  final String name;
  final double bakiye;

  KasaDto({
    required this.logicalRef,
    required this.code,
    required this.name,
    required this.bakiye,
  });

  factory KasaDto.fromJson(Map<String, dynamic> json) {
    return KasaDto(
      logicalRef: json['logicalref'],
      code: json['code'],
      name: json['name'],
      bakiye: json['bakiye'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logicalref': logicalRef,
      'code': code,
      'name': name,
      'bakiye': bakiye,
    };
  }
}
class KasaDetaylar {
  String? kasaAdi;
  String? cariHesap;
  String? islem;
  int? tutar;
  String? tarih;

  KasaDetaylar({this.kasaAdi, this.cariHesap, this.islem, this.tutar,this.tarih});

  KasaDetaylar.fromJson(Map<String, dynamic> json) {
    kasaAdi = json['kasa_adi'];
    cariHesap = json['cari_hesap'];
    islem = json['islem'];
    tutar = json['tutar'];
    tarih = json['tarih'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kasa_adi'] = this.kasaAdi;
    data['cari_hesap'] = this.cariHesap;
    data['islem'] = this.islem;
    data['tutar'] = this.tutar;
    data['tarih'] = this.tarih;

    return data;
  }
}
class CariHesap {
  final int logicalRef;
  final String code;
  final String name;
  final double bakiye;

  CariHesap({
    required this.logicalRef,
    required this.code,
    required this.name,
    required this.bakiye,
  });

  factory CariHesap.fromJson(Map<String, dynamic> json) {
    return CariHesap(
      logicalRef: json['logicalref'],
      code: json['code'],
      name: json['name'],
      bakiye: json['bakiye'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logicalref': logicalRef,
      'code': code,
      'name': name,
      'bakiye': bakiye,
    };
  }
}
class HareketliCariler {
  double? tutar;
  String? code;
  String? definition;
  String? tel;
  int? logicalref;

  HareketliCariler({this.tutar, this.code, this.definition, this.tel});

  HareketliCariler.fromJson(Map<String, dynamic> json) {
    tutar = json['tutar'].toDouble();
    code = json['code'];
    definition = json['definition'];
    tel = json['tel'];
    logicalref = json['logicalref'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tutar'] = this.tutar;
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['tel'] = this.tel;
    data['logicalref'] = this.logicalref;
    return data;
  }
}
class HareketsizCariler {
  String? code;
  String? definition;
  String? tel;
  int? logicalref;

  HareketsizCariler({this.code, this.definition, this.tel, this.logicalref});

  HareketsizCariler.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    definition = json['definition'];
    tel = json['tel'];
    logicalref = json['logicalref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['definition'] = this.definition;
    data['tel'] = this.tel;
    data['logicalref'] = this.logicalref;
    return data;
  }
}

class CariHesapDetail {
  String? date;
  String? trCode;
  double? amount;
  String? lineExp;
  double? trNet;
  double? totalVat;
  String? ficheNo;
  String? genExp1;
  String? clientDefinition;
  int? invoiceRef;
  int? sign;
  String? tranNo;
  int? clientRef;
  int? cancelled;

  CariHesapDetail({
    this.date,
    this.trCode,
    this.amount,
    this.lineExp,
    this.trNet,
    this.totalVat,
    this.ficheNo,
    this.genExp1,
    this.clientDefinition,
    this.invoiceRef,
    this.sign,
    this.tranNo,
    this.clientRef,
    this.cancelled,
  });

  CariHesapDetail.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    trCode = json['trCode'];
    amount = (json['amount'] is int)
        ? (json['amount'] as int).toDouble()
        : (json['amount'] as double?);
    lineExp = json['lineExp'];
    trNet = (json['trNet'] is int)
        ? (json['trNet'] as int).toDouble()
        : (json['trNet'] as double?);
    totalVat = (json['totalVat'] is int)
        ? (json['totalVat'] as int).toDouble()
        : (json['totalVat'] as double?);
    ficheNo = json['ficheNo'];
    genExp1 = json['genExp1'];
    clientDefinition = json['clientDefinition'];
    invoiceRef = json['invoiceRef'];
    sign = json['sign'];
    tranNo = json['tranNo'];
    clientRef = json['clientRef'];
    cancelled = json['cancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['trCode'] = trCode;
    data['amount'] = amount;
    data['lineExp'] = lineExp;
    data['trNet'] = trNet;
    data['totalVat'] = totalVat;
    data['ficheNo'] = ficheNo;
    data['genExp1'] = genExp1;
    data['clientDefinition'] = clientDefinition;
    data['invoiceRef'] = invoiceRef;
    data['sign'] = sign;
    data['tranNo'] = tranNo;
    data['clientRef'] = clientRef;
    data['cancelled'] = cancelled;
    return data;
  }
}

class Banka {
  String? banka;
  String? hesap;
  double? bakiye;
  int? logicalref;

  Banka({this.banka, this.hesap, this.bakiye,this.logicalref});

  Banka.fromJson(Map<String, dynamic> json) {
    banka = json['banka'];
    hesap = json['hesap'];
    bakiye = json['bakiye']?.toDouble();
     logicalref = json['logicalref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banka'] = this.banka;
    data['hesap'] = this.hesap;
    data['bakiye'] = this.bakiye;
    data['logicalref'] = this.logicalref;
    return data;
  }
}
class BankaDetaylari {
  String? bankaAdi;
  String? hesapAdi;
  String? islem;
  double? tutar;
  String? tarih;

  BankaDetaylari(
      {this.bankaAdi, this.hesapAdi, this.islem, this.tutar, this.tarih});

  BankaDetaylari.fromJson(Map<String, dynamic> json) {
    bankaAdi = json['banka_adi'];
    hesapAdi = json['hesap_adi'];
    islem = json['islem'];
    tutar = json['tutar']?.toDouble();;
    tarih = json['tarih'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banka_adi'] = this.bankaAdi;
    data['hesap_adi'] = this.hesapAdi;
    data['islem'] = this.islem;
    data['tutar'] = this.tutar;
    data['tarih'] = this.tarih;
    return data;
  }
}

class VirmanFisi {
  String? code;
  String? name;
  double? amount;
  int? sign;
  double? trnet;
  int? logicalref;

  VirmanFisi(
      {this.code,
      this.name,
      this.amount,
      this.sign,
      this.trnet,
      this.logicalref});

  VirmanFisi.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    amount = json['amount']?.toDouble();
    sign = json['sign'];
    trnet = json['trnet']?.toDouble();
    logicalref = json['logicalref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['sign'] = this.sign;
    data['trnet'] = this.trnet;
    data['logicalref'] = this.logicalref;
    return data;
  }
}

class BorcDekontu {
  int? logicalref;
  String? code;
  String? name;
  double? amount;
  double? trnet;
  int? clientref;
  int? sourcefref;
  int? modulenr;
  int? trcode;
  int? sign;

  BorcDekontu(
      {this.logicalref,
      this.code,
      this.name,
      this.amount,
      this.trnet,
      this.clientref,
      this.sourcefref,
      this.modulenr,
      this.trcode,
      this.sign});

  BorcDekontu.fromJson(Map<String, dynamic> json) {
    logicalref = json['logicalref'];
    code = json['code'];
    name = json['name'];
    amount = json['amount']?.toDouble();
    trnet = json['trnet']?.toDouble();
    clientref = json['clientref'];
    sourcefref = json['sourcefref'];
    modulenr = json['modulenr'];
    trcode = json['trcode'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logicalref'] = this.logicalref;
    data['code'] = this.code;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['trnet'] = this.trnet;
    data['clientref'] = this.clientref;
    data['sourcefref'] = this.sourcefref;
    data['modulenr'] = this.modulenr;
    data['trcode'] = this.trcode;
    data['sign'] = this.sign;
    return data;
  }
}

class NakitTahsilat {
  int? logicalRef;
  String? lineExp;
  double? amount;
  int? sign;
  int? clientRef;
  int? sourceFref;
  int? trCode;
  int? moduleNr;
  String? code;

  NakitTahsilat(
      {this.logicalRef,
      this.lineExp,
      this.amount,
      this.sign,
      this.clientRef,
      this.sourceFref,
      this.trCode,
      this.moduleNr,
      this.code});

  NakitTahsilat.fromJson(Map<String, dynamic> json) {
    logicalRef = json['logicalRef'];
    lineExp = json['lineExp'];
    amount = json['amount']?.toDouble();
    sign = json['sign'];
    clientRef = json['clientRef'];
    sourceFref = json['sourceFref'];
    trCode = json['trCode'];
    moduleNr = json['moduleNr'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logicalRef'] = this.logicalRef;
    data['lineExp'] = this.lineExp;
    data['amount'] = this.amount;
    data['sign'] = this.sign;
    data['clientRef'] = this.clientRef;
    data['sourceFref'] = this.sourceFref;
    data['trCode'] = this.trCode;
    data['moduleNr'] = this.moduleNr;
    data['code'] = this.code;
    return data;
  }
}

class GelenHavale {
  int? logicalRef;
  String? banka;
  String? name;
  String? code;
  String? lineExp;
  double? amount;
  int? clientRef;
  int? sign;
  int? trCode;
  int? moduleNr;
  String? tranNo;
  double? trnet;

  GelenHavale(
      {this.logicalRef,
      this.banka,
      this.name,
      this.code,
      this.lineExp,
      this.amount,
      this.clientRef,
      this.sign,
      this.trCode,
      this.moduleNr,
      this.tranNo,
      this.trnet});

  GelenHavale.fromJson(Map<String, dynamic> json) {
    logicalRef = json['logicalRef'];
    banka = json['banka'];
    name = json['name'];
    code = json['code'];
    lineExp = json['lineExp'];
    amount = json['amount']?.toDouble();
    clientRef = json['clientRef'];
    sign = json['sign'];
    trCode = json['trCode'];
    moduleNr = json['moduleNr'];
    tranNo = json['tranNo'];
    trnet = json['trnet']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logicalRef'] = this.logicalRef;
    data['banka'] = this.banka;
    data['name'] = this.name;
    data['code'] = this.code;
    data['lineExp'] = this.lineExp;
    data['amount'] = this.amount;
    data['clientRef'] = this.clientRef;
    data['sign'] = this.sign;
    data['trCode'] = this.trCode;
    data['moduleNr'] = this.moduleNr;
    data['tranNo'] = this.tranNo;
    data['trnet'] = this.trnet;
    return data;
  }
}

class HizmetFaturasi {
  String? code;
  String? name;
  double? amount;
  int? price;
  double? total;
  int? logicalRef;
  int? stockRef;
  int? invoiceRef;
  int? clientRef;
  int? cardClientRef;

  HizmetFaturasi(
      {this.code,
      this.name,
      this.amount,
      this.price,
      this.total,
      this.logicalRef,
      this.stockRef,
      this.invoiceRef,
      this.clientRef,
      this.cardClientRef});

  HizmetFaturasi.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    amount = json['amount']?.toDouble();
    price = json['price'];
    total = json['total']?.toDouble();
    logicalRef = json['logicalRef'];
    stockRef = json['stockRef'];
    invoiceRef = json['invoiceRef'];
    clientRef = json['clientRef'];
    cardClientRef = json['cardClientRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['total'] = this.total;
    data['logicalRef'] = this.logicalRef;
    data['stockRef'] = this.stockRef;
    data['invoiceRef'] = this.invoiceRef;
    data['clientRef'] = this.clientRef;
    data['cardClientRef'] = this.cardClientRef;
    return data;
  }
}

class CekVeSenet {
  String? code;
  String? name;
  double? total;
  int? logicalRef;
  int? sign;
  int? cardRef;
  int? moduleNr;
  int? ficheRef;

  CekVeSenet(
      {this.code,
      this.name,
      this.total,
      this.logicalRef,
      this.sign,
      this.cardRef,
      this.moduleNr,
      this.ficheRef});

  CekVeSenet.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    total = json['total']?.toDouble();
    logicalRef = json['logicalRef'];
    sign = json['sign'];
    cardRef = json['cardRef'];
    moduleNr = json['moduleNr'];
    ficheRef = json['ficheRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['total'] = this.total;
    data['logicalRef'] = this.logicalRef;
    data['sign'] = this.sign;
    data['cardRef'] = this.cardRef;
    data['moduleNr'] = this.moduleNr;
    data['ficheRef'] = this.ficheRef;
    return data;
  }
}

class KrediKarti {
  String? code;
  String? cardCode;
  String? name;
  double? amount;
  int? sign;

  KrediKarti({this.code, this.cardCode, this.name, this.amount, this.sign});

  KrediKarti.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    cardCode = json['cardCode'];
    name = json['name'];
    amount = json['amount']?.toDouble();
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['cardCode'] = this.cardCode;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['sign'] = this.sign;
    return data;
  }
}

class defaultCase {
  String? code;
  String? stGrpCode;
  String? name;
  int? amount;
  double? price;
  double? total; // Change to double to handle decimal values
  int? stockRef;
  int? stFicheRef;
  int? invoiceRef;
  int? clientRef;

  defaultCase(
      {this.code,
      this.stGrpCode,
      this.name,
      this.amount,
      this.price,
      this.total,
      this.stockRef,
      this.stFicheRef,
      this.invoiceRef,
      this.clientRef});

  defaultCase.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    stGrpCode = json['stGrpCode'];
    name = json['name'];
    amount = json['amount'];
    price = json['price']?.toDouble(); // Ensure price is a double
    total = json['total']?.toDouble(); // Ensure total is a double
    stockRef = json['stockRef'];
    stFicheRef = json['stFicheRef'];
    invoiceRef = json['invoiceRef'];
    clientRef = json['clientRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['stGrpCode'] = this.stGrpCode;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['total'] = this.total;
    data['stockRef'] = this.stockRef;
    data['stFicheRef'] = this.stFicheRef;
    data['invoiceRef'] = this.invoiceRef;
    data['clientRef'] = this.clientRef;
    return data;
  }
}

class AlinanFatura {
  int? logicalRef;
  String? date;
  String? ficheNo;
  String? trCode;
  String? definition;
  double? netTotal;
  int? cancelled;
  int? TrCodeNum;

  AlinanFatura(
      {this.logicalRef,
      this.date,
      this.ficheNo,
      this.trCode,
      this.definition,
      this.netTotal,
      this.cancelled,
      this.TrCodeNum});

  AlinanFatura.fromJson(Map<String, dynamic> json) {
    logicalRef = json['logicalRef'];
    date = json['date'];
    ficheNo = json['ficheNo'];
    trCode = json['trCode'];
    definition = json['definition_'];
    netTotal = json['netTotal'];
    cancelled = json['cancelled'];
    TrCodeNum = json['trCodeNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logicalRef'] = this.logicalRef;
    data['date'] = this.date;
    data['ficheNo'] = this.ficheNo;
    data['trCode'] = this.trCode;
    data['definition_'] = this.definition;
    data['netTotal'] = this.netTotal;
    data['cancelled'] = this.cancelled;
    data['trCodeNum'] = this.TrCodeNum;
    return data;
  }
}

class faturaDetay {
  int? logicalref;
  String? linetype;
  int? invoicelnno;
  int? amount;
  double? total;
  double? brmfyt;
  double? nettotal;
  double? distdisc;
  double? vatamnt;
  double? linenet;
  String? definitioN;

  faturaDetay(
      {this.logicalref,
      this.linetype,
      this.invoicelnno,
      this.amount,
      this.total,
      this.distdisc,
      this.vatamnt,
      this.linenet,
      this.definitioN});

  faturaDetay.fromJson(Map<String, dynamic> json) {
    logicalref = json['logicalref'];
    linetype = json['linetype'];
    invoicelnno = json['invoicelnno'];
    amount = json['amount'];
    total = json['total'];
    distdisc = json['distdisc'];
    vatamnt = json['vatamnt'];
    linenet = json['linenet'];
    definitioN = json['definitioN_'];
    brmfyt = json['brmfyt'];
    nettotal = json['nettotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logicalref'] = this.logicalref;
    data['linetype'] = this.linetype;
    data['invoicelnno'] = this.invoicelnno;
    data['amount'] = this.amount;
    data['total'] = this.total;
    data['distdisc'] = this.distdisc;
    data['vatamnt'] = this.vatamnt;
    data['linenet'] = this.linenet;
    data['definitioN_'] = this.definitioN;
    data['brmfyt'] = this.brmfyt;
    data['nettotal'] = this.nettotal;
    return data;
  }
}

class Cek {
  String? date;
  String? islemtur;
  String? durumu;
  String? portfoyno;
  String? borclu;
  String? bankname;
  String? vade;
  int? amount;

  Cek(
      {this.date,
      this.islemtur,
      this.durumu,
      this.portfoyno,
      this.borclu,
      this.bankname,
      this.vade,
      this.amount});

  Cek.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    islemtur = json['islemtur'];
    durumu = json['durumu'];
    portfoyno = json['portfoyno'];
    borclu = json['borclu'];
    bankname = json['bankname'];
    vade = json['vade'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['islemtur'] = this.islemtur;
    data['durumu'] = this.durumu;
    data['portfoyno'] = this.portfoyno;
    data['borclu'] = this.borclu;
    data['bankname'] = this.bankname;
    data['vade'] = this.vade;
    data['amount'] = this.amount;
    return data;
  }
}
class HMalzeme {
  String? code;
  String? name;

  HMalzeme({this.code, this.name});

  HMalzeme.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}


class HangiMalzemeKimeSatildi {
  String? stoKKODU;
  String? stoKADI;
  String? carIHESAP;
  String? faturANO;
  String? satiSELEMANI;
  double? miktar;
  double? bFIYAT;
  double? satiRTUTARI;
  double? kdv;
  double? satiRNETTUTARI;

  HangiMalzemeKimeSatildi(
      {this.stoKKODU,
      this.stoKADI,
      this.carIHESAP,
      this.faturANO,
      this.satiSELEMANI,
      this.miktar,
      this.bFIYAT,
      this.satiRTUTARI,
      this.kdv,
      this.satiRNETTUTARI});

  HangiMalzemeKimeSatildi.fromJson(Map<String, dynamic> json) {
    stoKKODU = json['stoK_KODU'];
    stoKADI = json['stoK_ADI'];
    carIHESAP = json['carI_HESAP'];
    faturANO = json['faturA_NO'];
    satiSELEMANI = json['satiS_ELEMANI'];
    miktar = json['miktar']?.toDouble();
    bFIYAT = json['b_FIYAT']?.toDouble();
    satiRTUTARI = json['satiR_TUTARI']?.toDouble();
    kdv = json['kdv']?.toDouble();
    satiRNETTUTARI = json['satiR_NET_TUTARI']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stoK_KODU'] = this.stoKKODU;
    data['stoK_ADI'] = this.stoKADI;
    data['carI_HESAP'] = this.carIHESAP;
    data['faturA_NO'] = this.faturANO;
    data['satiS_ELEMANI'] = this.satiSELEMANI;
    data['miktar'] = this.miktar;
    data['b_FIYAT'] = this.bFIYAT;
    data['satiR_TUTARI'] = this.satiRTUTARI;
    data['kdv'] = this.kdv;
    data['satiR_NET_TUTARI'] = this.satiRNETTUTARI;
    return data;
  }
}
class TumMalzemeler {
  int? logicalref;
  String? code;
  String? name;
  int? elde;

  TumMalzemeler({this.logicalref, this.code, this.name, this.elde});

  TumMalzemeler.fromJson(Map<String, dynamic> json) {
    logicalref = json['logicalref'];
    code = json['code'];
    name = json['name'];
    elde = json['elde'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logicalref'] = this.logicalref;
    data['code'] = this.code;
    data['name'] = this.name;
    data['elde'] = this.elde;
    return data;
  }
}
class EnCokSatilanCariler {
  double? tutar;
  String? name;
  int? logicalref;
  EnCokSatilanCariler({this.tutar, this.name,this.logicalref});

  EnCokSatilanCariler.fromJson(Map<String, dynamic> json) {
    tutar = json['tutar'];
    name = json['name'];
    logicalref = json['logicalref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tutar'] = this.tutar;
    data['name'] = this.name;
    data['logicalref'] = this.logicalref;
    return data;
  }
}
class EnCokSatilanMalzeme {
  double? tutar;
  String? name;

  EnCokSatilanMalzeme({this.tutar, this.name});

  EnCokSatilanMalzeme.fromJson(Map<String, dynamic> json) {
    tutar = json['tutar'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tutar'] = this.tutar;
    data['name'] = this.name;
    return data;
  }
}
class GunlukMalzemeSatisi {
  String? name;
  int? miktar;
  double? tutar;
  String? birim;

  GunlukMalzemeSatisi({this.name, this.miktar, this.tutar, this.birim});

  GunlukMalzemeSatisi.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    miktar = (json['miktar'] as num?)?.toInt();
  tutar = (json['tutar'] as num?)?.toDouble();
  birim = json['birim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['miktar'] = this.miktar?.toInt();
    data['tutar'] = this.tutar?.toDouble();
    data['birim'] = this.birim;
    return data;
  }
}

class GunlukMalzemeAlisi {
  String? name;
  int? miktar;
  double? tutar;
  String? birim;

  GunlukMalzemeAlisi({this.name, this.miktar, this.tutar, this.birim});

  GunlukMalzemeAlisi.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    miktar = json['miktar']?.toInt();
    tutar = json['tutar']?.toDouble();
    birim = json['birim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['miktar'] = this.miktar?.toInt();
    data['tutar'] = this.tutar?.toDouble();
    data['birim'] = this.birim;
    return data;
  }
}

class Kullanicilar {
  int? id;
  String? kullaniciAd;
  String? sifre;
  String? lisansTarihi;
  String? lisansBitisTarihi;
  List<bool>? yetkiler;

  Kullanicilar(
      {this.id,
      this.kullaniciAd,
      this.sifre,
      this.lisansTarihi,
      this.lisansBitisTarihi,
      this.yetkiler});

  Kullanicilar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kullaniciAd = json['kullanici_ad'];
    sifre = json['sifre'];
    lisansTarihi = json['lisans_tarihi'];
    lisansBitisTarihi = json['lisans_bitis_tarihi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kullanici_ad'] = this.kullaniciAd;
    data['sifre'] = this.sifre;
    data['lisans_tarihi'] = this.lisansTarihi;
    data['lisans_bitis_tarihi'] = this.lisansBitisTarihi;
    return data;
  }
}
class Raporlar {
  int? raporId;
  String? raporAdi;
  String? raporSorgusu;

  Raporlar({this.raporId, this.raporAdi, this.raporSorgusu});

  Raporlar.fromJson(Map<String, dynamic> json) {
    raporId = json['rapor_id'];
    raporAdi = json['rapor_adi'];
    raporSorgusu = json['rapor_sorgusu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rapor_id'] = this.raporId;
    data['rapor_adi'] = this.raporAdi;
    data['rapor_sorgusu'] = this.raporSorgusu;
    return data;
  }
}






class RaporYetkiler {
  int? yetki;
  int? raporId;
  String? raporAdi;
  String? raporSorgusu;

  RaporYetkiler({this.yetki, this.raporId, this.raporAdi, this.raporSorgusu});

  RaporYetkiler.fromJson(Map<String, dynamic> json) {
    yetki = json['yetki'];
    raporId = json['rapor_id'];
    raporAdi = json['rapor_adi'];
    raporSorgusu = json['rapor_sorgusu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yetki'] = this.yetki;
    data['rapor_id'] = this.raporId;
    data['rapor_adi'] = this.raporAdi;
    data['rapor_sorgusu'] = this.raporSorgusu;
    return data;
  }
}
class RaporYetkiler1 {
  int? yetki;
  int? raporId;
  String? raporAdi;
  String? raporSorgusu;

  RaporYetkiler1({this.yetki, this.raporId, this.raporAdi, this.raporSorgusu});

  RaporYetkiler1.fromJson(Map<String, dynamic> json) {
    yetki = json['yetki'];
    raporId = json['raporId'];
    raporAdi = json['raporAdi'];
    raporSorgusu = json['raporSorgusu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yetki'] = this.yetki;
    data['raporId'] = this.raporId;
    data['raporAdi'] = this.raporAdi;
    data['raporSorgusu'] = this.raporSorgusu;
    return data;
  }
}
