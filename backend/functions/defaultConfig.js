const admin = require('firebase-admin')
const functions = require('firebase-functions')

const db = admin.firestore();

exports.defaultConfig = functions.https.onRequest(async (req, res) => {
    
    const quran = [
        {
            "soura": "الفَاتِحَة",
            "numberOfAyat": 7
        },
        {
            "soura": "البَقَرَة",
            "numberOfAyat": 286
        },
        {
            "soura": "آل عِمرَان",
            "numberOfAyat": 200
        },
        {
            "soura": "النِّسَاء",
            "numberOfAyat": 176
        },
        {
            "soura": "المَائدة",
            "numberOfAyat": 120
        },
        {
            "soura": "الأنعَام",
            "numberOfAyat": 165
        },
        {
            "soura": "الأعرَاف",
            "numberOfAyat": 206
        },
        {
            "soura": "الأنفَال",
            "numberOfAyat": 75
        },
        {
            "soura": "التوبَة",
            "numberOfAyat": 129
        },
        {
            "soura": "يُونس",
            "numberOfAyat": 109
        },
        {
            "soura": "هُود",
            "numberOfAyat": 123
        },
        {
            "soura": "يُوسُف",
            "numberOfAyat": 111
        },
        {
            "soura": "الرَّعْد",
            "numberOfAyat": 43
        },
        {
            "soura": "إبراهِيم",
            "numberOfAyat": 52
        },
        {
            "soura": "الحِجْر",
            "numberOfAyat": 99
        },
        {
            "soura": "النَّحْل",
            "numberOfAyat": 128
        },
        {
            "soura": "الإسْرَاء",
            "numberOfAyat": 111
        },
        {
            "soura": "الكهْف",
            "numberOfAyat": 110
        },
        {
            "soura": "مَريَم",
            "numberOfAyat": 98
        },
        {
            "soura": "طه",
            "numberOfAyat": 135
        },
        {
            "soura": "الأنبيَاء",
            "numberOfAyat": 112
        },
        {
            "soura": "الحَج",
            "numberOfAyat": 78
        },
        {
            "soura": "المُؤمنون",
            "numberOfAyat": 118
        },
        {
            "soura": "النُّور",
            "numberOfAyat": 64
        },
        {
            "soura": "الفُرْقان",
            "numberOfAyat": 77
        },
        {
            "soura": "الشُّعَرَاء",
            "numberOfAyat": 227
        },
        {
            "soura": "النَّمْل",
            "numberOfAyat": 93
        },
        {
            "soura": "القَصَص",
            "numberOfAyat": 88
        },
        {
            "soura": "العَنكبوت",
            "numberOfAyat": 69
        },
        {
            "soura": "الرُّوم",
            "numberOfAyat": 60
        },
        {
            "soura": "لقمَان",
            "numberOfAyat": 34
        },
        {
            "soura": "السَّجدَة",
            "numberOfAyat": 30
        },
        {
            "soura": "الأحزَاب",
            "numberOfAyat": 73
        },
        {
            "soura": "سَبَأ",
            "numberOfAyat": 54
        },
        {
            "soura": "فَاطِر",
            "numberOfAyat": 45
        },
        {
            "soura": "يس",
            "numberOfAyat": 83
        },
        {
            "soura": "الصَّافات",
            "numberOfAyat": 182
        },
        {
            "soura": "ص",
            "numberOfAyat": 88
        },
        {
            "soura": "الزُّمَر",
            "numberOfAyat": 75
        },
        {
            "soura": "غَافِر",
            "numberOfAyat": 85
        },
        {
            "soura": "فُصِّلَتْ",
            "numberOfAyat": 54
        },
        {
            "soura": "الشُّورَى",
            "numberOfAyat": 53
        },
        {
            "soura": "الزُّخْرُف",
            "numberOfAyat": 89
        },
        {
            "soura": "الدخَان",
            "numberOfAyat": 59
        },
        {
            "soura": "الجَاثيَة",
            "numberOfAyat": 37
        },
        {
            "soura": "الأحْقاف",
            "numberOfAyat": 35
        },
        {
            "soura": "محَمَّد",
            "numberOfAyat": 38
        },
        {
            "soura": "الفَتْح",
            "numberOfAyat": 29
        },
        {
            "soura": "الحُجرَات",
            "numberOfAyat": 18
        },
        {
            "soura": "ق",
            "numberOfAyat": 45
        },
        {
            "soura": "الذَّاريَات",
            "numberOfAyat": 60
        },
        {
            "soura": "الطُّور",
            "numberOfAyat": 49
        },
        {
            "soura": "النَّجْم",
            "numberOfAyat": 62
        },
        {
            "soura": "القَمَر",
            "numberOfAyat": 55
        },
        {
            "soura": "الرَّحمن",
            "numberOfAyat": 78
        },
        {
            "soura": "الوَاقِعَة",
            "numberOfAyat": 96
        },
        {
            "soura": "الحَديد",
            "numberOfAyat": 29
        },
        {
            "soura": "المجَادلة",
            "numberOfAyat": 22
        },
        {
            "soura": "الحَشر",
            "numberOfAyat": 24
        },
        {
            "soura": "المُمتَحنَة",
            "numberOfAyat": 13
        },
        {
            "soura": "الصَّف",
            "numberOfAyat": 14
        },
        {
            "soura": "الجُمُعَة",
            "numberOfAyat": 11
        },
        {
            "soura": "المنَافِقون",
            "numberOfAyat": 11
        },
        {
            "soura": "التغَابُن",
            "numberOfAyat": 18
        },
        {
            "soura": "الطلَاق",
            "numberOfAyat": 12
        },
        {
            "soura": "التحْريم",
            "numberOfAyat": 12
        },
        {
            "soura": "المُلْك",
            "numberOfAyat": 30
        },
        {
            "soura": "القَلَم",
            "numberOfAyat": 52
        },
        {
            "soura": "الحَاقَّة",
            "numberOfAyat": 52
        },
        {
            "soura": "المعَارج",
            "numberOfAyat": 44
        },
        {
            "soura": "نُوح",
            "numberOfAyat": 28
        },
        {
            "soura": "الجِن",
            "numberOfAyat": 28
        },
        {
            "soura": "المُزَّمِّل",
            "numberOfAyat": 20
        },
        {
            "soura": "المُدَّثِّر",
            "numberOfAyat": 56
        },
        {
            "soura": "القِيَامَة",
            "numberOfAyat": 40
        },
        {
            "soura": "الإنسَان",
            "numberOfAyat": 31
        },
        {
            "soura": "المُرسَلات",
            "numberOfAyat": 50
        },
        {
            "soura": "النَّبَأ",
            "numberOfAyat": 40
        },
        {
            "soura": "النّازعَات",
            "numberOfAyat": 46
        },
        {
            "soura": "عَبَس",
            "numberOfAyat": 42
        },
        {
            "soura": "التَّكوير",
            "numberOfAyat": 29
        },
        {
            "soura": "الانفِطار",
            "numberOfAyat": 19
        },
        {
            "soura": "المطفِّفِين",
            "numberOfAyat": 36
        },
        {
            "soura": "الانْشِقَاق",
            "numberOfAyat": 25
        },
        {
            "soura": "البرُوج",
            "numberOfAyat": 22
        },
        {
            "soura": "الطَّارِق",
            "numberOfAyat": 17
        },
        {
            "soura": "الأَعْلى",
            "numberOfAyat": 19
        },
        {
            "soura": "الغَاشِية",
            "numberOfAyat": 26
        },
        {
            "soura": "الفَجْر",
            "numberOfAyat": 30
        },
        {
            "soura": "البَلَد",
            "numberOfAyat": 20
        },
        {
            "soura": "الشَّمْس",
            "numberOfAyat": 15
        },
        {
            "soura": "الليْل",
            "numberOfAyat": 21
        },
        {
            "soura": "الضُّحَى",
            "numberOfAyat": 11
        },
        {
            "soura": "الشَّرْح",
            "numberOfAyat": 8
        },
        {
            "soura": "التِّين",
            "numberOfAyat": 8
        },
        {
            "soura": "العَلَق",
            "numberOfAyat": 19
        },
        {
            "soura": "القَدْر",
            "numberOfAyat": 5
        },
        {
            "soura": "البَينَة",
            "numberOfAyat": 8
        },
        {
            "soura": "الزلزَلة",
            "numberOfAyat": 8
        },
        {
            "soura": "العَادِيات",
            "numberOfAyat": 11
        },
        {
            "soura": "القَارِعة",
            "numberOfAyat": 11
        },
        {
            "soura": "التَّكَاثر",
            "numberOfAyat": 8
        },
        {
            "soura": "العَصْر",
            "numberOfAyat": 3
        },
        {
            "soura": "الهُمَزَة",
            "numberOfAyat": 9
        },
        {
            "soura": "الفِيل",
            "numberOfAyat": 5
        },
        {
            "soura": "قُرَيْش",
            "numberOfAyat": 4
        },
        {
            "soura": "المَاعُون",
            "numberOfAyat": 7
        },
        {
            "soura": "الكَوْثَر",
            "numberOfAyat": 3
        },
        {
            "soura": "الكَافِرُون",
            "numberOfAyat": 6
        },
        {
            "soura": "النَّصر",
            "numberOfAyat": 3
        },
        {
            "soura": "المَسَد",
            "numberOfAyat": 5
        },
        {
            "soura": "الإخْلَاص",
            "numberOfAyat": 4
        },
        {
            "soura": "الفَلَق",
            "numberOfAyat": 5
        },
        {
            "soura": "النَّاس",
            "numberOfAyat": 6
        }
    ];

    const data = {
        nextUserReadableId: 1000, nextCenterReadableId: 1000, nextHalaqaReadableId: 1000, totalNumberOfAyat
            : 6236, quran: quran,
    };

    // Push the new message into Cloud Firestore using the Firebase Admin SDK.
    const writeResult = await db.collection('globalConfiguration').doc('globalConfiguration').set(data);
    // Send back a message that we've succesfully written the message
    res.json({ result: `Message with ID: ${writeResult.id} added.` });


});
