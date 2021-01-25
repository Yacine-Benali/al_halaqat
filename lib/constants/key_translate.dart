class KeyTranslate {
  static const Map<String, String> isoCountryToArabic = {
    "AD": "أندورا",
    "AE": "الإمارات العربية المتحدة",
    "AF": "أفغانستان",
    "AG": "أنتيغوا وباربودا",
    "AI": "أنغويلا",
    "AL": "ألبانيا",
    "AM": "أرمينيا",
    "AO": "أنغولا",
    "AQ": "القارة القطبية الجنوبية",
    "AR": "الأرجنتين",
    "AS": "ساموا الأمريكية",
    "AT": "النمسا",
    "AU": "أستراليا",
    "AW": "أروبا",
    "AX": "أولند",
    "AZ": "أذربيجان",
    "BA": "البوسنة والهرسك",
    "BB": "باربادوس",
    "BD": "بنغلاديش",
    "BE": "بلجيكا",
    "BF": "بوركينا فاسو",
    "BG": "بلغاريا",
    "BH": "البحرين",
    "BI": "بوروندي",
    "BJ": "بنين",
    "BL": "سان بارتليمي",
    "BM": "برمودا",
    "BN": "بروناي",
    "BO": "بوليفيا",
    "BQ": "الجزر الكاريبية الهولندية",
    "BR": "البرازيل",
    "BS": "باهاماس",
    "BT": "بوتان",
    "BV": "جزيرة بوفيه",
    "BW": "بوتسوانا",
    "BY": "بيلاروس",
    "BZ": "بليز",
    "CA": "كندا",
    "CC": "جزر كوكس",
    "CD": "جمهورية الكونغو الديمقراطية",
    "CF": "جمهورية أفريقيا الوسطى",
    "CG": "جمهورية الكونغو",
    "CH": "سويسرا",
    "CI": "ساحل العاج",
    "CK": "جزر كوك",
    "CL": "تشيلي",
    "CM": "الكاميرون",
    "CN": "الصين",
    "CO": "كولومبيا",
    "CR": "كوستاريكا",
    "CU": "كوبا",
    "CV": "الرأس الأخضر",
    "CW": "كوراساو",
    "CX": "جزيرة عيد الميلاد",
    "CY": "قبرص",
    "CZ": "التشيك",
    "DE": "ألمانيا",
    "DJ": "جيبوتي",
    "DK": "الدنمارك",
    "DM": "دومينيكا",
    "DO": "جمهورية الدومينيكان",
    "DZ": "الجزائر",
    "EC": "الإكوادور",
    "EE": "إستونيا",
    "EG": "مصر",
    "EH": "الصحراء الغربية",
    "ER": "إريتريا",
    "ES": "إسبانيا",
    "ET": "إثيوبيا",
    "FI": "فنلندا",
    "FJ": "فيجي",
    "FK": "جزر فوكلاند",
    "FM": "ولايات ميكرونيسيا المتحدة",
    "FO": "جزر فارو",
    "FR": "فرنسا",
    "GA": "الغابون",
    "GB": "المملكة المتحدة",
    "GD": "غرينادا",
    "GE": "جورجيا",
    "GF": "غويانا الفرنسية",
    "GG": "غيرنزي",
    "GH": "غانا",
    "GI": "جبل طارق",
    "GL": "غرينلاند",
    "GM": "غامبيا",
    "GN": "غينيا",
    "GP": "غوادلوب",
    "GQ": "غينيا الاستوائية",
    "GR": "اليونان",
    "GS": "جورجيا الجنوبية وجزر ساندويتش الجنوبية",
    "GT": "غواتيمالا",
    "GU": "غوام",
    "GW": "غينيا بيساو",
    "GY": "غيانا",
    "HK": "هونغ كونغ",
    "HM": "جزيرة هيرد وجزر ماكدونالد",
    "HN": "هندوراس",
    "HR": "كرواتيا",
    "HT": "هايتي",
    "HU": "المجر",
    "ID": "إندونيسيا",
    "IE": "جمهورية أيرلندا",
    "IL": "إسرائيل",
    "IM": "جزيرة مان",
    "IN": "الهند",
    "IO": "إقليم المحيط الهندي البريطاني",
    "IQ": "العراق",
    "IR": "إيران",
    "IS": "آيسلندا",
    "IT": "إيطاليا",
    "JE": "جيرزي",
    "JM": "جامايكا",
    "JO": "الأردن",
    "JP": "اليابان",
    "KE": "كينيا",
    "KG": "قيرغيزستان",
    "KH": "كمبوديا",
    "KI": "كيريباتي",
    "KM": "جزر القمر",
    "KN": "سانت كيتس ونيفيس",
    "KP": "كوريا الشمالية",
    "KR": "كوريا الجنوبية",
    "KW": "الكويت",
    "KY": "جزر كايمان",
    "KZ": "كازاخستان",
    "LA": "لاوس",
    "LB": "لبنان",
    "LC": "سانت لوسيا",
    "LI": "ليختنشتاين",
    "LK": "سريلانكا",
    "LR": "ليبيريا",
    "LS": "ليسوتو",
    "LT": "ليتوانيا",
    "LU": "لوكسمبورغ",
    "LV": "لاتفيا",
    "LY": "ليبيا",
    "MA": "المغرب",
    "MC": "موناكو",
    "MD": "مولدوفا",
    "ME": "الجبل الأسود",
    "MF": "سانت مارتن الفرنسية",
    "MG": "مدغشقر",
    "MH": "جزر مارشال",
    "MK": "جمهورية مقدونيا",
    "ML": "مالي",
    "MM": "بورما",
    "MN": "منغوليا",
    "MO": "ماكاو",
    "MP": "جزر ماريانا الشمالية",
    "MQ": "مارتينيك",
    "MR": "موريتانيا",
    "MS": "مونتسرات",
    "MT": "مالطا",
    "MU": "موريشيوس",
    "MV": "جزر المالديف",
    "MW": "مالاوي",
    "MX": "المكسيك",
    "MY": "ماليزيا",
    "MZ": "موزمبيق",
    "NA": "ناميبيا",
    "NC": "كاليدونيا الجديدة",
    "NE": "النيجر",
    "NF": "جزيرة نورفولك",
    "NG": "نيجيريا",
    "NI": "نيكاراغوا",
    "NL": "هولندا",
    "NO": "النرويج",
    "NP": "نيبال",
    "NR": "ناورو",
    "NU": "نييوي",
    "NZ": "نيوزيلندا",
    "OM": "سلطنة عمان",
    "PA": "بنما",
    "PE": "بيرو",
    "PF": "بولينزيا الفرنسية",
    "PG": "بابوا غينيا الجديدة",
    "PH": "الفلبين",
    "PK": "باكستان",
    "PL": "بولندا",
    "PM": "سان بيير وميكلون",
    "PN": "جزر بيتكيرن",
    "PR": "بورتوريكو",
    "PS": "دولة فلسطين",
    "PT": "البرتغال",
    "PW": "بالاو",
    "PY": "باراغواي",
    "QA": "قطر",
    "RE": "لا ريونيون",
    "RO": "رومانيا",
    "RS": "صربيا",
    "RU": "روسيا",
    "RW": "رواندا",
    "SA": "السعودية",
    "SB": "جزر سليمان",
    "SC": "سيشل",
    "SD": "السودان",
    "SE": "السويد",
    "SG": "سنغافورة",
    "SH": "سانت هيلينا وأسينشين وتريستان دا كونا",
    "SI": "سلوفينيا",
    "SJ": "سفالبارد ويان ماين",
    "SK": "سلوفاكيا",
    "SL": "سيراليون",
    "SM": "سان مارينو",
    "SN": "السنغال",
    "SO": "الصومال",
    "SR": "سورينام",
    "SS": "جنوب السودان",
    "ST": "ساو تومي وبرينسيب",
    "SV": "السلفادور",
    "SX": "سينت مارتن",
    "SY": "سوريا",
    "SZ": "سوازيلاند",
    "TC": "جزر توركس وكايكوس",
    "TD": "تشاد",
    "TF": "أراض فرنسية جنوبية وأنتارتيكية",
    "TG": "توغو",
    "TH": "تايلاند",
    "TJ": "طاجيكستان",
    "TK": "توكلو",
    "TL": "تيمور الشرقية",
    "TM": "تركمانستان",
    "TN": "تونس",
    "TO": "تونغا",
    "TR": "تركيا",
    "TT": "ترينيداد وتوباغو",
    "TV": "توفالو",
    "TW": "تايوان",
    "TZ": "تنزانيا",
    "UA": "أوكرانيا",
    "UG": "أوغندا",
    "UM": "جزر الولايات المتحدة الصغيرة النائية",
    "US": "الولايات المتحدة",
    "UY": "الأوروغواي",
    "UZ": "أوزبكستان",
    "VA": "الفاتيكان",
    "VC": "سانت فنسنت والجرينادين",
    "VE": "فنزويلا",
    "VG": "الجزر العذراء البريطانية",
    "VI": "جزر العذراء الأمريكية",
    "VN": "فيتنام",
    "VU": "فانواتو",
    "WF": "والس وفوتونا",
    "WS": "ساموا",
    "YE": "اليمن",
    "YT": "مايوت",
    "ZA": "جنوب أفريقيا",
    "ZM": "زامبيا",
    "ZW": "زيمبابوي",
  };

  static const Map<String, String> sort = {
    'sortByName': 'أب',
    'sortById': '12',
  };
  static const List<String> educationalLevel = [
    'الصف الأول',
    'الصف الثاني',
    'الصف الثالث',
    'الصف الرابع',
    'الصف الخامس',
    'الصف السادس',
    'الصف السابع',
    'الصف الثامن',
    'الصف التاسع',
    'الصف العاشر',
    'الصف الحادي عشر',
    'الصف الثاني عشر',
    //'جامعي',
    'ماجستير',
    'دكتوراة',
    'مهني',
    'أخرى',
  ];
  static const Map<String, String> gaHalaqatState = {
    'approved': 'نشطة',
    'archived': 'مؤرشفة',
    'deleted': 'محذوفة',
  };

  static const Map<String, String> adminHalaqatState = {
    'approved': 'نشطة',
    'archived': 'مؤرشفة',
  };

  static const Map<String, String> teacherStudentState = {
    'approved': 'نشطاء',
    'archived': 'مؤرشفين ',
  };

  static const Map<String, String> actionsList = {
    'edit': 'تعديل',
    'archive': 'أرشفة',
    'delete': 'حذف',
    'reApprove': 'اعادة تفعيل',
    'aboutCenter': 'حول المركز',
    'aboutAdmin': 'حول المشرف',
    'findAdmins': 'مشرفو المركز'
  };

  static const Map<String, String> gaAdminsState = {
    'approved': 'نشط',
    'archived': 'مؤرشف',
    'deleted': 'محذوف',
    'empty': 'بدون حالة',
  };

  static const Map<String, String> gaCenterState = {
    'approved': 'نشطة',
    'archived': 'مؤرشفة',
    'deleted': 'محذوفة',
  };

  static const Map<String, String> gaGaState = {
    'approved': 'نشطاء',
    'archived': 'مؤرشفين ',
    'deleted': 'محذوفين ',
  };

  static const Map<String, String> gaStudentsState = {
    'approved': 'نشطاء',
    'archived': 'مؤرشفين ',
    'deleted': 'محذوفين ',
  };

  static const Map<String, String> adminStudentsState = {
    'approved': 'نشطاء',
    'archived': 'مؤرشفين ',
    'deleted': 'محذوفين ',
  };

  static const Map<String, String> adminTeachersState = {
    'approved': 'نشطاء',
    'archived': 'مؤرشفين ',
  };
  static const Map<String, String> gaTeachersState = {
    'approved': 'نشطاء',
    'archived': 'مؤرشفين ',
    'deleted': 'محذوفين ',
  };

  static const Map<String, String> requestsStateList = {
    'pending': 'معلقة',
    'approved': 'مقبولة',
    'disapproved': 'مرفوضة',
  };

  static const Map<String, String> reportsState = {
    'approved': 'نشطاء',
    'archived': 'مؤرشفين ',
    'deleted': 'محذوفين ',
    'empty': 'بدون حالة',
    'pendingWithCenter': 'قيد الانتظار',
    'pending': 'قيد الانتظار',
  };

  static const Map<String, String> centerState = {
    'approved': 'نشط',
    'archived': 'مؤرشف ',
    'deleted': 'محذوف ',
    'empty': 'بدون حالة',
    'pendingWithCenter': 'قيد الانتظار',
    'pending': 'قيد الانتظار',
  };

  static const Map<String, String> createUserAuthType = {
    'usernameAndPassword': 'اسم  المستخدم',
    'emailAndPassword': 'إيمايل',
  };

  static const Map<String, String> attendanceState = {
    'present': 'حاضر',
    'latee': 'متأخر',
    'absent': 'غائب',
    'absentWithExecuse': 'غائب بعذر',
  };

  static const Map<String, String> instanceActions = {
    'delete': 'حذف',
    'note': 'ملاحظة',
  };

  static const Map<String, String> logObjectNature = {
    '': '',
    'maleStudent': 'الطالب',
    'femaleStudent': 'الطالبة',
    'maleTeacher': 'المعلم',
    'femaleTeacher': 'المعلمة',
    'halaqa': 'الحلقة',
    'instance': 'جلسة في الحلقة',
  };

  static const Map<String, String> logActions = {
    'add': 'أضاف',
    'edit': 'عدل',
    'delete': 'حذف',
    'join-existing': 'يود الإنضمام'
  };
}
