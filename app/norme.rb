norms_data = [
  # =========================
  # PRIPREMNI RADOVI – SJEČENJE DRVEĆA I ŠIBLJA
  # =========================
  {
    name: "Sječenje drveća i šiblja – meko drvo, prečnik 20–30 cm",
    description: "Ručno sječenje drveća i šiblja (meko drvo), prečnik stabla 20–30 cm, pripremni radovi.",
    info: "pripremni radovi – sječenje drveća i šiblja",
    norm_type: :worker,
    subtype: :unskilled,  # radnik klase RII
    unit_of_measure: "kom",
    norm_value: 2.1,
    tags: ["pripremni radovi", "sječenje", "drveća", "šiblja", "ručni rad", "meko"],
    info_norm: false
  },
  {
    name: "Sječenje drveća i šiblja – meko drvo, prečnik 30–50 cm",
    description: "Ručno sječenje drveća i šiblja (meko drvo), prečnik stabla 30–50 cm, pripremni radovi.",
    info: "pripremni radovi – sječenje drveća i šiblja",
    norm_type: :worker,
    subtype: :unskilled,  # radnik klase RII
    unit_of_measure: "kom",
    norm_value: 4.8,
    tags: ["pripremni radovi", "sječenje", "drveća", "šiblja", "ručni rad", "meko"],
    info_norm: false
  },
  {
    name: "Sječenje drveća i šiblja – meko drvo, prečnik više od 50 cm",
    description: "Ručno sječenje drveća i šiblja (meko drvo), prečnik stabla više od 50 cm, pripremni radovi.",
    info: "pripremni radovi – sječenje drveća i šiblja",
    norm_type: :worker,
    subtype: :unskilled,  # radnik klase RII
    unit_of_measure: "kom",
    norm_value: 16.0,
    tags: ["pripremni radovi", "sječenje", "drveća", "šiblja", "ručni rad", "meko"],
    info_norm: false
  },
  {
    name: "Sječenje drveća i šiblja – tvrdo drvo, prečnik 20–30 cm",
    description: "Ručno sječenje drveća i šiblja (tvrdo drvo), prečnik stabla 20–30 cm, pripremni radovi.",
    info: "pripremni radovi – sječenje drveća i šiblja",
    norm_type: :worker,
    subtype: :unskilled,  # radnik klase RII
    unit_of_measure: "kom",
    norm_value: 2.8,
    tags: ["pripremni radovi", "sječenje", "drveća", "šiblja", "ručni rad", "tvrdo"],
    info_norm: false
  },
  {
    name: "Sječenje drveća i šiblja – tvrdo drvo, prečnik 30–50 cm",
    description: "Ručno sječenje drveća i šiblja (tvrdo drvo), prečnik stabla 30–50 cm, pripremni radovi.",
    info: "pripremni radovi – sječenje drveća i šiblja",
    norm_type: :worker,
    subtype: :unskilled,  # radnik klase RII
    unit_of_measure: "kom",
    norm_value: 8.0,
    tags: ["pripremni radovi", "sječenje", "drveća", "šiblja", "ručni rad", "tvrdo"],
    info_norm: false
  },
  {
    name: "Sječenje drveća i šiblja – tvrdo drvo, prečnik više od 50 cm",
    description: "Ručno sječenje drveća i šiblja (tvrdo drvo), prečnik stabla više od 50 cm, pripremni radovi.",
    info: "pripremni radovi – sječenje drveća i šiblja",
    norm_type: :worker,
    subtype: :unskilled,  # radnik klase RII
    unit_of_measure: "kom",
    norm_value: 22.5,
    tags: ["pripremni radovi", "sječenje", "drveća", "šiblja", "ručni rad", "tvrdo"],
    info_norm: false
  },
  # =========================
  # ZEMLJANI RADOVI – MAŠINSKI
  # =========================
  {
    name: "Mašinski iskop zemlje II i III kategorije",
    description: "Mašinski iskop zemlje II i III kategorije terena bagerom, standardni uslovi rada.",
    info: "zemljani radovi – mašinski iskop",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0516, # NČ po m3
    tags: ["zemljani radovi", "iskop", "mašinski", "bager", "zemlja", "II kat", "III kat"],
    info_norm: false
  },
  {
    name: "Mašinski utovar zemlje III kategorije",
    description: "Mašinski utovar iskopane zemlje III kategorije na transportno sredstvo.",
    info: "zemljani radovi – mašinski utovar",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0752, # NČ po m3
    tags: ["zemljani radovi", "utovar", "mašinski", "bager", "zemlja", "III kat"],
    info_norm: false
  },
  {
    name: "Mašinski utovar zemlje II kategorije",
    description: "Mašinski utovar iskopane zemlje II kategorije na transportno sredstvo.",
    info: "zemljani radovi – mašinski utovar",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0740, # NČ po m3
    tags: ["zemljani radovi", "utovar", "mašinski", "bager", "zemlja", "II kat"],
    info_norm: false
  },
  {
    name: "Mašinski iskop zemlje III kategorije sa direktnim utovarom",
    description: "Mašinski iskop zemlje III kategorije uz istovremeni direktni utovar na transportno sredstvo.",
    info: "zemljani radovi – mašinski iskop sa direktnim utovarom",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0571, # NČ po m3
    tags: ["zemljani radovi", "iskop", "mašinski", "direktni utovar", "zemlja", "III kat"],
    info_norm: false
  },
  {
    name: "Mašinski iskop zemlje II kategorije sa direktnim utovarom",
    description: "Mašinski iskop zemlje II kategorije uz istovremeni direktni utovar na transportno sredstvo.",
    info: "zemljani radovi – mašinski iskop sa direktnim utovarom",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0500, # NČ po m3
    tags: ["zemljani radovi", "iskop", "mašinski", "direktni utovar", "zemlja", "II kat"],
    info_norm: false
  },
  {
    name: "Mašinski iskop humusa 10–20 cm buldožerom 50 kW",
    description: "Mašinski iskop sloja humusa debljine 10–20 cm buldožerom 50 kW.",
    info: "zemljani radovi – mašinski iskop humusa",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0592, # NČ po m3
    tags: ["zemljani radovi", "iskop", "humus", "buldožer", "mašinski", "50 kW"],
    info_norm: false
  },
  {
    name: "Mašinsko razastiranje zemlje II kategorije",
    description: "Mašinsko razastiranje zemlje II kategorije po nasipu u slojevima.",
    info: "zemljani radovi – mašinsko razastiranje",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0630, # NČ po m3
    tags: ["zemljani radovi", "razastiranje", "mašinski", "zemlja", "II kat"],
    info_norm: false
  },
  {
    name: "Mašinsko razastiranje zemlje III kategorije",
    description: "Mašinsko razastiranje zemlje III kategorije po nasipu u slojevima.",
    info: "zemljani radovi – mašinsko razastiranje",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 0.0630, # NČ po m3
    tags: ["zemljani radovi", "razastiranje", "mašinski", "zemlja", "III kat"],
    info_norm: false
  },

  # =========================
  # ZEMLJANI RADOVI – RUČNI
  # =========================

  {
    name: "Ručno otkopavanje zemlje u širokom otkopu – I kategorija",
    description: "Ručno otkopavanje zemlje u širokom otkopu (površina iskopa > 20 m2), stanje zemljišta I kategorije.",
    info: "zemljani radovi – ručno otkopavanje, široki otkop",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.0,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "široki otkop", "I kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemlje u širokom otkopu – II kategorija",
    description: "Ručno otkopavanje zemlje u širokom otkopu (površina iskopa > 20 m2), stanje zemljišta II kategorije.",
    info: "zemljani radovi – ručno otkopavanje, široki otkop",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.3,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "široki otkop", "II kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemlje u širokom otkopu – III kategorija",
    description: "Ručno otkopavanje zemlje u širokom otkopu (površina iskopa > 20 m2), stanje zemljišta III kategorije.",
    info: "zemljani radovi – ručno otkopavanje, široki otkop",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.6,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "široki otkop", "III kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemlje u širokom otkopu – IV kategorija",
    description: "Ručno otkopavanje zemlje u širokom otkopu (površina iskopa > 20 m2), stanje zemljišta IV kategorije.",
    info: "zemljani radovi – ručno otkopavanje, široki otkop",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.0,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "široki otkop", "IV kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemlje u širokom otkopu – V kategorija",
    description: "Ručno otkopavanje zemlje u širokom otkopu (površina iskopa > 20 m2), stanje zemljišta V kategorije.",
    info: "zemljani radovi – ručno otkopavanje, široki otkop",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.4,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "široki otkop", "V kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemlje u širokom otkopu – VI kategorija",
    description: "Ručno otkopavanje zemlje u širokom otkopu (površina iskopa > 20 m2), stanje zemljišta VI kategorije.",
    info: "zemljani radovi – ručno otkopavanje, široki otkop",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.0,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "široki otkop", "VI kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemljišta za temelje objekta – I kategorija",
    description: "Ručno otkopavanje zemljišta za temelje objekta, stanje zemljišta I kategorije.",
    info: "zemljani radovi – ručno otkopavanje, temelji",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.3,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "temelji", "I kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemljišta za temelje objekta – II kategorija",
    description: "Ručno otkopavanje zemljišta za temelje objekta, stanje zemljišta II kategorije.",
    info: "zemljani radovi – ručno otkopavanje, temelji",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.6,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "temelji", "II kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemljišta za temelje objekta – III kategorija",
    description: "Ručno otkopavanje zemljišta za temelje objekta, stanje zemljišta III kategorije.",
    info: "zemljani radovi – ručno otkopavanje, temelji",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.0,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "temelji", "III kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemljišta za temelje objekta – IV kategorija",
    description: "Ručno otkopavanje zemljišta za temelje objekta, stanje zemljišta IV kategorije.",
    info: "zemljani radovi – ručno otkopavanje, temelji",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.4,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "temelji", "IV kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemljišta za temelje objekta – V kategorija",
    description: "Ručno otkopavanje zemljišta za temelje objekta, stanje zemljišta V kategorije.",
    info: "zemljani radovi – ručno otkopavanje, temelji",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.0,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "temelji", "V kat"],
    info_norm: false
  },
  {
    name: "Ručno otkopavanje zemljišta za temelje objekta – VI kategorija",
    description: "Ručno otkopavanje zemljišta za temelje objekta, stanje zemljišta VI kategorije.",
    info: "zemljani radovi – ručno otkopavanje, temelji",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.6,
    tags: ["zemljani radovi", "ručno", "otkopavanje", "temelji", "VI kat"],
    info_norm: false
  },
  {
    name: "Ručno nasipanje i nabijanje sloja 10 cm sa tegom 20 kg",
    description: "Ručno nasipanje i nabijanje sloja zemlje debljine 10 cm sa ručnim tegom mase 20 kg.",
    info: "zemljani radovi – ručno nasipanje i nabijanje",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.8,
    tags: ["zemljani radovi", "ručno", "nasipanje", "nabijanje", "sloj 10cm"],
    info_norm: false
  },
  {
    name: "Ručno nasipanje (zatrpavanje bez nabijanja)",
    description: "Ručno nasipanje i zatrpavanje iskopa bez nabijanja zemlje.",
    info: "zemljani radovi – ručno nasipanje",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.4,
    tags: ["zemljani radovi", "ručno", "nasipanje", "zatrpavanje"],
    info_norm: false
  },
  {
    name: "Ručno planiranje terena ±3 cm sa odvozom zemlje do 10 m",
    description: "Ručno planiranje terena sa tačnošću ±3 cm i odvoženjem zemlje do 10 m.",
    info: "zemljani radovi – ručno planiranje terena",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.3,
    tags: ["zemljani radovi", "ručno", "planiranje", "teren", "odvoz 10m"],
    info_norm: false
  },
  {
    name: "Ručno planiranje terena ±3 cm sa odvozom zemlje do 20 m",
    description: "Ručno planiranje terena sa tačnošću ±3 cm i odvoženjem zemlje do 20 m.",
    info: "zemljani radovi – ručno planiranje terena",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.35,
    tags: ["zemljani radovi", "ručno", "planiranje", "teren", "odvoz 20m"],
    info_norm: false
  },
  {
    name: "Ručno planiranje terena ±3 cm sa odvozom zemlje do 30 m",
    description: "Ručno planiranje terena sa tačnošću ±3 cm i odvoženjem zemlje do 30 m.",
    info: "zemljani radovi – ručno planiranje terena",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.4,
    tags: ["zemljani radovi", "ručno", "planiranje", "teren", "odvoz 30m"],
    info_norm: false
  },
  {
    name: "Ručno planiranje terena ±3 cm sa odvozom zemlje do 50 m",
    description: "Ručno planiranje terena sa tačnošću ±3 cm i odvoženjem zemlje do 50 m.",
    info: "zemljani radovi – ručno planiranje terena",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.45,
    tags: ["zemljani radovi", "ručno", "planiranje", "teren", "odvoz 50m"],
    info_norm: false
  },
  {
    name: "Ručno planiranje terena ±3 cm sa odvozom zemlje preko 50 m",
    description: "Ručno planiranje terena sa tačnošću ±3 cm i odvoženjem zemlje preko 50 m.",
    info: "zemljani radovi – ručno planiranje terena",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.5,
    tags: ["zemljani radovi", "ručno", "planiranje", "teren", "odvoz >50m"],
    info_norm: false
  },
  {
    name: "Ručno razastiranje materijala u slojevima do 30 cm",
    description: "Ručno razastiranje rastresitog materijala (zemlja, šljunak) u slojevima debljine do 30 cm.",
    info: "zemljani radovi – ručno razastiranje materijala",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.5,
    tags: ["zemljani radovi", "ručno", "razastiranje", "sloj 30cm", "materijal"],
    info_norm: false
  },

  # ============================================
  # DEMONTAŽA I RUŠENJE – MAŠINSKI RADOVI
  # ============================================

  {
    name: "Mašinsko rušenje betonskih podova pikamerom (d ≤ 10 cm)",
    description: "Mašinsko rušenje (pikamer) betonskih podova debljine do 10 cm.",
    info: "demontaža i rušenje – mašinsko rušenje podova",
    norm_type: :machine,
    unit_of_measure: "m2",
    norm_value: 0.34,
    tags: ["demontaža", "rušenje", "mašinski", "pikamer", "betonski pod", "do 10cm"],
    info_norm: false
  },
  {
    name: "Mašinsko rušenje betonskih podova pikamerom (d 10–20 cm)",
    description: "Mašinsko rušenje (pikamer) betonskih podova debljine 10–20 cm.",
    info: "demontaža i rušenje – mašinsko rušenje podova",
    norm_type: :machine,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: ["demontaža", "rušenje", "mašinski", "pikamer", "betonski pod", "10–20cm"],
    info_norm: false
  },
  {
    name: "Mašinsko rušenje asfaltnog sloja pikamerom (d = 8 cm)",
    description: "Mašinsko rušenje (pikamer) asfaltnog sloja debljine oko 8 cm.",
    info: "demontaža i rušenje – mašinsko rušenje asfalta",
    norm_type: :machine,
    unit_of_measure: "m2",
    norm_value: 0.48,
    tags: %w[demontaža rušenje mašinski pikamer asfalt 8cm],
    info_norm: false
  },
  {
    name: "Mašinsko rušenje ivičnjaka pikamerom na betonskoj podlozi",
    description: "Mašinsko rušenje (pikamer) betonskih ivičnjaka na betonskoj podlozi.",
    info: "demontaža i rušenje – mašinsko rušenje ivičnjaka",
    norm_type: :machine,
    unit_of_measure: "m",
    norm_value: 0.8,
    tags: ["demontaža", "rušenje", "mašinski", "pikamer", "ivičnjak", "betonska podloga"],
    info_norm: false
  },
  {
    name: "Mašinsko rušenje zidova i postolja od armiranog betona",
    description: "Mašinsko rušenje zidova i postolja od armiranog betona (stepeništa, rampe, ploče).",
    info: "demontaža i rušenje – mašinsko rušenje armiranog betona",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 18.38,
    tags: ["demontaža", "rušenje", "mašinski", "armirani beton", "zidovi", "postolja"],
    info_norm: false
  },
  {
    name: "Mašinsko rušenje zidova od betona",
    description: "Mašinsko rušenje zidova od običnog betona.",
    info: "demontaža i rušenje – mašinsko rušenje betonskih zidova",
    norm_type: :machine,
    unit_of_measure: "m3",
    norm_value: 9.38,
    tags: %w[demontaža rušenje mašinski beton zidovi],
    info_norm: false
  },

  # ============================================
  # DEMONTAŽA I RUŠENJE – RUČNO RUŠENJE ZIDOVA
  # ============================================

  {
    name: "Rušenje zidova od opeke 25 cm u podužnom malteru",
    description: "Ručno rušenje zidova od opeke debljine 25 cm i više, zidani u podužnom malteru.",
    info: "demontaža i rušenje – ručno rušenje zidanih zidova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 5.613,
    tags: ["demontaža", "rušenje", "ručno", "zid", "opeka", "25cm", "podužni malter"],
    info_norm: false
  },
  {
    name: "Rušenje zidova od opeke 25 cm u cementnom malteru",
    description: "Ručno rušenje zidova od opeke debljine 25 cm i više, zidani u cementnom malteru.",
    info: "demontaža i rušenje – ručno rušenje zidanih zidova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 8.11,
    tags: ["demontaža", "rušenje", "ručno", "zid", "opeka", "25cm", "cementni malter"],
    info_norm: false
  },
  {
    name: "Rušenje zidova od opeke 7 cm (pregradni zidovi)",
    description: "Ručno rušenje zidova od opeke debljine 7 cm, bez obzira na vrstu maltera.",
    info: "demontaža i rušenje – ručno rušenje tankih zidova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.533,
    tags: ["demontaža", "rušenje", "ručno", "zid", "opeka", "7cm", "pregradni zid"],
    info_norm: false
  },
  {
    name: "Rušenje zidova od opeke 12 cm u podužnom malteru",
    description: "Ručno rušenje zidova od opeke debljine 12 cm, zidani u podužnom malteru.",
    info: "demontaža i rušenje – ručno rušenje zidanih zidova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.763,
    tags: ["demontaža", "rušenje", "ručno", "zid", "opeka", "12cm", "podužni malter"],
    info_norm: false
  },
  {
    name: "Rušenje zidova od opeke 12 cm u cementnom malteru",
    description: "Ručno rušenje zidova od opeke debljine 12 cm, zidani u cementnom malteru.",
    info: "demontaža i rušenje – ručno rušenje zidanih zidova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.913,
    tags: ["demontaža", "rušenje", "ručno", "zid", "opeka", "12cm", "cementni malter"],
    info_norm: false
  },
  {
    name: "Rušenje zidova od nabijenog betona",
    description: "Ručno rušenje zidova od nabijenog betona.",
    info: "demontaža i rušenje – ručno rušenje betonskih zidova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 11.113,
    tags: ["demontaža", "rušenje", "ručno", "nabijeni beton", "zid"],
    info_norm: false
  },
  {
    name: "Rušenje zidova i postolja od armiranog betona (ručno)",
    description: "Ručno rušenje zidova i postolja od armiranog betona (stepenice, zidovi i sl.).",
    info: "demontaža i rušenje – ručno rušenje armiranog betona",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 28.813,
    tags: ["demontaža", "rušenje", "ručno", "armirani beton", "zidovi", "postolja"],
    info_norm: false
  },
  {
    name: "Rušenje stubova od armiranog betona",
    description: "Ručno rušenje stubova od armiranog betona.",
    info: "demontaža i rušenje – ručno rušenje armiranih stubova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 35.913,
    tags: ["demontaža", "rušenje", "ručno", "armirani beton", "stubovi"],
    info_norm: false
  },
  {
    name: "Rušenje tavanica od armiranog betona",
    description: "Ručno rušenje tavanica od armiranog betona.",
    info: "demontaža i rušenje – ručno rušenje tavanica",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 3.119,
    tags: ["demontaža", "rušenje", "ručno", "tavanica", "armirani beton"],
    info_norm: false
  },
  {
    name: "Rušenje podova od betona do 10 cm (košuljica)",
    description: "Ručno rušenje betonskih podova (košuljica) debljine do 10 cm.",
    info: "demontaža i rušenje – ručno rušenje podova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.561,
    tags: ["demontaža", "rušenje", "ručno", "betonski pod", "košuljica", "do 10cm"],
    info_norm: false
  },
  {
    name: "Rušenje podova od betona 10–20 cm",
    description: "Ručno rušenje betonskih podova debljine 10–20 cm.",
    info: "demontaža i rušenje – ručno rušenje podova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 1.019,
    tags: ["demontaža", "rušenje", "ručno", "betonski pod", "10–20cm"],
    info_norm: false
  },

  # ============================================
  # DEMONTAŽA – KROVOVI I LIMARIJA (RUČNO)
  # ============================================

  {
    name: "Demontaža oluka",
    description: "Ručno skidanje i demontaža oluka.",
    info: "demontaža i rušenje – demontaža limarije",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m",
    norm_value: 0.54,
    tags: %w[demontaža oluk limarija krov],
    info_norm: false
  },
  {
    name: "Demontaža atike i nadzidaka",
    description: "Ručno demontiranje atike i nadzidaka na krovu.",
    info: "demontaža i rušenje – demontaža atike",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m",
    norm_value: 0.24,
    tags: %w[demontaža atika nadzidak krov],
    info_norm: false
  },
  {
    name: "Demontaža ravnih limenih krovova",
    description: "Ručno skidanje i demontaža ravnih limenih krovnih obloga.",
    info: "demontaža i rušenje – demontaža limenih krovova",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.5,
    tags: ["demontaža", "krov", "limeni krov", "ravni krov"],
    info_norm: false
  },
  {
    name: "Demontaža limene strehe kod krovova pokrivenih crepom",
    description: "Ručno skidanje i demontaža limene strehe na krovu pokrivenom crepom.",
    info: "demontaža i rušenje – demontaža limene strehe",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.24,
    tags: ["demontaža", "limena streha", "krov", "crep"],
    info_norm: false
  },
  {
    name: "Demontaža limene strehe na krovovima sa cementno-azbestnim pločama",
    description: "Ručno skidanje i demontaža limene strehe na krovovima pokrivenim cementno-azbestnim pločama.",
    info: "demontaža i rušenje – demontaža limene strehe",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.84,
    tags: ["demontaža", "limena streha", "krov", "cementno-azbestne ploče"],
    info_norm: false
  },
  {
    name: "Demontaža limene vjetarlajsne",
    description: "Ručno skidanje i demontaža limene vjetarlajsne.",
    info: "demontaža i rušenje – demontaža limarije",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m",
    norm_value: 0.3,
    tags: %w[demontaža vjetarlajsna limarija krov],
    info_norm: false
  },
  {
    name: "Demontaža rešetkaste krovne konstrukcije sa čeonom daskom",
    description: "Ručno demontiranje rešetkaste krovne konstrukcije sa čeonom daskom (podaščavanje).",
    info: "demontaža i rušenje – demontaža krovne konstrukcije",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.58,
    tags: ["demontaža", "krovna konstrukcija", "rešetkasta", "podaščavanje"],
    info_norm: false
  },
  {
    name: "Demontaža letvi",
    description: "Ručno skidanje i demontaža krovnih letvi.",
    info: "demontaža i rušenje – demontaža krovnih elemenata",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.045,
    tags: ["demontaža", "letve", "krov", "drvena konstrukcija"],
    info_norm: false
  },
  {
    name: "Demontaža biber crepa do 3 m visine",
    description: "Ručno skidanje i demontaža biber crepa (prosto pokrivanje) za visinu do 3 m.",
    info: "demontaža i rušenje – demontaža krovnog pokrivača",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.15,
    tags: ["demontaža", "biber crep", "krov", "prosto pokrivanje", "do 3m"],
    info_norm: false
  },
  {
    name: "Demontaža biber crepa preko 3 m visine",
    description: "Ručno skidanje i demontaža biber crepa (prosto pokrivanje) za visinu preko 3 m.",
    info: "demontaža i rušenje – demontaža krovnog pokrivača",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.3,
    tags: ["demontaža", "biber crep", "krov", "prosto pokrivanje", "preko 3m"],
    info_norm: false
  },

  # Zidarski radovi – spravljanje maltera, zidanje, malterisanje

  # -------------------------
  # SPRAVLJANJE MALTERA (mašinski, samo NKV)
  # -------------------------

  {
    name: "Spravljanje produžnog maltera 1:2:6 (mašinski)",
    description: "Spravljanje produžnog maltera mašinskim putem (cement:kreč:pjesak), mješavina 1:2:6. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema produžnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.03,
    tags: ["zidarski", "malter", "spravljanje", "mašinski", "1:2:6", "produžni", "nkv"]
  },
  {
    name: "Spravljanje produžnog maltera 1:3:9 (mašinski)",
    description: "Spravljanje produžnog maltera mašinskim putem (cement:kreč:pjesak), mješavina 1:3:9. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema produžnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.09,
    tags: ["zidarski", "malter", "spravljanje", "mašinski", "1:3:9", "produžni", "nkv"]
  },

  {
    name: "Spravljanje krečnog maltera 1:1 (mašinski)",
    description: "Spravljanje krečnog maltera mašinskim putem (kreč:pijesak), mješavina 1:1. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema krečnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.88,
    tags: ["zidarski", "malter", "krečni", "spravljanje", "mašinski", "1:1", "nkv"]
  },
  {
    name: "Spravljanje krečnog maltera 1:2 (mašinski)",
    description: "Spravljanje krečnog maltera mašinskim putem (kreč:pijesak), mješavina 1:2. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema krečnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.64,
    tags: ["zidarski", "malter", "krečni", "spravljanje", "mašinski", "1:2", "nkv"]
  },
  {
    name: "Spravljanje krečnog maltera 1:3 (mašinski)",
    description: "Spravljanje krečnog maltera mašinskim putem (kreč:pijesak), mješavina 1:3. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema krečnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.64,
    tags: ["zidarski", "malter", "krečni", "spravljanje", "mašinski", "1:3", "nkv"]
  },
  {
    name: "Spravljanje krečnog maltera 1:4 (mašinski)",
    description: "Spravljanje krečnog maltera mašinskim putem (kreč:pijesak), mješavina 1:4. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema krečnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.64,
    tags: ["zidarski", "malter", "krečni", "spravljanje", "mašinski", "1:4", "nkv"]
  },

  {
    name: "Spravljanje cementnog maltera 1:1 (mašinski)",
    description: "Spravljanje cementnog maltera mašinskim putem (cement:pijesak), mješavina 1:1. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema cementnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.09,
    tags: ["zidarski", "malter", "cementni", "spravljanje", "mašinski", "1:1", "nkv"]
  },
  {
    name: "Spravljanje cementnog maltera 1:2 (mašinski)",
    description: "Spravljanje cementnog maltera mašinskim putem (cement:pijesak), mješavina 1:2. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema cementnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.77,
    tags: ["zidarski", "malter", "cementni", "spravljanje", "mašinski", "1:2", "nkv"]
  },
  {
    name: "Spravljanje cementnog maltera 1:3 (mašinski)",
    description: "Spravljanje cementnog maltera mašinskim putem (cement:pijesak), mješavina 1:3. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema cementnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.6,
    tags: ["zidarski", "malter", "cementni", "spravljanje", "mašinski", "1:3", "nkv"]
  },
  {
    name: "Spravljanje cementnog maltera 1:4 (mašinski)",
    description: "Spravljanje cementnog maltera mašinskim putem (cement:pijesak), mješavina 1:4. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema cementnog maltera",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.5,
    tags: ["zidarski", "malter", "cementni", "spravljanje", "mašinski", "1:4", "nkv"]
  },

  {
    name: "Spravljanje cementnog maltera za košuljicu 1:3 (mašinski)",
    description: "Spravljanje cementnog maltera za košuljicu mašinskim putem, mješavina 1:3. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema maltera za košuljice",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.6,
    tags: ["zidarski", "malter", "košuljica", "spravljanje", "mašinski", "1:3", "nkv"]
  },
  {
    name: "Spravljanje cementnog maltera za košuljicu 1:3 (TURBO CN85)",
    description: "Spravljanje cementnog maltera za košuljicu mašinskim putem sa TURBO CN85, mješavina 1:3. Ruke za nanošenje maltera nisu uračunate.",
    info: "Zidarski radovi – priprema maltera za košuljice (TURBO CN85)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.6,
    tags: ["zidarski", "malter", "košuljica", "turbo cn85", "spravljanje", "mašinski", "1:3", "nkv"]
  },

  # -------------------------
  # ZIDANJE PUNOM OPEKOM
  # -------------------------

  {
    name: "Zidanje osamljenih temelja opekom",
    description: "Zidanje osamljenih temelja punom opekom, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – temelji (GN 301-201)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 3.7,
    tags: ["zidarski", "zidanje", "temelji", "osamljeni", "opeka", "1:2:6", "kv"]
  },
  {
    name: "Zidanje osamljenih temelja opekom",
    description: "Zidanje osamljenih temelja punom opekom, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – temelji (GN 301-201)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 5.26,
    tags: ["zidarski", "zidanje", "temelji", "osamljeni", "opeka", "1:2:6", "nkv"]
  },

  {
    name: "Zidanje stope temelja i temeljnih zidova opekom",
    description: "Zidanje stope temelja, temeljnih zidova i spoljnih podrumskih zidova opekom, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – temelji i podrumi (GN 301-202)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 2.7,
    tags: ["zidarski", "zidanje", "temelji", "podrum", "opeka", "1:2:6", "kv"]
  },
  {
    name: "Zidanje stope temelja i temeljnih zidova opekom",
    description: "Zidanje stope temelja, temeljnih zidova i spoljnih podrumskih zidova opekom, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – temelji i podrumi (GN 301-202)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 5.01,
    tags: ["zidarski", "zidanje", "temelji", "podrum", "opeka", "1:2:6", "nkv"]
  },

  {
    name: "Zidanje zidova prizemlja i spratova opekom d=25cm",
    description: "Zidanje nosećih zidova prizemlja i spratova punom opekom debljine 25cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – zidovi prizemlja i spratova (GN 301-203)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 3.96,
    tags: %w[zidarski zidanje zidovi prizemlje sprat opeka 25cm kv]
  },
  {
    name: "Zidanje zidova prizemlja i spratova opekom d=25cm",
    description: "Zidanje nosećih zidova prizemlja i spratova punom opekom debljine 25cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – zidovi prizemlja i spratova (GN 301-203)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.05,
    tags: %w[zidarski zidanje zidovi prizemlje sprat opeka 25cm nkv]
  },

  {
    name: "Zidanje pregradnih zidova od 1/2 opeke d=12cm",
    description: "Zidanje unutrašnjih pregradnih zidova od 1/2 opeke debljine 12cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – pregradni zidovi (GN 301-214)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.9,
    tags: ["zidarski", "zidanje", "pregradni zid", "opeka", "12cm", "kv"]
  },
  {
    name: "Zidanje pregradnih zidova od 1/2 opeke d=12cm",
    description: "Zidanje unutrašnjih pregradnih zidova od 1/2 opeke debljine 12cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – pregradni zidovi (GN 301-214)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.65,
    tags: ["zidarski", "zidanje", "pregradni zid", "opeka", "12cm", "nkv"]
  },

  {
    name: "Zidanje pregradnih zidova nasatično opekom d=7cm",
    description: "Zidanje laganih pregradnih zidova nasatično od opeke debljine 7cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – lagani pregradni zidovi (GN 301-216)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.98,
    tags: ["zidarski", "zidanje", "pregradni zid", "nasatično", "opeka", "7cm", "kv"]
  },
  {
    name: "Zidanje pregradnih zidova nasatično opekom d=7cm",
    description: "Zidanje laganih pregradnih zidova nasatično od opeke debljine 7cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – lagani pregradni zidovi (GN 301-216)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.54,
    tags: ["zidarski", "zidanje", "pregradni zid", "nasatično", "opeka", "7cm", "nkv"]
  },

  {
    name: "Zidanje fasadnih zidova fasadnom opekom d=12cm",
    description: "Zidanje fasadnih zidova fasadnom opekom debljine 12cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – fasadni zidovi (GN 301-214a)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 2.48,
    tags: ["zidarski", "zidanje", "fasadni zid", "fasadna opeka", "12cm", "kv"]
  },
  {
    name: "Zidanje fasadnih zidova fasadnom opekom d=12cm",
    description: "Zidanje fasadnih zidova fasadnom opekom debljine 12cm, malter 1:2:6, prenos maltera skipom.",
    info: "Zidarski radovi – fasadni zidovi (GN 301-214a)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 1.35,
    tags: ["zidarski", "zidanje", "fasadni zid", "fasadna opeka", "12cm", "nkv"]
  },

  {
    name: "Zidanje zidova Giter blokovima d=20cm",
    description: "Zidanje unutrašnjih ili fasadnih zidova Giter blokovima 25×19×19cm, debljine 20cm, malter 1:2:6.",
    info: "Zidarski radovi – Giter blok (GN 301-161 stare norme)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 3.2,
    tags: ["zidarski", "zidanje", "giter blok", "20cm", "kv"]
  },
  {
    name: "Zidanje zidova Giter blokovima d=20cm",
    description: "Zidanje unutrašnjih ili fasadnih zidova Giter blokovima 25×19×19cm, debljine 20cm, malter 1:2:6.",
    info: "Zidarski radovi – Giter blok (GN 301-161 stare norme)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.01,
    tags: ["zidarski", "zidanje", "giter blok", "20cm", "nkv"]
  },

  # -------------------------
  # BETONSKI BLOKOVI BN 20 / BN 25
  # -------------------------

  {
    name: "Zidanje zidova betonskim blokovima BN20 d=20cm",
    description: "Zidanje zidova betonskim blokovima BN20 debljine 20cm, malter 1:2:6.",
    info: "Zidarski radovi – betonski blok BN20",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 3.8,
    tags: ["zidarski", "zidanje", "betonski blok", "BN20", "20cm", "kv"]
  },
  {
    name: "Zidanje zidova betonskim blokovima BN20 d=20cm",
    description: "Zidanje zidova betonskim blokovima BN20 debljine 20cm, malter 1:2:6.",
    info: "Zidarski radovi – betonski blok BN20",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.67,
    tags: ["zidarski", "zidanje", "betonski blok", "BN20", "20cm", "nkv"]
  },

  {
    name: "Zidanje zidova betonskim blokovima BN25 d=25cm",
    description: "Zidanje zidova betonskim blokovima BN25 debljine 25cm, malter 1:2:6.",
    info: "Zidarski radovi – betonski blok BN25",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 3.7,
    tags: ["zidarski", "zidanje", "betonski blok", "BN25", "25cm", "kv"]
  },
  {
    name: "Zidanje zidova betonskim blokovima BN25 d=25cm",
    description: "Zidanje zidova betonskim blokovima BN25 debljine 25cm, malter 1:2:6.",
    info: "Zidarski radovi – betonski blok BN25",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.69,
    tags: ["zidarski", "zidanje", "betonski blok", "BN25", "25cm", "nkv"]
  },

  # -------------------------
  # YTONG BLOKOVI
  # -------------------------

  {
    name: "Zidanje nosećih zidova Ytong blokom d=25cm",
    description: "Zidanje nosećih zidova prizemlja i spratova Ytong blokom debljine 25cm.",
    info: "Zidarski radovi – Ytong blok 25cm",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 1.73,
    tags: %w[zidarski zidanje ytong 25cm kv]
  },
  {
    name: "Zidanje nosećih zidova Ytong blokom d=25cm",
    description: "Zidanje nosećih zidova prizemlja i spratova Ytong blokom debljine 25cm.",
    info: "Zidarski radovi – Ytong blok 25cm",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.58,
    tags: %w[zidarski zidanje ytong 25cm nkv]
  },

  {
    name: "Zidanje nosećih zidova Ytong blokom d=30cm",
    description: "Zidanje nosećih zidova prizemlja i spratova Ytong blokom debljine 30cm.",
    info: "Zidarski radovi – Ytong blok 30cm",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 1.51,
    tags: %w[zidarski zidanje ytong 30cm kv]
  },
  {
    name: "Zidanje nosećih zidova Ytong blokom d=30cm",
    description: "Zidanje nosećih zidova prizemlja i spratova Ytong blokom debljine 30cm.",
    info: "Zidarski radovi – Ytong blok 30cm",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.38,
    tags: %w[zidarski zidanje ytong 30cm nkv]
  },

  {
    name: "Zidanje nosećih zidova Ytong blokom d=20cm",
    description: "Zidanje nosećih zidova prizemlja i spratova Ytong blokom debljine 20cm.",
    info: "Zidarski radovi – Ytong blok 20cm",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 1.82,
    tags: %w[zidarski zidanje ytong 20cm kv]
  },
  {
    name: "Zidanje nosećih zidova Ytong blokom d=20cm",
    description: "Zidanje nosećih zidova prizemlja i spratova Ytong blokom debljine 20cm.",
    info: "Zidarski radovi – Ytong blok 20cm",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.61,
    tags: %w[zidarski zidanje ytong 20cm nkv]
  },

  # -------------------------
  # KLIMA I TERMO BLOKOVI – GAT (informativno)
  # -------------------------

  {
    name: "Zidanje klima blokom d=25cm (GAT norma)",
    description: "Zidanje klima blokom debljine 25cm. U tabeli je data samo zbirna GAT norma (6) bez razdvajanja KV/NKV.",
    info: "Zidarski radovi – klima blok 25cm (informativno)",
    norm_type: :worker,
    unit_of_measure: "m3",
    norm_value: 6.0,
    tags: ["zidarski", "zidanje", "klima blok", "25cm", "gat", "informativno"],
    info_norm: true
  },
  {
    name: "Zidanje klima blokom d=30cm (GAT norma)",
    description: "Zidanje klima blokom debljine 30cm. U tabeli je data samo zbirna GAT norma (6) bez razdvajanja KV/NKV.",
    info: "Zidarski radovi – klima blok 30cm (informativno)",
    norm_type: :worker,
    unit_of_measure: "m3",
    norm_value: 6.0,
    tags: ["zidarski", "zidanje", "klima blok", "30cm", "gat", "informativno"],
    info_norm: true
  },

  {
    name: "Zidanje termo blokom d=20cm (GAT norma)",
    description: "Zidanje termo blokom debljine 20cm. U tabeli je data samo zbirna GAT norma (6) bez razdvajanja KV/NKV.",
    info: "Zidarski radovi – termo blok 20cm (informativno)",
    norm_type: :worker,
    unit_of_measure: "m3",
    norm_value: 6.0,
    tags: ["zidarski", "zidanje", "termo blok", "20cm", "gat", "informativno"],
    info_norm: true
  },
  {
    name: "Zidanje termo blokom d=25cm (GAT norma)",
    description: "Zidanje termo blokom debljine 25cm. U tabeli je data samo zbirna GAT norma (6) bez razdvajanja KV/NKV.",
    info: "Zidarski radovi – termo blok 25cm (informativno)",
    norm_type: :worker,
    unit_of_measure: "m3",
    norm_value: 6.0,
    tags: ["zidarski", "zidanje", "termo blok", "25cm", "gat", "informativno"],
    info_norm: true
  },
  {
    name: "Zidanje termo blokom d=30cm (GAT norma)",
    description: "Zidanje termo blokom debljine 30cm. U tabeli je data samo zbirna GAT norma (6) bez razdvajanja KV/NKV.",
    info: "Zidarski radovi – termo blok 30cm (informativno)",
    norm_type: :worker,
    unit_of_measure: "m3",
    norm_value: 6.0,
    tags: ["zidarski", "zidanje", "termo blok", "30cm", "gat", "informativno"],
    info_norm: true
  },

  # -------------------------
  # ZIDANJE ŠAHTOVA PUNOM OPEKOM
  # -------------------------

  {
    name: "Zidanje šahtova punom opekom – zid 12cm",
    description: "Zidanje šahtova punom opekom, zid debljine 12cm. Obračun po m2 za zid od 12cm.",
    info: "Zidarski radovi – šahtovi (GN 301-225)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.14,
    tags: %w[zidarski zidanje šaht opeka 12cm kv]
  },
  {
    name: "Zidanje šahtova punom opekom – zid 12cm",
    description: "Zidanje šahtova punom opekom, zid debljine 12cm. Obračun po m2 za zid od 12cm.",
    info: "Zidarski radovi – šahtovi (GN 301-225)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.78,
    tags: %w[zidarski zidanje šaht opeka 12cm nkv]
  },

  {
    name: "Zidanje šahtova punom opekom – zid 25cm",
    description: "Zidanje šahtova punom opekom, zid debljine 25cm. Obračun po m3 za zid od 25cm.",
    info: "Zidarski radovi – šahtovi (GN 301-225)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 5.7,
    tags: %w[zidarski zidanje šaht opeka 25cm kv]
  },
  {
    name: "Zidanje šahtova punom opekom – zid 25cm",
    description: "Zidanje šahtova punom opekom, zid debljine 25cm. Obračun po m3 za zid od 25cm.",
    info: "Zidarski radovi – šahtovi (GN 301-225)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.48,
    tags: %w[zidarski zidanje šaht opeka 25cm nkv]
  },

  # -------------------------
  # MALTERISANJE (ŽBUKANJE)
  # -------------------------

  {
    name: "Malterisanje plafona preko ravne betonske ploče",
    description: "Malterisanje plafona preko ravne betonske ploče u dva sloja, sa prethodnim prskanjem rijetkim cementnim malterom, prenos maltera skipom.",
    info: "Zidarski radovi – malterisanje plafona (GN 301-401)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.68,
    tags: ["zidarski", "malterisanje", "plafon", "betonska ploča", "kv"]
  },
  {
    name: "Malterisanje plafona preko ravne betonske ploče",
    description: "Malterisanje plafona preko ravne betonske ploče u dva sloja, sa prethodnim prskanjem rijetkim cementnim malterom, prenos maltera skipom.",
    info: "Zidarski radovi – malterisanje plafona (GN 301-401)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.3,
    tags: ["zidarski", "malterisanje", "plafon", "betonska ploča", "nkv"]
  },

  {
    name: "Malterisanje zidova od opeke",
    description: "Malterisanje zidova od opeke u dva sloja sa prethodnim prskanjem rijetkim cementnim malterom, uobičajeni krečni malter 1:3.",
    info: "Zidarski radovi – malterisanje zidova od opeke (GN 301-405)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.6,
    tags: ["zidarski", "malterisanje", "zidovi", "opeka", "krečni 1:3", "kv"]
  },
  {
    name: "Malterisanje zidova od opeke",
    description: "Malterisanje zidova od opeke u dva sloja sa prethodnim prskanjem rijetkim cementnim malterom, uobičajeni krečni malter 1:3.",
    info: "Zidarski radovi – malterisanje zidova od opeke (GN 301-405)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.291,
    tags: ["zidarski", "malterisanje", "zidovi", "opeka", "krečni 1:3", "nkv"]
  },

  {
    name: "Malterisanje zidova od betona i šljakobetonskih blokova",
    description: "Malterisanje zidova od betona i šljakobetonskih blokova u dva sloja sa prethodnim prskanjem rijetkim cementnim malterom.",
    info: "Zidarski radovi – malterisanje betonskih zidova (GN 301-405)",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[zidarski malterisanje zidovi beton šljakobeton kv]
  },
  {
    name: "Malterisanje zidova od betona i šljakobetonskih blokova",
    description: "Malterisanje zidova od betona i šljakobetonskih blokova u dva sloja sa prethodnim prskanjem rijetkim cementnim malterom.",
    info: "Zidarski radovi – malterisanje betonskih zidova (GN 301-405)",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.22,
    tags: %w[zidarski malterisanje zidovi beton šljakobeton nkv]
  },

  # ARMIRAČKI RADOVI – okrugli čelik + mrežasta armatura
  # Jedinica mjere svuda je "kg" (kg armature / mreže)

  # ----------------------------------------------------
  # OKRUGLI ČELIK – JEDNOSTAVNA I SREDNJE SLOŽENA ARMATURA
  # GN 400-102
  # ----------------------------------------------------

  # 1) Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje, prenos – fi 12–14
  {
    name: "Obrada i ugradnja armature Ø12–14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature od okruglog čelika Ø12–14 mm. Jednostavna i srednje složena armatura, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, jednostavna i srednje složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-102).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.044,
    tags: ["armatura", "okrugli čelik", "rezanje", "savijanje", "ugradnja", "fi 12-14", "kran", "kv"]
  },
  {
    name: "Obrada i ugradnja armature Ø12–14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature od okruglog čelika Ø12–14 mm. Jednostavna i srednje složena armatura, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, jednostavna i srednje složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-102).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0441,
    tags: ["armatura", "okrugli čelik", "rezanje", "savijanje", "ugradnja", "fi 12-14", "kran", "nkv"]
  },

  # 1b) Isto – fi ≥14
  {
    name: "Obrada i ugradnja armature Ø≥14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature od okruglog čelika Ø14 mm i više. Jednostavna i srednje složena armatura, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, jednostavna i srednje složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-102).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.0228,
    tags: ["armatura", "okrugli čelik", "rezanje", "savijanje", "ugradnja", "fi 14+", "kran", "kv"]
  },
  {
    name: "Obrada i ugradnja armature Ø≥14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature od okruglog čelika Ø14 mm i više. Jednostavna i srednje složena armatura, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, jednostavna i srednje složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-102).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0229,
    tags: ["armatura", "okrugli čelik", "rezanje", "savijanje", "ugradnja", "fi 14+", "kran", "nkv"]
  },

  # 2) Ručno sječenje, ispravljanje i savijanje – fi 12–14
  {
    name: "Obrada armature – rezanje i savijanje Ø12–14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje i savijanje armature od okruglog čelika Ø12–14 mm (bez ugradnje i prenosa). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – obrada okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.027,
    tags: ["armatura", "rezanje", "savijanje", "obrada", "fi 12-14", "kv"]
  },
  {
    name: "Obrada armature – rezanje i savijanje Ø12–14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje i savijanje armature od okruglog čelika Ø12–14 mm (bez ugradnje i prenosa). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – obrada okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.027,
    tags: ["armatura", "rezanje", "savijanje", "obrada", "fi 12-14", "nkv"]
  },

  # 2b) Ručno sječenje, ispravljanje i savijanje – fi ≥14
  {
    name: "Obrada armature – rezanje i savijanje Ø≥14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje i savijanje armature od okruglog čelika Ø14 mm i više (bez ugradnje i prenosa). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – obrada okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.0118,
    tags: ["armatura", "rezanje", "savijanje", "obrada", "fi 14+", "kv"]
  },
  {
    name: "Obrada armature – rezanje i savijanje Ø≥14 (jednostavna/srednja)",
    description: "Ručno sječenje, ispravljanje i savijanje armature od okruglog čelika Ø14 mm i više (bez ugradnje i prenosa). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – obrada okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0118,
    tags: ["armatura", "rezanje", "savijanje", "obrada", "fi 14+", "nkv"]
  },

  # 3) Ugrađivanje armature – fi 12–14
  {
    name: "Ugradnja armature Ø12–14 (jednostavna/srednja)",
    description: "Ručno postavljanje, vezivanje i prenos armature od okruglog čelika Ø12–14 mm (ugrađivanje u element). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – ugradnja okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.017,
    tags: ["armatura", "ugradnja", "vezivanje", "postavljanje", "fi 12-14", "kv"]
  },
  {
    name: "Ugradnja armature Ø12–14 (jednostavna/srednja)",
    description: "Ručno postavljanje, vezivanje i prenos armature od okruglog čelika Ø12–14 mm (ugrađivanje u element). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – ugradnja okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0171,
    tags: ["armatura", "ugradnja", "vezivanje", "postavljanje", "fi 12-14", "nkv"]
  },

  # 3b) Ugrađivanje armature – fi ≥14
  {
    name: "Ugradnja armature Ø≥14 (jednostavna/srednja)",
    description: "Ručno postavljanje, vezivanje i prenos armature od okruglog čelika Ø14 mm i više (ugrađivanje u element). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – ugradnja okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.011,
    tags: ["armatura", "ugradnja", "vezivanje", "postavljanje", "fi 14+", "kv"]
  },
  {
    name: "Ugradnja armature Ø≥14 (jednostavna/srednja)",
    description: "Ručno postavljanje, vezivanje i prenos armature od okruglog čelika Ø14 mm i više (ugrađivanje u element). Jednostavna i srednje složena armatura.",
    info: "Armirački radovi – ugradnja okrugle armature, jednostavna/srednje složena (GN 400-102).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0111,
    tags: ["armatura", "ugradnja", "vezivanje", "postavljanje", "fi 14+", "nkv"]
  },

  # ----------------------------------------------------
  # OKRUGLI ČELIK – SLOŽENA ARMATURA
  # GN 400-104
  # ----------------------------------------------------

  # 4) Obrada i ugradnja – fi 12–14
  {
    name: "Obrada i ugradnja armature Ø12–14 (složena)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature Ø12–14 mm za složene armature, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-104).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.05,
    tags: ["armatura", "složena", "rezanje", "savijanje", "ugradnja", "fi 12-14", "kv"]
  },
  {
    name: "Obrada i ugradnja armature Ø12–14 (složena)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature Ø12–14 mm za složene armature, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-104).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0501,
    tags: ["armatura", "složena", "rezanje", "savijanje", "ugradnja", "fi 12-14", "nkv"]
  },

  # 4b) Obrada i ugradnja – fi ≥14
  {
    name: "Obrada i ugradnja armature Ø≥14 (složena)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature Ø14 mm i više za složene armature, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-104).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.025,
    tags: ["armatura", "složena", "rezanje", "savijanje", "ugradnja", "fi 14+", "kv"]
  },
  {
    name: "Obrada i ugradnja armature Ø≥14 (složena)",
    description: "Ručno sječenje, ispravljanje, savijanje, postavljanje, vezivanje i prenos armature Ø14 mm i više za složene armature, vertikalni prenos kranom.",
    info: "Armirački radovi – okrugli čelik, složena armatura. Vertikalni prenos KRAN dizalicom (GN 400-104).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0251,
    tags: ["armatura", "složena", "rezanje", "savijanje", "ugradnja", "fi 14+", "nkv"]
  },

  # 5) Obrada – rezanje i savijanje – fi 12–14
  {
    name: "Obrada armature – rezanje i savijanje Ø12–14 (složena)",
    description: "Ručno sječenje, ispravljanje i savijanje armature Ø12–14 mm za složene armature (bez ugradnje).",
    info: "Armirački radovi – obrada okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.03,
    tags: ["armatura", "složena", "rezanje", "savijanje", "fi 12-14", "kv"]
  },
  {
    name: "Obrada armature – rezanje i savijanje Ø12–14 (složena)",
    description: "Ručno sječenje, ispravljanje i savijanje armature Ø12–14 mm za složene armature (bez ugradnje).",
    info: "Armirački radovi – obrada okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.03,
    tags: ["armatura", "složena", "rezanje", "savijanje", "fi 12-14", "nkv"]
  },

  # 5b) Obrada – rezanje i savijanje – fi ≥14
  {
    name: "Obrada armature – rezanje i savijanje Ø≥14 (složena)",
    description: "Ručno sječenje, ispravljanje i savijanje armature Ø14 mm i više za složene armature (bez ugradnje).",
    info: "Armirački radovi – obrada okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.013,
    tags: ["armatura", "složena", "rezanje", "savijanje", "fi 14+", "kv"]
  },
  {
    name: "Obrada armature – rezanje i savijanje Ø≥14 (složena)",
    description: "Ručno sječenje, ispravljanje i savijanje armature Ø14 mm i više za složene armature (bez ugradnje).",
    info: "Armirački radovi – obrada okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.013,
    tags: ["armatura", "složena", "rezanje", "savijanje", "fi 14+", "nkv"]
  },

  # 6) Ugradnja – fi 12–14
  {
    name: "Ugradnja armature Ø12–14 (složena)",
    description: "Ručno postavljanje, vezivanje i prenos armature Ø12–14 mm za složene armature.",
    info: "Armirački radovi – ugradnja okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.02,
    tags: ["armatura", "složena", "ugradnja", "vezivanje", "postavljanje", "fi 12-14", "kv"]
  },
  {
    name: "Ugradnja armature Ø12–14 (složena)",
    description: "Ručno postavljanje, vezivanje i prenos armature Ø12–14 mm za složene armature.",
    info: "Armirački radovi – ugradnja okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0201,
    tags: ["armatura", "složena", "ugradnja", "vezivanje", "postavljanje", "fi 12-14", "nkv"]
  },

  # 6b) Ugradnja – fi ≥14
  {
    name: "Ugradnja armature Ø≥14 (složena)",
    description: "Ručno postavljanje, vezivanje i prenos armature Ø14 mm i više za složene armature.",
    info: "Armirački radovi – ugradnja okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.012,
    tags: ["armatura", "složena", "ugradnja", "vezivanje", "postavljanje", "fi 14+", "kv"]
  },
  {
    name: "Ugradnja armature Ø≥14 (složena)",
    description: "Ručno postavljanje, vezivanje i prenos armature Ø14 mm i više za složene armature.",
    info: "Armirački radovi – ugradnja okrugle armature, složena (GN 400-104).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0121,
    tags: ["armatura", "složena", "ugradnja", "vezivanje", "postavljanje", "fi 14+", "nkv"]
  },

  # ----------------------------------------------------
  # MREŽASTA ARMATURA – ZIDOVI I PLOČE
  # GN 400-110, 111
  # ----------------------------------------------------

  # Zidovi – mreža 4–6
  {
    name: "Mrežasta armatura – zidovi, mreža 4–6 mm",
    description: "Ugradnja mrežaste armature u zidove, promjer žica 4–6 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za zidove (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.022,
    tags: ["armatura", "mreža", "zidovi", "4-6 mm", "ugradnja", "kv"]
  },
  {
    name: "Mrežasta armatura – zidovi, mreža 4–6 mm",
    description: "Ugradnja mrežaste armature u zidove, promjer žica 4–6 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za zidove (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0221,
    tags: ["armatura", "mreža", "zidovi", "4-6 mm", "ugradnja", "nkv"]
  },

  # Zidovi – mreža 4,5–9
  {
    name: "Mrežasta armatura – zidovi, mreža 4,5–9 mm",
    description: "Ugradnja mrežaste armature u zidove, promjer žica 4,5–9 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za zidove (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.02,
    tags: ["armatura", "mreža", "zidovi", "4.5-9 mm", "ugradnja", "kv"]
  },
  {
    name: "Mrežasta armatura – zidovi, mreža 4,5–9 mm",
    description: "Ugradnja mrežaste armature u zidove, promjer žica 4,5–9 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za zidove (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0201,
    tags: ["armatura", "mreža", "zidovi", "4.5-9 mm", "ugradnja", "nkv"]
  },

  # Zidovi – mreža 9,5–12
  {
    name: "Mrežasta armatura – zidovi, mreža 9,5–12 mm",
    description: "Ugradnja mrežaste armature u zidove, promjer žica 9,5–12 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za zidove (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.015,
    tags: ["armatura", "mreža", "zidovi", "9.5-12 mm", "ugradnja", "kv"]
  },
  {
    name: "Mrežasta armatura – zidovi, mreža 9,5–12 mm",
    description: "Ugradnja mrežaste armature u zidove, promjer žica 9,5–12 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za zidove (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0151,
    tags: ["armatura", "mreža", "zidovi", "9.5-12 mm", "ugradnja", "nkv"]
  },

  # Ploče – mreža 4–6
  {
    name: "Mrežasta armatura – ploče, mreža 4–6 mm",
    description: "Ugradnja mrežaste armature u ploče, promjer žica 4–6 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za ploče (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.022,
    tags: ["armatura", "mreža", "ploče", "4-6 mm", "ugradnja", "kv"]
  },
  {
    name: "Mrežasta armatura – ploče, mreža 4–6 mm",
    description: "Ugradnja mrežaste armature u ploče, promjer žica 4–6 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za ploče (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0221,
    tags: ["armatura", "mreža", "ploče", "4-6 mm", "ugradnja", "nkv"]
  },

  # Ploče – mreža 4,5–9
  {
    name: "Mrežasta armatura – ploče, mreža 4,5–9 mm",
    description: "Ugradnja mrežaste armature u ploče, promjer žica 4,5–9 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za ploče (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.018,
    tags: ["armatura", "mreža", "ploče", "4.5-9 mm", "ugradnja", "kv"]
  },
  {
    name: "Mrežasta armatura – ploče, mreža 4,5–9 mm",
    description: "Ugradnja mrežaste armature u ploče, promjer žica 4,5–9 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za ploče (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0181,
    tags: ["armatura", "mreža", "ploče", "4.5-9 mm", "ugradnja", "nkv"]
  },

  # Ploče – mreža 9,5–12
  {
    name: "Mrežasta armatura – ploče, mreža 9,5–12 mm",
    description: "Ugradnja mrežaste armature u ploče, promjer žica 9,5–12 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za ploče (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "kg",
    norm_value: 0.014,
    tags: ["armatura", "mreža", "ploče", "9.5-12 mm", "ugradnja", "kv"]
  },
  {
    name: "Mrežasta armatura – ploče, mreža 9,5–12 mm",
    description: "Ugradnja mrežaste armature u ploče, promjer žica 9,5–12 mm. Vertikalni prenos kranom.",
    info: "Armirački radovi – mrežasta armatura za ploče (GN 400-110, 111).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "kg",
    norm_value: 0.0141,
    tags: ["armatura", "mreža", "ploče", "9.5-12 mm", "ugradnja", "nkv"]
  },

  # ------------------------------------
  # SPRAVLJANJE BETONA – RUČNO I MJEŠALICOM
  # ------------------------------------
  {
    name: "Ručno spravljanje betona – prirodna mješavina (MB10–MB20)",
    description: "Ručno spravljanje betona sa prirodnom mješavinom agregata za klase MB10–MB20; ručno doziranje, miješanje i manipulacija betona.",
    info: "Betonski radovi – ručno spravljanje betona, prirodna mješavina.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.62,
    tags: %w[beton spravljanje ručno prirodna mjesavina MB10 MB20 betonski]
  },
  {
    name: "Ručno spravljanje betona – vještačka mješavina (MB15–MB40)",
    description: "Ručno spravljanje betona sa vještačkom mješavinom agregata za klase MB15–MB40; ručno doziranje, miješanje i manipulacija betona.",
    info: "Betonski radovi – ručno spravljanje betona, vještačka mješavina.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.38,
    tags: %w[beton spravljanje ručno vjestacka mjesavina MB15 MB20 MB30 MB40 betonski]
  },
  {
    name: "Spravljanje betona mješalicom 50l – prirodna mješavina",
    description: "Spravljanje betona u maloj bubanj mješalici zapremine 50 litara sa prirodnim agregatom (MB10–MB20); uključuje doziranje i miješanje.",
    info: "Betonski radovi – spravljanje betona mješalicom, prirodna mješavina.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.24,
    tags: %w[beton spravljanje mjesalica bubanj prirodna mjesavina MB10 MB20 betonski]
  },
  {
    name: "Spravljanje betona mješalicom 50l – vještačka mješavina",
    description: "Spravljanje betona u bubanj mješalici 50 litara sa vještačkom mješavinom agregata (MB15–MB40); uključuje doziranje i miješanje.",
    info: "Betonski radovi – spravljanje betona mješalicom, vještačka mješavina.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 2.24,
    tags: %w[beton spravljanje mjesalica bubanj vjestacka mjesavina MB15 MB20 MB30 MB40 betonski]
  },

  # ------------------------------------
  # RUČNO UGRAĐIVANJE BETONA – MALI PRESJECI DO 0,12 m3
  # (gotov beton spravljen mješalicom ili iz miksera)
  # ------------------------------------
  {
    name: "Ručno ugrađivanje betona – mali presjeci do 0,12m3 (informativno)",
    description: "Opšti opis: ručno ugrađivanje gotovog betona u male presjeke do 0,12m3 na m1 ili m2 konstrukcije, za betone spravljene mješalicom ili isporučene iz miksera, važi za kote +0.00m naniže.",
    info: "Informativna napomena – mali presjeci, gotov beton, radovi naniže.",
    tags: %w[beton ugradnja mali presjeci gotov naniže informacija],
    info_norm: true
  },
  {
    name: "Ručno ugrađivanje betona – mali presjeci do 0,12m3, nearmirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u nearmirane konstrukcije malog presjeka (do 0,12m3) na m1 ili m2, beton spravljen mješalicom ili iz miksera; radovi naniže.",
    info: "Gotov beton – mali presjeci, nearmirane konstrukcije.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 2.25,
    tags: %w[beton ugradnja mali presjek nearmirana gotov mjesalica mikser betonski]
  },
  {
    name: "Ručno ugrađivanje betona – mali presjeci do 0,12m3, nearmirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u nearmirane konstrukcije malog presjeka (do 0,12m3) na m1 ili m2, beton spravljen mješalicom ili iz miksera; radovi naniže.",
    info: "Gotov beton – mali presjeci, nearmirane konstrukcije.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.6,
    tags: %w[beton ugradnja mali presjek nearmirana gotov mjesalica mikser betonski]
  },
  {
    name: "Ručno ugrađivanje betona – mali presjeci do 0,12m3, armirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u armirane konstrukcije malog presjeka (do 0,12m3) na m1 ili m2, beton spravljen mješalicom ili iz miksera; radovi naniže.",
    info: "Gotov beton – mali presjeci, armirane konstrukcije.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 2.4,
    tags: %w[beton ugradnja mali presjek armirana gotov mjesalica mikser betonski]
  },
  {
    name: "Ručno ugrađivanje betona – mali presjeci do 0,12m3, armirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u armirane konstrukcije malog presjeka (do 0,12m3) na m1 ili m2, beton spravljen mješalicom ili iz miksera; radovi naniže.",
    info: "Gotov beton – mali presjeci, armirane konstrukcije.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 4.75,
    tags: %w[beton ugradnja mali presjek armirana gotov mjesalica mikser betonski]
  },

  # ------------------------------------
  # RUČNO UGRAĐIVANJE BETONA – SREDNJI PRESJECI 0,12–0,30 m3
  # ------------------------------------
  {
    name: "Ručno ugrađivanje betona – srednji presjeci 0,12–0,30m3 (informativno)",
    description: "Opšti opis: ručno ugrađivanje gotovog betona u srednje presjeke od 0,12m3 do 0,30m3 na m1 ili m2, beton iz mješalice ili miksera; radovi naniže.",
    info: "Informativna napomena – srednji presjeci, gotov beton.",
    tags: %w[beton ugradnja srednji presjek gotov informacija],
    info_norm: true
  },
  {
    name: "Ručno ugrađivanje betona – srednji presjeci 0,12–0,30m3, nearmirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u nearmirane konstrukcije srednjeg presjeka (0,12–0,30m3) na m1 ili m2, beton iz mješalice ili miksera; radovi naniže.",
    info: "Gotov beton – srednji presjeci, nearmirane konstrukcije.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 1.25,
    tags: %w[beton ugradnja srednji presjek nearmirana gotov betonski]
  },
  {
    name: "Ručno ugrađivanje betona – srednji presjeci 0,12–0,30m3, nearmirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u nearmirane konstrukcije srednjeg presjeka (0,12–0,30m3) na m1 ili m2, beton iz mješalice ili miksera; radovi naniže.",
    info: "Gotov beton – srednji presjeci, nearmirane konstrukcije.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.6,
    tags: %w[beton ugradnja srednji presjek nearmirana gotov betonski]
  },
  {
    name: "Ručno ugrađivanje betona – srednji presjeci 0,12–0,30m3, armirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u armirane konstrukcije srednjeg presjeka (0,12–0,30m3) na m1 ili m2, beton iz mješalice ili miksera; radovi naniže.",
    info: "Gotov beton – srednji presjeci, armirane konstrukcije.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 1.4,
    tags: %w[beton ugradnja srednji presjek armirana gotov betonski]
  },
  {
    name: "Ručno ugrađivanje betona – srednji presjeci 0,12–0,30m3, armirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u armirane konstrukcije srednjeg presjeka (0,12–0,30m3) na m1 ili m2, beton iz mješalice ili miksera; radovi naniže.",
    info: "Gotov beton – srednji presjeci, armirane konstrukcije.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.75,
    tags: %w[beton ugradnja srednji presjek armirana gotov betonski]
  },

  # ------------------------------------
  # RUČNO UGRAĐIVANJE BETONA – VELIKI PRESJECI PREKO 0,30 m3
  # ------------------------------------
  {
    name: "Ručno ugrađivanje betona – veliki presjeci preko 0,30m3 (informativno)",
    description: "Opšti opis: ručno ugrađivanje gotovog betona u velike presjeke preko 0,30m3 na m1 ili m2, beton iz mješalice ili miksera; radovi naniže.",
    info: "Informativna napomena – veliki presjeci, gotov beton.",
    tags: %w[beton ugradnja veliki presjek gotov informacija],
    info_norm: true
  },
  {
    name: "Ručno ugrađivanje betona – veliki presjeci preko 0,30m3, nearmirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u nearmirane konstrukcije velikog presjeka (preko 0,30m3) na m1 ili m2.",
    info: "Gotov beton – veliki presjeci, nearmirane konstrukcije.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 0.96,
    tags: %w[beton ugradnja veliki presjek nearmirana gotov betonski]
  },
  {
    name: "Ručno ugrađivanje betona – veliki presjeci preko 0,30m3, nearmirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u nearmirane konstrukcije velikog presjeka (preko 0,30m3) na m1 ili m2.",
    info: "Gotov beton – veliki presjeci, nearmirane konstrukcije.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.31,
    tags: %w[beton ugradnja veliki presjek nearmirana gotov betonski]
  },
  {
    name: "Ručno ugrađivanje betona – veliki presjeci preko 0,30m3, armirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u armirane konstrukcije velikog presjeka (preko 0,30m3) na m1 ili m2.",
    info: "Gotov beton – veliki presjeci, armirane konstrukcije.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 1.08,
    tags: %w[beton ugradnja veliki presjek armirana gotov betonski]
  },
  {
    name: "Ručno ugrađivanje betona – veliki presjeci preko 0,30m3, armirane konstrukcije",
    description: "Ručno ugrađivanje gotovog betona u armirane konstrukcije velikog presjeka (preko 0,30m3) na m1 ili m2.",
    info: "Gotov beton – veliki presjeci, armirane konstrukcije.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 3.43,
    tags: %w[beton ugradnja veliki presjek armirana gotov betonski]
  },

  # ------------------------------------
  # BETONIRANJE PODOVA – PRENOS NANIŽE (GN 400-908)
  # ------------------------------------
  {
    name: "Betoniranje podova – d=5cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom (mješalica ili automikser), debljine 5 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.14,
    tags: %w[beton podovi d5cm nanize gotov betonski]
  },
  {
    name: "Betoniranje podova – d=5cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom (mješalica ili automikser), debljine 5 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.26,
    tags: %w[beton podovi d5cm nanize gotov betonski]
  },
  {
    name: "Betoniranje podova – d=8cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom, debljine 8 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.22,
    tags: %w[beton podovi d8cm nanize gotov betonski]
  },
  {
    name: "Betoniranje podova – d=8cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom, debljine 8 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.41,
    tags: %w[beton podovi d8cm nanize gotov betonski]
  },
  {
    name: "Betoniranje podova – d=10cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom, debljine 10 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.27,
    tags: %w[beton podovi d10cm nanize gotov betonski]
  },
  {
    name: "Betoniranje podova – d=10cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom, debljine 10 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.41,
    tags: %w[beton podovi d10cm nanize gotov betonski]
  },
  {
    name: "Betoniranje podova – d=12cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom, debljine 12 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.32,
    tags: %w[beton podovi d12cm nanize gotov betonski]
  },
  {
    name: "Betoniranje podova – d=12cm, prenos naniže",
    description: "Betoniranje podova gotovim betonom, debljine 12 cm, radovi naniže (GN 400-908).",
    info: "Podovi – gotov beton, prenos naniže.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.6,
    tags: %w[beton podovi d12cm nanize gotov betonski]
  },

  # ------------------------------------
  # BETONIRANJE PODOVA – NA KOTI 0,00 m (GN 400-912)
  # ------------------------------------
  {
    name: "Betoniranje podova – d=5cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom (mješalica ili automikser), debljine 5 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.14,
    tags: %w[beton podovi d5cm kota0 gotov betonski]
  },
  {
    name: "Betoniranje podova – d=5cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom (mješalica ili automikser), debljine 5 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.21,
    tags: %w[beton podovi d5cm kota0 gotov betonski]
  },
  {
    name: "Betoniranje podova – d=8cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom, debljine 8 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.22,
    tags: %w[beton podovi d8cm kota0 gotov betonski]
  },
  {
    name: "Betoniranje podova – d=8cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom, debljine 8 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.32,
    tags: %w[beton podovi d8cm kota0 gotov betonski]
  },
  {
    name: "Betoniranje podova – d=10cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom, debljine 10 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.27,
    tags: %w[beton podovi d10cm kota0 gotov betonski]
  },
  {
    name: "Betoniranje podova – d=10cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom, debljine 10 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.4,
    tags: %w[beton podovi d10cm kota0 gotov betonski]
  },
  {
    name: "Betoniranje podova – d=12cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom, debljine 12 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.32,
    tags: %w[beton podovi d12cm kota0 gotov betonski]
  },
  {
    name: "Betoniranje podova – d=12cm, kota 0.00m",
    description: "Betoniranje podova gotovim betonom, debljine 12 cm, na koti 0.00m (GN 400-912).",
    info: "Podovi – gotov beton, kota 0.00m.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.6,
    tags: %w[beton podovi d12cm kota0 gotov betonski]
  },

  # ------------------------------------
  # BETONIRANJE AB MEĐUSPRATNIH PLOČA – PRENOS KRANOM (GN 400-715,716)
  # ------------------------------------
  {
    name: "Betoniranje AB međuspratnih ploča – d=8cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 8 cm, gotov beton, vertikalni transport kranom (GN 400-715,716).",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.23,
    tags: %w[beton AB ploca d8cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=8cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 8 cm, gotov beton, vertikalni transport kranom (GN 400-715,716).",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.27,
    tags: %w[beton AB ploca d8cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=10cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 10 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.29,
    tags: %w[beton AB ploca d10cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=10cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 10 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.34,
    tags: %w[beton AB ploca d10cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=12cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 12 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.35,
    tags: %w[beton AB ploca d12cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=12cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 12 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.4,
    tags: %w[beton AB ploca d12cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=15cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 15 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.34,
    tags: %w[beton AB ploca d15cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=15cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 15 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.41,
    tags: %w[beton AB ploca d15cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=20cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 20 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.44,
    tags: %w[beton AB ploca d20cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=20cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 20 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.53,
    tags: %w[beton AB ploca d20cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=25cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 25 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.52,
    tags: %w[beton AB ploca d25cm kran betonski]
  },
  {
    name: "Betoniranje AB međuspratnih ploča – d=25cm",
    description: "Betoniranje armiranobetonskih međuspratnih ploča debljine 25 cm, gotov beton, vertikalni transport kranom.",
    info: "AB međuspratne ploče – gotov beton, kran.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.63,
    tags: %w[beton AB ploca d25cm kran betonski]
  },

  # ------------------------------------
  # BETONIRANJE PADA NA KROVU – GOTOV BETON, KRAN
  # ------------------------------------
  {
    name: "Betoniranje pada na krovu – d=8cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 8 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.22,
    tags: %w[beton krov pad d8cm kran betonski]
  },
  {
    name: "Betoniranje pada na krovu – d=8cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 8 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.26,
    tags: %w[beton krov pad d8cm kran betonski]
  },
  {
    name: "Betoniranje pada na krovu – d=10cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 10 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.27,
    tags: %w[beton krov pad d10cm kran betonski]
  },
  {
    name: "Betoniranje pada na krovu – d=10cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 10 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.32,
    tags: %w[beton krov pad d10cm kran betonski]
  },
  {
    name: "Betoniranje pada na krovu – d=12cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 12 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.32,
    tags: %w[beton krov pad d12cm kran betonski]
  },
  {
    name: "Betoniranje pada na krovu – d=12cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 12 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.38,
    tags: %w[beton krov pad d12cm kran betonski]
  },
  {
    name: "Betoniranje pada na krovu – d=15cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 15 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.37,
    tags: %w[beton krov pad d15cm kran betonski]
  },
  {
    name: "Betoniranje pada na krovu – d=15cm",
    description: "Izrada betonskog pada na krovu gotovim betonom debljine 15 cm, prenos kranom.",
    info: "Pad na krovu – gotov beton.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.42,
    tags: %w[beton krov pad d15cm kran betonski]
  },

  # ------------------------------------
  # MAŠINSKO UGRAĐIVANJE BETONA SPRAVLJENOG U FABRICI BETONA – PUMPA
  # ------------------------------------
  {
    name: "Mašinsko ugrađivanje betona – horizontalni transport, do 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa horizontalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine do 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – horizontalno, mali presjeci.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 0.73,
    tags: %w[beton masinsko ugradjivanje pumpa horizontalno do0_30 betonski]
  },
  {
    name: "Mašinsko ugrađivanje betona – horizontalni transport, do 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa horizontalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine do 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – horizontalno, mali presjeci.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.73,
    tags: %w[beton masinsko ugradjivanje pumpa horizontalno do0_30 betonski]
  },
  {
    name: "Mašinsko ugrađivanje betona – horizontalni transport, preko 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa horizontalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine preko 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – horizontalno, veliki presjeci.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 0.61,
    tags: %w[beton masinsko ugradjivanje pumpa horizontalno preko0_30 betonski]
  },
  {
    name: "Mašinsko ugrađivanje betona – horizontalni transport, preko 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa horizontalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine preko 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – horizontalno, veliki presjeci.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.61,
    tags: %w[beton masinsko ugradjivanje pumpa horizontalno preko0_30 betonski]
  },
  {
    name: "Mašinsko ugrađivanje betona – vertikalni transport, do 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa vertikalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine do 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – vertikalno, mali presjeci.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 0.798,
    tags: %w[beton masinsko ugradjivanje pumpa vertikalno do0_30 betonski]
  },
  {
    name: "Mašinsko ugrađivanje betona – vertikalni transport, do 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa vertikalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine do 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – vertikalno, mali presjeci.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 1.104,
    tags: %w[beton masinsko ugradjivanje pumpa vertikalno do0_30 betonski]
  },
  {
    name: "Mašinsko ugrađivanje betona – vertikalni transport, preko 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa vertikalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine preko 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – vertikalno, veliki presjeci.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m3",
    norm_value: 0.67,
    tags: %w[beton masinsko ugradjivanje pumpa vertikalno preko0_30 betonski]
  },
  {
    name: "Mašinsko ugrađivanje betona – vertikalni transport, preko 0,30m3/m2",
    description: "Ugrađivanje betona pumpom sa vertikalnim transportom, kapacitet do 50m3/čas, za konstrukcije zapremine preko 0,30m3 po m2 ili m1.",
    info: "Mašinsko ugrađivanje betona – vertikalno, veliki presjeci.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m3",
    norm_value: 0.976,
    tags: %w[beton masinsko ugradjivanje pumpa vertikalno preko0_30 betonski]
  },

  # ------------------------------------
  # INFORMACIJA – STEPENIŠTE (GAT)
  # ------------------------------------
  {
    name: "Ugradnja betona u stepenište – cijena uključena u GAT normu",
    description: "Ugradnja betona u stepenište zajedno sa oplatom se obračunava u okviru GAT sistema – informativna napomena iz NORME (nema posebne radne norme).",
    info: "Informativna napomena – stepenište, GAT cijena.",
    tags: %w[beton stepeniste GAT informacija],
    info_norm: true
  },

  # ------------------------------------
  # OPLATA TEMELJA I ZIDOVA – DASKE / FOSNE
  # ------------------------------------
  {
    name: "Oplata od daske – ravni temelji i zidovi, oplata 1-strana",
    description: "Tesarska oplata od daske za ravne temelje, mašinske fundamente i ravne zidove, oplata 1-strana.",
    info: "Tesarski-oplata – temelji i zidovi.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.37,
    tags: %w[oplata temelji zidovi daske ravni 1-strana tesarski]
  },
  {
    name: "Oplata od daske – ravni temelji i zidovi, oplata 1-strana",
    description: "Tesarska oplata od daske za ravne temelje, mašinske fundamente i ravne zidove, oplata 1-strana.",
    info: "Tesarski-oplata – temelji i zidovi.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.67,
    tags: %w[oplata temelji zidovi daske ravni 1-strana tesarski]
  },
  {
    name: "Oplata od daske – ravni temelji i zidovi, oplata 2-strane",
    description: "Tesarska oplata od daske za ravne temelje, mašinske fundamente i ravne zidove, oplata 2-strane.",
    info: "Tesarski-oplata – temelji i zidovi.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.38,
    tags: %w[oplata temelji zidovi daske ravni 2-strane tesarski]
  },
  {
    name: "Oplata od daske – ravni temelji i zidovi, oplata 2-strane",
    description: "Tesarska oplata od daske za ravne temelje, mašinske fundamente i ravne zidove, oplata 2-strane.",
    info: "Tesarski-oplata – temelji i zidovi.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.69,
    tags: %w[oplata temelji zidovi daske ravni 2-strane tesarski]
  },
  {
    name: "Oplata od daske – ravni zidovi",
    description: "Tesarska oplata od daske za ravne betonske zidove.",
    info: "Tesarski-oplata – ravni zidovi.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.38,
    tags: %w[oplata zidovi daske ravni tesarski]
  },
  {
    name: "Oplata od daske – ravni zidovi",
    description: "Tesarska oplata od daske za ravne betonske zidove.",
    info: "Tesarski-oplata – ravni zidovi.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.69,
    tags: %w[oplata zidovi daske ravni tesarski]
  },
  {
    name: "Oplata od fosne – ravni temelji i zidovi, oplata 1-strana",
    description: "Tesarska oplata od fosne za ravne temelje, mašinske fundamente i ravne zidove, oplata 1-strana.",
    info: "Tesarski-oplata – temelji i zidovi (fosne).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.37,
    tags: %w[oplata temelji zidovi fosne ravni 1-strana tesarski]
  },
  {
    name: "Oplata od fosne – ravni temelji i zidovi, oplata 1-strana",
    description: "Tesarska oplata od fosne za ravne temelje, mašinske fundamente i ravne zidove, oplata 1-strana.",
    info: "Tesarski-oplata – temelji i zidovi (fosne).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.67,
    tags: %w[oplata temelji zidovi fosne ravni 1-strana tesarski]
  },
  {
    name: "Oplata od fosne – ravni temelji i zidovi, oplata 2-strane",
    description: "Tesarska oplata od fosne za ravne temelje, mašinske fundamente i ravne zidove, oplata 2-strane.",
    info: "Tesarski-oplata – temelji i zidovi (fosne).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.38,
    tags: %w[oplata temelji zidovi fosne ravni 2-strane tesarski]
  },
  {
    name: "Oplata od fosne – ravni temelji i zidovi, oplata 2-strane",
    description: "Tesarska oplata od fosne za ravne temelje, mašinske fundamente i ravne zidove, oplata 2-strane.",
    info: "Tesarski-oplata – temelji i zidovi (fosne).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.69,
    tags: %w[oplata temelji zidovi fosne ravni 2-strane tesarski]
  },
  {
    name: "Oplata od fosne – ravni zidovi",
    description: "Tesarska oplata od fosne za ravne betonske zidove.",
    info: "Tesarski-oplata – ravni zidovi (fosne).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.38,
    tags: %w[oplata zidovi fosne ravni tesarski]
  },
  {
    name: "Oplata od fosne – ravni zidovi",
    description: "Tesarska oplata od fosne za ravne betonske zidove.",
    info: "Tesarski-oplata – ravni zidovi (fosne).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.69,
    tags: %w[oplata zidovi fosne ravni tesarski]
  },

  # ------------------------------------
  # ZAKOŠENE STOPE TEMELJA I SERKLAŽI
  # ------------------------------------
  {
    name: "Oplata zakošenih stopa temelja od daske",
    description: "Oplata zakošenih stopa temelja izvedena od dasaka.",
    info: "Tesarski-oplata – zakošene stope temelja (daske).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.34,
    tags: %w[oplata temelji stope zakosene daske tesarski]
  },
  {
    name: "Oplata zakošenih stopa temelja od daske",
    description: "Oplata zakošenih stopa temelja izvedena od dasaka.",
    info: "Tesarski-oplata – zakošene stope temelja (daske).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.59,
    tags: %w[oplata temelji stope zakosene daske tesarski]
  },
  {
    name: "Oplata zakošenih stopa temelja od fosne",
    description: "Oplata zakošenih stopa temelja izvedena od fosni.",
    info: "Tesarski-oplata – zakošene stope temelja (fosne).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.84,
    tags: %w[oplata temelji stope zakosene fosne tesarski]
  },
  {
    name: "Oplata zakošenih stopa temelja od fosne",
    description: "Oplata zakošenih stopa temelja izvedena od fosni.",
    info: "Tesarski-oplata – zakošene stope temelja (fosne).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[oplata temelji stope zakosene fosne tesarski]
  },
  {
    name: "Oplata serklaža do visine 15m",
    description: "Oplata betonskih serklaža (vijenaca) do visine 15 m.",
    info: "Tesarski-oplata – serklaži do 15 m.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.30,
    tags: %w[oplata serklaz vijenac do15m tesarski]
  },
  {
    name: "Oplata serklaža do visine 15m",
    description: "Oplata betonskih serklaža (vijenaca) do visine 15 m.",
    info: "Tesarski-oplata – serklaži do 15 m.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.06,
    tags: %w[oplata serklaz vijenac do15m tesarski]
  },
  {
    name: "Oplata serklaža na visini preko 15m",
    description: "Oplata betonskih serklaža (vijenaca) na visini preko 15 m.",
    info: "Tesarski-oplata – serklaži preko 15 m.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.48,
    tags: %w[oplata serklaz vijenac preko15m tesarski]
  },
  {
    name: "Oplata serklaža na visini preko 15m",
    description: "Oplata betonskih serklaža (vijenaca) na visini preko 15 m.",
    info: "Tesarski-oplata – serklaži preko 15 m.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.08,
    tags: %w[oplata serklaz vijenac preko15m tesarski]
  },

  # ------------------------------------
  # BETONSKI ZIDOVI LUČNE OSNOVE / RENDISANE DASKE
  # ------------------------------------
  {
    name: "Oplata od daske – betonski zidovi lučne osnove, oplata 1-strana",
    description: "Oplata od daske za betonske zidove lučne osnove, oplata 1-strana.",
    info: "Tesarski-oplata – zidovi lučne osnove (daske).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.41,
    tags: %w[oplata zidovi lucna osnova daske 1-strana tesarski]
  },
  {
    name: "Oplata od daske – betonski zidovi lučne osnove, oplata 1-strana",
    description: "Oplata od daske za betonske zidove lučne osnove, oplata 1-strana.",
    info: "Tesarski-oplata – zidovi lučne osnove (daske).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.28,
    tags: %w[oplata zidovi lucna osnova daske 1-strana tesarski]
  },
  {
    name: "Oplata od daske – betonski zidovi lučne osnove, oplata 2-strane",
    description: "Oplata od daske za betonske zidove lučne osnove, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi lučne osnove (daske).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.46,
    tags: %w[oplata zidovi lucna osnova daske 2-strane tesarski]
  },
  {
    name: "Oplata od daske – betonski zidovi lučne osnove, oplata 2-strane",
    description: "Oplata od daske za betonske zidove lučne osnove, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi lučne osnove (daske).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.28,
    tags: %w[oplata zidovi lucna osnova daske 2-strane tesarski]
  },
  {
    name: "Oplata od daske – betonski zidovi od rendisanih dasaka, oplata 2-strane",
    description: "Oplata od daske za betonske zidove od rendisanih dasaka, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi od rendisanih dasaka (daske).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.65,
    tags: %w[oplata zidovi rendisane daske 2-strane tesarski]
  },
  {
    name: "Oplata od daske – betonski zidovi od rendisanih dasaka, oplata 2-strane",
    description: "Oplata od daske za betonske zidove od rendisanih dasaka, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi od rendisanih dasaka (daske).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.26,
    tags: %w[oplata zidovi rendisane daske 2-strane tesarski]
  },
  {
    name: "Oplata od fosne – betonski zidovi lučne osnove, oplata 1-strana",
    description: "Oplata od fosne za betonske zidove lučne osnove, oplata 1-strana.",
    info: "Tesarski-oplata – zidovi lučne osnove (fosne).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.41,
    tags: %w[oplata zidovi lucna osnova fosne 1-strana tesarski]
  },
  {
    name: "Oplata od fosne – betonski zidovi lučne osnove, oplata 1-strana",
    description: "Oplata od fosne za betonske zidove lučne osnove, oplata 1-strana.",
    info: "Tesarski-oplata – zidovi lučne osnove (fosne).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.28,
    tags: %w[oplata zidovi lucna osnova fosne 1-strana tesarski]
  },
  {
    name: "Oplata od fosne – betonski zidovi lučne osnove, oplata 2-strane",
    description: "Oplata od fosne za betonske zidove lučne osnove, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi lučne osnove (fosne).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.46,
    tags: %w[oplata zidovi lucna osnova fosne 2-strane tesarski]
  },
  {
    name: "Oplata od fosne – betonski zidovi lučne osnove, oplata 2-strane",
    description: "Oplata od fosne za betonske zidove lučne osnove, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi lučne osnove (fosne).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.28,
    tags: %w[oplata zidovi lucna osnova fosne 2-strane tesarski]
  },
  {
    name: "Oplata od fosne – betonski zidovi od rendisanih dasaka, oplata 2-strane",
    description: "Oplata od fosne za betonske zidove od rendisanih dasaka, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi od rendisanih dasaka (fosne).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.65,
    tags: %w[oplata zidovi rendisane daske fosne 2-strane tesarski]
  },
  {
    name: "Oplata od fosne – betonski zidovi od rendisanih dasaka, oplata 2-strane",
    description: "Oplata od fosne za betonske zidove od rendisanih dasaka, oplata 2-strane.",
    info: "Tesarski-oplata – zidovi od rendisanih dasaka (fosne).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.26,
    tags: %w[oplata zidovi rendisane daske fosne 2-strane tesarski]
  },

  # ------------------------------------
  # DVOSTRUKA OPLATA TEMELJNIH GREDA – DOKA
  # ------------------------------------
  {
    name: "Dvostruka oplata temeljnih greda – DOKA ploča d=27mm",
    description: "Dvostruka oplata temeljnih greda ili zidova formirana od DOKA ploča debljine 27mm sa kravatama, distancerima i klincima.",
    info: "Tesarski-oplata – dvostruka oplata temeljnih greda (DOKA).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.40,
    tags: %w[dvostruka oplata temeljne grede DOKA tesarski]
  },
  {
    name: "Dvostruka oplata temeljnih greda – DOKA ploča d=27mm",
    description: "Dvostruka oplata temeljnih greda ili zidova formirana od DOKA ploča debljine 27mm sa kravatama, distancerima i klincima.",
    info: "Tesarski-oplata – dvostruka oplata temeljnih greda (DOKA).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.40,
    tags: %w[dvostruka oplata temeljne grede DOKA tesarski]
  },

  # ------------------------------------
  # OPLATA PLOČA – RAVNE, KOSO/NAGNUTE, REBRASTE
  # ------------------------------------
  {
    name: "Oplata ravnih ploča bez obzira na površinu",
    description: "Oplata ravnih betonskih ploča bez obzira na veličinu, sa podupiranjem metalnim podupiračima do 3m (GN 601-205).",
    info: "Tesarski-oplata – ravne ploče (stari način, danas Doka/blažujka).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.43,
    tags: %w[oplata ploca ravna metalni podupiraci tesarski]
  },
  {
    name: "Oplata ravnih ploča bez obzira na površinu",
    description: "Oplata ravnih betonskih ploča bez obzira na veličinu, sa podupiranjem metalnim podupiračima do 3m (GN 601-205).",
    info: "Tesarski-oplata – ravne ploče (stari način, danas Doka/blažujka).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.66,
    tags: %w[oplata ploca ravna metalni podupiraci tesarski]
  },
  {
    name: "Oplata kosih i nagnutih ploča",
    description: "Oplata kosih i nagnutih betonskih ploča sa podupiranjem metalnim podupiračima do 3m (GN 601-205).",
    info: "Tesarski-oplata – kose i nagnute ploče (stari način, danas Doka/blažujka).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.52,
    tags: %w[oplata ploca kosa nagnuta metalni podupiraci tesarski]
  },
  {
    name: "Oplata kosih i nagnutih ploča",
    description: "Oplata kosih i nagnutih betonskih ploča sa podupiranjem metalnim podupiračima do 3m (GN 601-205).",
    info: "Tesarski-oplata – kose i nagnute ploče (stari način, danas Doka/blažujka).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.78,
    tags: %w[oplata ploca kosa nagnuta metalni podupiraci tesarski]
  },
  {
    name: "Oplata rebrastih ploča sa razmakom rebra 1m",
    description: "Oplata rebrastih betonskih ploča sa razmakom rebra 1m, sa podupiranjem metalnim podupiračima do 3m.",
    info: "Tesarski-oplata – rebraste ploče (stari način, danas Doka/blažujka).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.52,
    tags: %w[oplata ploca rebrasta razmak1m tesarski]
  },
  {
    name: "Oplata rebrastih ploča sa razmakom rebra 1m",
    description: "Oplata rebrastih betonskih ploča sa razmakom rebra 1m, sa podupiranjem metalnim podupiračima do 3m.",
    info: "Tesarski-oplata – rebraste ploče (stari način, danas Doka/blažujka).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.78,
    tags: %w[oplata ploca rebrasta razmak1m tesarski]
  },

  # ------------------------------------
  # OPLATA POKLOPNIH PLOČA DIMNJAKA, OGRADA I STUBOVA
  # ------------------------------------
  {
    name: "Oplata za poklopne ploče dimnjaka/ograda/stubova 60/60 – daske",
    description: "Oplata od daske za poklopne ploče dimnjaka, ograda i stubova dimenzije 60/60.",
    info: "Tesarski-oplata – poklopne ploče, stari način gradnje.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.55,
    tags: %w[oplata poklopna ploca dimnjak ograda stub 60x60 tesarski]
  },
  {
    name: "Oplata za poklopne ploče dimnjaka/ograda/stubova 60/60 – daske",
    description: "Oplata od daske za poklopne ploče dimnjaka, ograda i stubova dimenzije 60/60.",
    info: "Tesarski-oplata – poklopne ploče, stari način gradnje.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.69,
    tags: %w[oplata poklopna ploca dimnjak ograda stub 60x60 tesarski]
  },
  {
    name: "Oplata za poklopne ploče dimnjaka/ograda/stubova 60/100 – daske",
    description: "Oplata od daske za poklopne ploče dimnjaka, ograda i stubova dimenzije 60/100.",
    info: "Tesarski-oplata – poklopne ploče, stari način gradnje.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.70,
    tags: %w[oplata poklopna ploca dimnjak ograda stub 60x100 tesarski]
  },
  {
    name: "Oplata za poklopne ploče dimnjaka/ograda/stubova 60/100 – daske",
    description: "Oplata od daske za poklopne ploče dimnjaka, ograda i stubova dimenzije 60/100.",
    info: "Tesarski-oplata – poklopne ploče, stari način gradnje.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.93,
    tags: %w[oplata poklopna ploca dimnjak ograda stub 60x100 tesarski]
  },
  {
    name: "Oplata za poklopne ploče dimnjaka/ograda/stubova 60/160 – daske",
    description: "Oplata od daske za poklopne ploče dimnjaka, ograda i stubova dimenzije 60/160.",
    info: "Tesarski-oplata – poklopne ploče, stari način gradnje.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.00,
    tags: %w[oplata poklopna ploca dimnjak ograda stub 60x160 tesarski]
  },
  {
    name: "Oplata za poklopne ploče dimnjaka/ograda/stubova 60/160 – daske",
    description: "Oplata od daske za poklopne ploče dimnjaka, ograda i stubova dimenzije 60/160.",
    info: "Tesarski-oplata – poklopne ploče, stari način gradnje.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 1.30,
    tags: %w[oplata poklopna ploca dimnjak ograda stub 60x160 tesarski]
  },

  # ------------------------------------
  # OPLATA BALKONSKIH ZIDOVA I PLOČA
  # ------------------------------------
  {
    name: "Oplata balkonskih ogradnih zidova – daske",
    description: "Oplata od daske za balkonske ogradne zidove.",
    info: "Tesarski-oplata – balkoni, stari način gradnje.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.44,
    tags: %w[oplata balkon ogradni zid daske tesarski]
  },
  {
    name: "Oplata balkonskih ogradnih zidova – daske",
    description: "Oplata od daske za balkonske ogradne zidove.",
    info: "Tesarski-oplata – balkoni, stari način gradnje.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.78,
    tags: %w[oplata balkon ogradni zid daske tesarski]
  },
  {
    name: "Oplata balkonskih ravnih ploča – daske",
    description: "Oplata od daske za balkonske ravne betonske ploče.",
    info: "Tesarski-oplata – balkoni, stari način gradnje.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.52,
    tags: %w[oplata balkon ravna ploca daske tesarski]
  },
  {
    name: "Oplata balkonskih ravnih ploča – daske",
    description: "Oplata od daske za balkonske ravne betonske ploče.",
    info: "Tesarski-oplata – balkoni, stari način gradnje.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.82,
    tags: %w[oplata balkon ravna ploca daske tesarski]
  },
  {
    name: "Izrada krovne konstrukcije – tip 1, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 1, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_1 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 2, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 2, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_2 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 3, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 3, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_3 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 4, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 4, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_4 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 5, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 5, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_5 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 6, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 6, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.8,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_6 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 7, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 7, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.9,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_7 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 8, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 8, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_8 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 9, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 9, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.8,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_9 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 10, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 10, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.8,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_10 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 10, do 200 m2 (NKV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 10, nekvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.6,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_10 NKV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 11, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 11, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.06,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_11 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 12, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 12, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.4,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_12 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 13, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 13, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.1,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_13 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 14, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 14, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.44,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_14 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 15, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 15, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.5,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_15 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 16, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 16, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 2,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_16 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 17, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 17, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_17 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 18, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 18, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.27,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_18 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 19, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 19, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.5,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_19 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 20, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 20, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 2.1,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_20 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 21, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 21, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.45,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_21 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 22, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 22, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.9,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_22 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 23, do 200 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 200 m2, JUS klasifikacija tip 23, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 2.1,
    tags: %w[krov konstrukcija greda tesarski do_200_m2 tip_23 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 1, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 1, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.576,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_1 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 2, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 2, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.576,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_2 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 3, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 3, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.576,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_3 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 4, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 4, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.576,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_4 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 5, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 5, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.576,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_5 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 6, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 6, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.72,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_6 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 7, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 7, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.81,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_7 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 8, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 8, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.576,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_8 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 9, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 9, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.72,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_9 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 10, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 10, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.72,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_10 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 10, do 400 m2 (NKV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 10, nekvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.576,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_10 NKV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 11, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 11, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.954,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_11 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 12, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 12, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.26,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_12 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 13, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 13, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.99,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_13 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 14, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 14, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.296,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_14 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 15, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 15, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.35,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_15 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 16, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 16, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.8,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_16 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 17, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 17, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.9,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_17 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 18, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 18, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.143,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_18 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 19, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 19, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.35,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_19 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 20, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 20, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.89,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_20 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 21, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 21, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.305,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_21 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 22, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 22, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.71,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_22 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 23, do 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove do 400 m2, JUS klasifikacija tip 23, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.89,
    tags: %w[krov konstrukcija greda tesarski do_400_m2 tip_23 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 1, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 1, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.512,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_1 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 2, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 2, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.512,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_2 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 3, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 3, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.512,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_3 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 4, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 4, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.512,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_4 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 5, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 5, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.512,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_5 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 6, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 6, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_6 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 7, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 7, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.72,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_7 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 8, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 8, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.512,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_8 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 9, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 9, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.64,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_9 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 10, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 10, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.12,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_10 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 11, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 11, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.848,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_11 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 12, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 12, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.12,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_12 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 13, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 13, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.88,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_13 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 14, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 14, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.152,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_14 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 15, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 15, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.2,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_15 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 16, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 16, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.6,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_16 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 17, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 17, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.8,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_17 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 18, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 18, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.016,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_18 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 19, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 19, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.2,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_19 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 20, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 20, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.68,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_20 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 21, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 21, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.16,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_21 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 22, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 22, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.52,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_22 KV]
  },
  {
    name: "Izrada krovne konstrukcije – tip 23, preko 400 m2 (KV)",
    description: "Izrada krovne konstrukcije od drvenih greda za krovove osnove preko 400 m2, JUS klasifikacija tip 23, kvalifikovani radnik.",
    info: "Tesarski – krovna konstrukcija.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.68,
    tags: %w[krov konstrukcija greda tesarski preko_400_m2 tip_23 KV]
  },
  {
    name: "Izrada rešetkastih nosača – tip 1, do 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 1, do 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.95,
    tags: %w[krov rešetkasti_nosač tesarski do_50_komada tip_1]
  },
  {
    name: "Izrada rešetkastih nosača – tip 2, do 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 2, do 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.9,
    tags: %w[krov rešetkasti_nosač tesarski do_50_komada tip_2]
  },
  {
    name: "Izrada rešetkastih nosača – tip 3, do 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 3, do 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.8,
    tags: %w[krov rešetkasti_nosač tesarski do_50_komada tip_3]
  },
  {
    name: "Izrada rešetkastih nosača – tip 4, do 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 4, do 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.7,
    tags: %w[krov rešetkasti_nosač tesarski do_50_komada tip_4]
  },
  {
    name: "Izrada rešetkastih nosača – tip 5, do 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 5, do 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.65,
    tags: %w[krov rešetkasti_nosač tesarski do_50_komada tip_5]
  },
  {
    name: "Izrada rešetkastih nosača – tip 1, preko 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 1, preko 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.855,
    tags: %w[krov rešetkasti_nosač tesarski preko_50_komada tip_1]
  },
  {
    name: "Izrada rešetkastih nosača – tip 2, preko 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 2, preko 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.81,
    tags: %w[krov rešetkasti_nosač tesarski preko_50_komada tip_2]
  },
  {
    name: "Izrada rešetkastih nosača – tip 3, preko 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 3, preko 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.72,
    tags: %w[krov rešetkasti_nosač tesarski preko_50_komada tip_3]
  },
  {
    name: "Izrada rešetkastih nosača – tip 4, preko 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 4, preko 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.63,
    tags: %w[krov rešetkasti_nosač tesarski preko_50_komada tip_4]
  },
  {
    name: "Izrada rešetkastih nosača – tip 5, preko 50 komada",
    description: "Izrada rešetkastih nosača od dasaka sastavljenih ekserima za krov i plafon, tip 5, preko 50 komada po objektu, rad motornom testerom, kvalifikovani radnik.",
    info: "Tesarski – rešetkasti nosači.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.586,
    tags: %w[krov rešetkasti_nosač tesarski preko_50_komada tip_5]
  },
  {
    name: "Pokrivanje krova daskama 24mm na dodir – varijanta A (KV)",
    description: "Pokrivanje krova daskama 24mm na dodir. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.2,
    tags: %w[krov pokrivanje tesarski daske varijanta_A KV]
  },
  {
    name: "Pokrivanje krova daskama 24mm na dodir – varijanta A (NKV)",
    description: "Pokrivanje krova daskama 24mm na dodir. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.1,
    tags: %w[krov pokrivanje tesarski daske varijanta_A NKV]
  },
  {
    name: "Jednostavno pokrivanje biber crijepom na 23cm – varijanta A (KV)",
    description: "Jednostavno pokrivanje biber crijepom na 23cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_A KV]
  },
  {
    name: "Jednostavno pokrivanje biber crijepom na 23cm – varijanta A (NKV)",
    description: "Jednostavno pokrivanje biber crijepom na 23cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.06,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_A NKV]
  },
  {
    name: "Gusto pokrivanje biber crijepom na 15cm – varijanta A (KV)",
    description: "Gusto pokrivanje biber crijepom na 15cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.24,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_A KV]
  },
  {
    name: "Gusto pokrivanje biber crijepom na 15cm – varijanta A (NKV)",
    description: "Gusto pokrivanje biber crijepom na 15cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_A NKV]
  },
  {
    name: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm – varijanta A (KV)",
    description: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_A KV]
  },
  {
    name: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm – varijanta A (NKV)",
    description: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.06,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_A NKV]
  },
  {
    name: "Za pokrivanje falcovanim-utorenim crijepom na 32cm – varijanta A (KV)",
    description: "Za pokrivanje falcovanim-utorenim crijepom na 32cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[krov pokrivanje tesarski falcovani crijep varijanta_A KV]
  },
  {
    name: "Za pokrivanje falcovanim-utorenim crijepom na 32cm – varijanta A (NKV)",
    description: "Za pokrivanje falcovanim-utorenim crijepom na 32cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.06,
    tags: %w[krov pokrivanje tesarski falcovani crijep varijanta_A NKV]
  },
  {
    name: "Za pokrivanje salonitom na 50 cm – varijanta A (KV)",
    description: "Za pokrivanje salonitom na 50 cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[krov pokrivanje tesarski salonit varijanta_A KV]
  },
  {
    name: "Za pokrivanje salonitom na 50 cm – varijanta A (NKV)",
    description: "Za pokrivanje salonitom na 50 cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta A.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.06,
    tags: %w[krov pokrivanje tesarski salonit varijanta_A NKV]
  },
  {
    name: "Pokrivanje krova daskama 24mm na dodir – varijanta B (KV)",
    description: "Pokrivanje krova daskama 24mm na dodir. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.05,
    tags: %w[krov pokrivanje tesarski daske varijanta_B KV]
  },
  {
    name: "Pokrivanje krova daskama 24mm na dodir – varijanta B (NKV)",
    description: "Pokrivanje krova daskama 24mm na dodir. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.025,
    tags: %w[krov pokrivanje tesarski daske varijanta_B NKV]
  },
  {
    name: "Jednostavno pokrivanje biber crijepom na 23cm – varijanta B (KV)",
    description: "Jednostavno pokrivanje biber crijepom na 23cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.015,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_B KV]
  },
  {
    name: "Jednostavno pokrivanje biber crijepom na 23cm – varijanta B (NKV)",
    description: "Jednostavno pokrivanje biber crijepom na 23cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.03,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_B NKV]
  },
  {
    name: "Gusto pokrivanje biber crijepom na 15cm – varijanta B (KV)",
    description: "Gusto pokrivanje biber crijepom na 15cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.03,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_B KV]
  },
  {
    name: "Gusto pokrivanje biber crijepom na 15cm – varijanta B (NKV)",
    description: "Gusto pokrivanje biber crijepom na 15cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.06,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_B NKV]
  },
  {
    name: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm – varijanta B (KV)",
    description: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.015,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_B KV]
  },
  {
    name: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm – varijanta B (NKV)",
    description: "Za dvostruko krunsko pokrivanje biber crijepom na 25cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.03,
    tags: %w[krov pokrivanje tesarski biber crijep varijanta_B NKV]
  },
  {
    name: "Za pokrivanje falcovanim-utorenim crijepom na 32cm – varijanta B (KV)",
    description: "Za pokrivanje falcovanim-utorenim crijepom na 32cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.015,
    tags: %w[krov pokrivanje tesarski falcovani crijep varijanta_B KV]
  },
  {
    name: "Za pokrivanje falcovanim-utorenim crijepom na 32cm – varijanta B (NKV)",
    description: "Za pokrivanje falcovanim-utorenim crijepom na 32cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.03,
    tags: %w[krov pokrivanje tesarski falcovani crijep varijanta_B NKV]
  },
  {
    name: "Za pokrivanje salonitom na 50 cm – varijanta B (KV)",
    description: "Za pokrivanje salonitom na 50 cm. Letvisanje krova i polaganje gredica, kvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.015,
    tags: %w[krov pokrivanje tesarski salonit varijanta_B KV]
  },
  {
    name: "Za pokrivanje salonitom na 50 cm – varijanta B (NKV)",
    description: "Za pokrivanje salonitom na 50 cm. Letvisanje krova i polaganje gredica, nekvalifikovani radnik, varijanta B.",
    info: "Tesarski – letvisanje i pokrivanje krova.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.03,
    tags: %w[krov pokrivanje tesarski salonit varijanta_B NKV]
  },
  {
    name: "Prikrivanje čeone daske kod krovova pokrivenih crijepom – varijanta A (KV)",
    description: "Prikrivanje čeone daske kod krovova pokrivenih crijepom. Tesarski radovi na opšivanju venaca daskama, varijanta A, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.09,
    tags: %w[krov vijenac opšivanje tesarski varijanta_A ceona_daska]
  },
  {
    name: "Izrada konstrukcije od gredica na vencu za pokrivanje limom – varijanta A (KV)",
    description: "Izrada konstrukcije od gredica na vencu za pokrivanje limom. Tesarski radovi na opšivanju venaca daskama, varijanta A, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.1,
    tags: %w[krov vijenac opšivanje tesarski varijanta_A lim]
  },
  {
    name: "Opšivanje venca i uvala daskama od 24mm – varijanta A (KV)",
    description: "Opšivanje venca i uvala daskama od 24mm. Tesarski radovi na opšivanju venaca daskama, varijanta A, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.66,
    tags: %w[krov vijenac opšivanje tesarski varijanta_A uvala daske_24mm]
  },
  {
    name: "Opšivanje venca daskama na pero i žljeb preko rogova – varijanta A (KV)",
    description: "Opšivanje venca daskama na pero i žljeb preko rogova. Tesarski radovi na opšivanju venaca daskama, varijanta A, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.72,
    tags: %w[krov vijenac opšivanje tesarski varijanta_A]
  },
  {
    name: "Opšivanje venca daskama od 24mm na pero i žljeb ispod rogova – varijanta A (KV)",
    description: "Opšivanje venca daskama od 24mm na pero i žljeb ispod rogova. Tesarski radovi na opšivanju venaca daskama, varijanta A, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 1.38,
    tags: %w[krov vijenac opšivanje tesarski varijanta_A daske_24mm]
  },
  {
    name: "Prikrivanje čeone daske kod krovova pokrivenih crijepom – varijanta B (KV)",
    description: "Prikrivanje čeone daske kod krovova pokrivenih crijepom. Tesarski radovi na opšivanju venaca daskama, varijanta B, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.018,
    tags: %w[krov vijenac opšivanje tesarski varijanta_B ceona_daska]
  },
  {
    name: "Izrada konstrukcije od gredica na vencu za pokrivanje limom – varijanta B (KV)",
    description: "Izrada konstrukcije od gredica na vencu za pokrivanje limom. Tesarski radovi na opšivanju venaca daskama, varijanta B, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.02,
    tags: %w[krov vijenac opšivanje tesarski varijanta_B lim]
  },
  {
    name: "Opšivanje venca i uvala daskama od 24mm – varijanta B (KV)",
    description: "Opšivanje venca i uvala daskama od 24mm. Tesarski radovi na opšivanju venaca daskama, varijanta B, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.198,
    tags: %w[krov vijenac opšivanje tesarski varijanta_B uvala daske_24mm]
  },
  {
    name: "Opšivanje venca daskama na pero i žljeb preko rogova – varijanta B (KV)",
    description: "Opšivanje venca daskama na pero i žljeb preko rogova. Tesarski radovi na opšivanju venaca daskama, varijanta B, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.18,
    tags: %w[krov vijenac opšivanje tesarski varijanta_B]
  },
  {
    name: "Opšivanje venca daskama od 24mm na pero i žljeb ispod rogova – varijanta B (KV)",
    description: "Opšivanje venca daskama od 24mm na pero i žljeb ispod rogova. Tesarski radovi na opšivanju venaca daskama, varijanta B, kvalifikovani radnik.",
    info: "Tesarski – opšivanje venaca daskama GN 601-500.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m",
    norm_value: 0.414,
    tags: %w[krov vijenac opšivanje tesarski varijanta_B daske_24mm]
  },
  {
    name: "Pokrivanje krova sa jednim slojem ter hartije (KV)",
    description: "Pokrivanje krova sa jednim slojem ter hartije. Pokrivanje krova Ter hartijom kvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.1,
    tags: %w[krov pokrivanje tesarski ter-hartija KV]
  },
  {
    name: "Pokrivanje krova sa jednim slojem ter hartije (NKV)",
    description: "Pokrivanje krova sa jednim slojem ter hartije. Pokrivanje krova Ter hartijom nekvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[krov pokrivanje tesarski ter-hartija NKV]
  },
  {
    name: "Pokrivanje falcovanim crijepom-bey vezivanja crijepa (KV)",
    description: "Pokrivanje falcovanim crijepom-bey vezivanja crijepa. Pokrivanje krova falcovanim crijepom 20x42 kvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.12,
    tags: %w[krov pokrivanje tesarski falcovani crijep KV]
  },
  {
    name: "Pokrivanje falcovanim crijepom-bey vezivanja crijepa (NKV)",
    description: "Pokrivanje falcovanim crijepom-bey vezivanja crijepa. Pokrivanje krova falcovanim crijepom 20x42 nekvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.18,
    tags: %w[krov pokrivanje tesarski falcovani crijep NKV]
  },
  {
    name: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe do 3m (KV)",
    description: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe do 3m. Pokrivanje krova falcovanim crijepom 20x42 kvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.2,
    tags: %w[krov pokrivanje tesarski falcovani crijep KV]
  },
  {
    name: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe do 3m (NKV)",
    description: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe do 3m. Pokrivanje krova falcovanim crijepom 20x42 nekvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.2,
    tags: %w[krov pokrivanje tesarski falcovani crijep NKV]
  },
  {
    name: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe preko 3m (KV)",
    description: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe preko 3m. Pokrivanje krova falcovanim crijepom 20x42 kvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.25,
    tags: %w[krov pokrivanje tesarski falcovani crijep KV]
  },
  {
    name: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe preko 3m (NKV)",
    description: "Pokrivanje falcovanim crijepom-sa vezivanjem svakog trećeg crijepa za krovoe preko 3m. Pokrivanje krova falcovanim crijepom 20x42 nekvalifikovani radnik.",
    info: "Tesarski – pokrivanje krova (Ter hartija / falcovani crijep).",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.25,
    tags: %w[krov pokrivanje tesarski falcovani crijep NKV]
  },
  {
    name: "Zaribana fasada Bavalit (KV)",
    description: "Zaribana fasada Bavalit. Fasaderski radovi po normativima, KV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.25,
    tags: %w[fasada fasaderski bavalit zaribana kv]
  },
  {
    name: "Zaribana fasada Bavalit (NKV)",
    description: "Zaribana fasada Bavalit. Fasaderski radovi po normativima, NKV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.1,
    tags: %w[fasada fasaderski bavalit zaribana nkv]
  },
  {
    name: "Zaribana akrilni malter 1,5 mm (KV)",
    description: "Zaribana akrilni malter 1,5 mm. Fasaderski radovi po normativima, KV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.25,
    tags: %w[fasada fasaderski akrilni zaribana malter kv]
  },
  {
    name: "Zaribana akrilni malter 1,5 mm (NKV)",
    description: "Zaribana akrilni malter 1,5 mm. Fasaderski radovi po normativima, NKV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.1,
    tags: %w[fasada fasaderski akrilni zaribana malter nkv]
  },
  {
    name: "Hirofa fasada (KV)",
    description: "Hirofa fasada. Fasaderski radovi po normativima, KV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.25,
    tags: %w[fasada fasaderski hirofa kv]
  },
  {
    name: "Hirofa fasada (NKV)",
    description: "Hirofa fasada. Fasaderski radovi po normativima, NKV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.1,
    tags: %w[fasada fasaderski hirofa nkv]
  },
  {
    name: "Kulir (KV)",
    description: "Kulir. Fasaderski radovi po normativima, KV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.25,
    tags: %w[fasada fasaderski kulir kv]
  },
  {
    name: "Kulir (NKV)",
    description: "Kulir. Fasaderski radovi po normativima, NKV radnik.",
    info: "Fasaderski radovi – završna obrada fasade.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.1,
    tags: %w[fasada fasaderski kulir nkv]
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 1, 1 sloj obloge, masa + bandaž traka (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 1 (2) Termoizolacija: Da                    Obrada spojeva: Masa za spojnice i bandaž traka (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.83,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_1 masa_spojnice bandaz_traka termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 1, 1 sloj obloge, specijalna masa bez bandaža (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 1 (2) Termoizolacija: Da                    Obrada spojeva: Specijalna masa bez bandaž trake (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.78,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_1 specijalna_masa bez_bandaza
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 1, 2 sloja obloge, masa + bandaž traka (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 2 (4) Termoizolacija: Da                    Obrada spojeva: Masa za spojnice i bandaž traka (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.03,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_1 masa_spojnice bandaz_traka termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 1, 2 sloja obloge, specijalna masa bez bandaža (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 2 (4) Termoizolacija: Da                    Obrada spojeva: Specijalna masa bez bandaž trake (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.98,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_1 specijalna_masa bez_bandaza
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 1, 3 sloja obloge, masa + bandaž traka (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 3 (6)  Termoizolacija: Da                    Obrada spojeva: Masa za spojnice i bandaž traka (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.23,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_1 masa_spojnice bandaz_traka termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 1, 3 sloja obloge, specijalna masa bez bandaža (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 3 (6) Termoizolacija: Da                    Obrada spojeva: Specijalna masa bez bandaž trake (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.18,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_1 specijalna_masa bez_bandaza
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 2, 2 sloja obloge, masa + bandaž traka (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 2   Oblaganje gips pločama: 2 (4)  Termoizolacija: Da                    Obrada spojeva: Masa za spojnice i bandaž traka (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.25,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_2 masa_spojnice bandaz_traka termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 2, 2 sloja obloge, specijalna masa bez bandaža (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Metalna potkonstrukcija: 2   Oblaganje gips pločama: 2 (4) Termoizolacija: Da                    Obrada spojeva: Specijalna masa bez bandaž trake (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.2,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_2 specijalna_masa bez_bandaza
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 2, 2 sloja obloge, protivpožarne ploče, masa + bandaž traka (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Zid izmedju stanova - protiv požarne ploče                          Metalna potkonstrukcija: 2   Oblaganje gips pločama: 2+1 (5)  Termoizolacija: Da                    Obrada spojeva: Masa za spojnice i bandaž traka (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.35,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_2 protivpozarni masa_spojnice bandaz_traka
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – metalna potkonstrukcija – metalna potk. 2, 2 sloja obloge, protivpožarne ploče, specijalna masa bez bandaža (KV)",
    description: "Pregradni zid od gipsa – metalna potkonstrukcija. Zid izmedju stanova - protiv požarne ploče                          Metalna potkonstrukcija: 2   Oblaganje gips pločama: 2+1 (5)  Termoizolacija: Da                    Obrada spojeva: Specijalna masa bez bandaž trake (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na metalnoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.3,
    tags: %w[suvo_montazni gipskarton pregradni_zid metalna_potkonstrukcija_2 protivpozarni specijalna_masa bez_bandaza
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – drvena potkonstrukcija – drvena potk. 1, 1 sloj obloge, masa + bandaž traka (KV)",
    description: "Pregradni zid od gipsa – drvena potkonstrukcija. Drvena potkonstrukcija: 1   Oblaganje gips pločama: 1 Termoizolacija: Ne                    Obrada spojeva: Masa za spojnice i bandaž traka                                       Direktno učvršćeno za drvene grede (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na drvenoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.85,
    tags: %w[suvo_montazni gipskarton pregradni_zid drvena_potkonstrukcija masa_spojnice bandaz_traka termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – drvena potkonstrukcija – drvena potk. 1, 1 sloj obloge, specijalna masa bez bandaža (KV)",
    description: "Pregradni zid od gipsa – drvena potkonstrukcija. Drvena potkonstrukcija: 1   Oblaganje gips pločama: 1  Termoizolacija: Ne                    Obrada spojeva: Specijalna masa bez bandaž trake                     Direktno učvršćeno za drvene grede (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na drvenoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.735,
    tags: %w[suvo_montazni gipskarton pregradni_zid drvena_potkonstrukcija specijalna_masa bez_bandaza termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – drvena potkonstrukcija – drvena potk. 1, 2 sloja obloge, masa + bandaž traka (KV)",
    description: "Pregradni zid od gipsa – drvena potkonstrukcija. Drvena potkonstrukcija: 1   Oblaganje gips pločama: 2 Termoizolacija: Ne                    Obrada spojeva: Masa za spojnice i bandaž traka                             Direktno učvršćeno za drvene grede (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na drvenoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.985,
    tags: %w[suvo_montazni gipskarton pregradni_zid drvena_potkonstrukcija masa_spojnice bandaz_traka termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Pregradni zid od gipsa – drvena potkonstrukcija – drvena potk. 1, 2 sloja obloge, specijalna masa bez bandaža (KV)",
    description: "Pregradni zid od gipsa – drvena potkonstrukcija. Drvena potkonstrukcija: 1   Oblaganje gips pločama: 2  Termoizolacija: Ne                    Obrada spojeva: Specijalna masa bez bandaž trake                                Direktno učvršćeno za drvene grede (KV radnik).",
    info: "Suvo-montažni radovi – gipskartonski pregradni zidovi na drvenoj potkonstrukciji.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.935,
    tags: %w[suvo_montazni gipskarton pregradni_zid drvena_potkonstrukcija specijalna_masa bez_bandaza termoizolacija
             kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, 1 sloj obloge, masa + bandaž traka, vješanje žicom sa ušicom (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 1 Termoizolacija: Ne                      Obrada spojeva: Masa za spojnice i bandaž traka                                            Vješanje žicom sa ušicom (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.83,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 masa_spojnice bandaz_traka vjesanje_zicom
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, 1 sloj obloge, specijalna masa bez bandaža, vješanje žicom sa ušicom (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 1  Termoizolacija: Ne                    Obrada spojeva: Specijalna masa bez bandaž trake                                Vješanje žicom sa ušicom (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.78,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 specijalna_masa bez_bandaza vjesanje_zicom
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, masa + bandaž traka, vješanje žicom sa ušicom (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama:2 Termoizolacija: Ne                      Obrada spojeva: Masa za spojnice i bandaž traka                                       Vješanje žicom sa ušicom (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.03,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 masa_spojnice bandaz_traka vjesanje_zicom
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, 2 sloja obloge, specijalna masa bez bandaža, vješanje žicom sa ušicom (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 2 Termoizolacija: Ne                      Obrada spojeva: Specijalna masa bez bandaž trake                       Vješanje žicom sa ušicom (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.98,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 specijalna_masa bez_bandaza vjesanje_zicom
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, 1 sloj obloge, masa + bandaž traka, vješanje nonius elementima (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 1 Termoizolacija: Ne                      Obrada spojeva: Masa za spojnice i bandaž traka                                       Vješanje žnonius elemntima (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.81,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 masa_spojnice bandaz_traka nonius_vjesanje
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, 1 sloj obloge, specijalna masa bez bandaža, vješanje nonius elementima (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 1  Termoizolacija: Ne                      Obrada spojeva: Specijalna masa bez bandaž trake                                Vješanje nonius elemntima (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.76,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 specijalna_masa bez_bandaza nonius_vjesanje
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, 2 sloja obloge, masa + bandaž traka, vješanje nonius elementima (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 2 Termoizolacija: Ne                      Obrada spojeva: Masa za spojnice i bandaž traka                                       Vješanje žnonius elemntima (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 1.01,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 masa_spojnice bandaz_traka nonius_vjesanje
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Spušteni plafon od gipskartonskih ploča – metalna potk. 1, 2 sloja obloge, specijalna masa bez bandaža, vješanje nonius elementima (KV)",
    description: "Spušteni plafon od gipskartonskih ploča. Metalna potkonstrukcija: 1   Oblaganje gips pločama: 2 Termoizolacija: Ne                      Obrada spojeva: Specijalna masa bez bandaž trake                                Vješanje nonius elemntima (KV radnik).",
    info: "Suvo-montažni radovi – spušteni plafoni od gipskartonskih ploča.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.96,
    tags: %w[suvo_montazni gipskarton plafon metalna_potkonstrukcija_1 specijalna_masa bez_bandaza nonius_vjesanje
             termoizolacija kv],
    info_norm: false
  },
  {
    name: "Pregradni zid: W112: Knauf ploča A 13 12,5 mm 1250/2750",
    description: "Pregradni zid: W112: Knauf ploča A 13 12,5 mm 1250/2750. Potrebna kolicina: 4 m2 po 1 m2 pregradnog zida W112. Jedinica mere: m2. Cijena po jedinici: 442.4 din. Cijena po 1 m2 zida: 1769.6 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "m2",
    norm_value: 4,
    tags: %w[knauf w112 pregradni_zid ploca],
    info_norm: true
  },
  {
    name: "Uniflott 5 kg",
    description: "Uniflott 5 kg. Potrebna kolicina: 0,8 kg po 1 m2 pregradnog zida W112. Jedinica mere: kg. Cijena po jedinici: 187 din. Cijena po 1 m2 zida: 149.6 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "kg",
    norm_value: 0.8,
    tags: %w[knauf uniflott],
    info_norm: true
  },
  {
    name: "CW-Profil 75x0,5 3000mm",
    description: "CW-Profil 75x0,5 3000mm. Potrebna kolicina: 2 m po 1 m2 pregradnog zida W112. Jedinica mere: m. Cijena po jedinici: 244.67 din. Cijena po 1 m2 zida: 489.34 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "m",
    norm_value: 2,
    tags: %w[knauf profil],
    info_norm: true
  },
  {
    name: "UW-Profil 75x40x0,5 4000 mm",
    description: "UW-Profil 75x40x0,5 4000 mm. Potrebna kolicina: 0,7 m po 1 m2 pregradnog zida W112. Jedinica mere: m. Cijena po jedinici: 205 din. Cijena po 1 m2 zida: 143.5 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "m",
    norm_value: 0.7,
    tags: %w[knauf profil],
    info_norm: true
  },
  {
    name: "PE-Brtvena traka 70 mm",
    description: "PE-Brtvena traka 70 mm. Potrebna kolicina: 1,2 m po 1 m2 pregradnog zida W112. Jedinica mere: m. Cijena po jedinici: 43.33 din. Cijena po 1 m2 zida: 51.995999999999995 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "m",
    norm_value: 1.2,
    tags: %w[knauf],
    info_norm: true
  },
  {
    name: "Vijci TN 25 / 1000 kom",
    description: "Vijci TN 25 / 1000 kom. Potrebna kolicina: 12,5 kom po 1 m2 pregradnog zida W112. Jedinica mere: kom. Cijena po jedinici: 2 din. Cijena po 1 m2 zida: 25 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "kom",
    norm_value: 12.5,
    tags: %w[knauf vijci],
    info_norm: true
  },
  {
    name: "Vijci TN 35 1000 kom.",
    description: "Vijci TN 35 1000 kom.. Potrebna kolicina: 29 kom po 1 m2 pregradnog zida W112. Jedinica mere: kom. Cijena po jedinici: 1.8 din. Cijena po 1 m2 zida: 52.2 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "kom",
    norm_value: 29,
    tags: %w[knauf vijci],
    info_norm: true
  },
  {
    name: "Tipla s vijkom K 6/35 mm, 100 kom.",
    description: "Tipla s vijkom K 6/35 mm, 100 kom.. Potrebna kolicina: 1,8 kom po 1 m2 pregradnog zida W112. Jedinica mere: kom. Cijena po jedinici: 8 din. Cijena po 1 m2 zida: 14.4 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "kom",
    norm_value: 1.8,
    tags: %w[knauf tipla],
    info_norm: true
  },
  {
    name: "Izolacijski materijal 50 mm",
    description: "Izolacijski materijal 50 mm. Potrebna kolicina: 1 m2 po 1 m2 pregradnog zida W112. Jedinica mere: m2. Cijena po jedinici: 162 din. Cijena po 1 m2 zida: 162 din.",
    info: "Knauf sistem W112 – informativna potrošnja i cijena materijala po 1 m2 pregradnog zida.",
    unit_of_measure: "m2",
    norm_value: 1,
    tags: %w[knauf izolacija],
    info_norm: true
  },
  {
    name: "Knauf ploča A 13 12,5 mm 1250/2750",
    description: "Knauf ploča A 13 12,5 mm 1250/2750. Potrebna kolicina: 1 m2 po 1 m2 spuštenog plafona D112. Jedinica mere: m2. Cijena po jedinici: 442.4 din. Cijena po 1 m2 plafona: 442.4 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "m2",
    norm_value: 1,
    tags: %w[knauf ploca],
    info_norm: true
  },
  {
    name: "Uniflott 5 kg",
    description: "Uniflott 5 kg. Potrebna kolicina: 0,3 kg po 1 m2 spuštenog plafona D112. Jedinica mere: kg. Cijena po jedinici: 187 din. Cijena po 1 m2 plafona: 56.1 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kg",
    norm_value: 0.3,
    tags: %w[knauf uniflott],
    info_norm: true
  },
  {
    name: "CD-Profil 60/27 4000 0,5 mm",
    description: "CD-Profil 60/27 4000 0,5 mm. Potrebna kolicina: 3,2 m po 1 m2 spuštenog plafona D112. Jedinica mere: m. Cijena po jedinici: 185.67 din. Cijena po 1 m2 plafona: 594.144 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "m",
    norm_value: 3.2,
    tags: %w[knauf profil],
    info_norm: true
  },
  {
    name: "UD-Profil 28x27x0,5",
    description: "UD-Profil 28x27x0,5. Potrebna kolicina: 0,4 m po 1 m2 spuštenog plafona D112. Jedinica mere: m. Cijena po jedinici: 106.67 din. Cijena po 1 m2 plafona: 42.668000000000006 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "m",
    norm_value: 0.4,
    tags: %w[knauf profil],
    info_norm: true
  },
  {
    name: "Vijci TN 25 / 1000 kom",
    description: "Vijci TN 25 / 1000 kom. Potrebna kolicina: 23 kom po 1 m2 spuštenog plafona D112. Jedinica mere: kom. Cijena po jedinici: 1.4 din. Cijena po 1 m2 plafona: 32.199999999999996 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kom",
    norm_value: 23,
    tags: %w[knauf vijci],
    info_norm: true
  },
  {
    name: "Tipla s vijkom K 6/35 mm, 100 kom.",
    description: "Tipla s vijkom K 6/35 mm, 100 kom.. Potrebna kolicina: 0,8 kom po 1 m2 spuštenog plafona D112. Jedinica mere: kom. Cijena po jedinici: 8 din. Cijena po 1 m2 plafona: 6.4 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kom",
    norm_value: 0.8,
    tags: %w[knauf tipla],
    info_norm: true
  },
  {
    name: "Sidreni ovjes s polugom",
    description: "Sidreni ovjes s polugom. Potrebna kolicina: 1,3 kom po 1 m2 spuštenog plafona D112. Jedinica mere: kom. Cijena po jedinici: 83 din. Cijena po 1 m2 plafona: 107.9 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kom",
    norm_value: 1.3,
    tags: %w[knauf sidreni_ovjes],
    info_norm: true
  },
  {
    name: "Žica s ušicom 250 mm",
    description: "Žica s ušicom 250 mm. Potrebna kolicina: 1,3 kom po 1 m2 spuštenog plafona D112. Jedinica mere: kom. Cijena po jedinici: 18 din. Cijena po 1 m2 plafona: 23.400000000000002 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kom",
    norm_value: 1.3,
    tags: %w[knauf zica],
    info_norm: true
  },
  {
    name: "Ravna spojnica za CD-Profil 60/27",
    description: "Ravna spojnica za CD-Profil 60/27. Potrebna kolicina: 0,6 kom po 1 m2 spuštenog plafona D112. Jedinica mere: kom. Cijena po jedinici: 34 din. Cijena po 1 m2 plafona: 20.4 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kom",
    norm_value: 0.6,
    tags: %w[knauf profil spojnica],
    info_norm: true
  },
  {
    name: "Križna spojnica za CD-Profil 60/27",
    description: "Križna spojnica za CD-Profil 60/27. Potrebna kolicina: 2,3 kom po 1 m2 spuštenog plafona D112. Jedinica mere: kom. Cijena po jedinici: 38 din. Cijena po 1 m2 plafona: 87.39999999999999 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kom",
    norm_value: 2.3,
    tags: %w[knauf profil spojnica],
    info_norm: true
  },
  {
    name: "Sidreni čavao 6x35 mm",
    description: "Sidreni čavao 6x35 mm. Potrebna kolicina: 1,3 kom po 1 m2 spuštenog plafona D112. Jedinica mere: kom. Cijena po jedinici: 16.3 din. Cijena po 1 m2 plafona: 21.19 din.",
    info: "Knauf sistem D112 – informativna potrošnja i cijena materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "kom",
    norm_value: 1.3,
    tags: %w[knauf cavao],
    info_norm: true
  },
  {
    name: "Knauf sistem W112 – ukupni troškovi (materijal + rad)",
    description: "Informativni proračun Knauf sistema W112 (pregradni zid). Ukupna cijena materijala po 1 m2 zida: 2857.636 din. Rad: približno 8 eur/m2. Ukupno materijal + rad: oko 24.01 eur/m2.",
    info: "Knauf W112 – sažetak informativnih troškova po 1 m2 pregradnog zida (materijal + rad).",
    unit_of_measure: "m2",
    norm_value: nil,
    tags: %w[knauf w112 pregradni_zid ukupno trosak],
    info_norm: true
  },
  {
    name: "Knauf sistem D112 – ukupni troškovi materijala",
    description: "Informativni proračun Knauf sistema D112 (spušteni plafon). Ukupna cijena materijala po 1 m2 plafona: 1434.2020000000005 din. Trošak rada nije specificiran u tablici.",
    info: "Knauf D112 – sažetak informativnih troškova materijala po 1 m2 spuštenog plafona.",
    unit_of_measure: "m2",
    norm_value: nil,
    tags: %w[knauf d112 spusteni_plafon ukupno trosak],
    info_norm: true
  },
  {
    name: "Postavljanje brodskog poda d=20mm preko letvi 3/5 na 50cm (KV)",
    description: "Ugradnja brodskog poda debljine 20 mm preko letvi 3/5 na razmaku 50 cm, uključuje raspored, pričvršćivanje i prilagođavanje dasaka.",
    info: "Podopolagački radovi – postavljanje brodskog poda preko drvenih letvi.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.85,
    tags: %w[podopolagacki brodski_pod drveni_pod kv],
    info_norm: false
  },
  {
    name: "Postavljanje brodskog poda d=20mm preko letvi 3/5 na 50cm (NKV)",
    description: "Ugradnja brodskog poda debljine 20 mm preko letvi 3/5 na razmaku 50 cm, uključuje raspored, pričvršćivanje i prilagođavanje dasaka.",
    info: "Podopolagački radovi – postavljanje brodskog poda preko drvenih letvi.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.15,
    tags: %w[podopolagacki brodski_pod drveni_pod nkv],
    info_norm: false
  },
  {
    name: "Hoblovanje novog poda (KV)",
    description: "Mašinsko hoblovanje novog drvenog poda radi izravnavanja površine i pripreme za lakiranje.",
    info: "Podopolagački radovi – mašinsko hoblovanje novougrađenog drvenog poda.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.24,
    tags: %w[podopolagacki hoblovanje drveni_pod kv],
    info_norm: false
  },
  {
    name: "Lakiranje (KV)",
    description: "Lakiranje",
    info: "Podopolagački radovi – radovi na drvenim podovima/parketu.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.6,
    tags: %w[podopolagacki kv lakiranje],
    info_norm: false
  },
  {
    name: "Postavljanje parketa I klase hrastovog (KV)",
    description: "Polaganje parketa I klase sa uklapanjem, poravnanjem i osnovnom obradom spojeva.",
    info: "Podopolagački radovi – postavljanje parketa I klase (hrast/bukva) na pripremljenu podlogu.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.6,
    tags: %w[podopolagacki parket postavljanje kv],
    info_norm: false
  },
  {
    name: "Hoblovanje novog parketa(mašinsko) (KV)",
    description: "Strojno hoblovanje novog parketa radi izravnanja i uklanjanja neravnina prije završne obrade.",
    info: "Podopolagački radovi – mašinsko hoblovanje novougrađenog parketa.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.24,
    tags: %w[podopolagacki parket hoblovanje novi kv],
    info_norm: false
  },
  {
    name: "Hoblovanje starog parketa(mašinsko) (KV)",
    description: "Strojna obnova starog parketa skidanjem starog laka i izravnavanjem habanih zona.",
    info: "Podopolagački radovi – mašinsko hoblovanje starog parketa.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.5,
    tags: %w[podopolagacki parket hoblovanje stari kv],
    info_norm: false
  },
  {
    name: "Lakiranje( u III sloja) (KV)",
    description: "Lakiranje parketa u tri sloja sa međuslojnim brušenjem, za visoku otpornost i završni sjaj.",
    info: "Podopolagački radovi – lakiranje parketa u tri sloja.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.85,
    tags: %w[podopolagacki parket lakiranje tri_sloja kv],
    info_norm: false
  },
  {
    name: "Lakiranje( u II sloja) (KV)",
    description: "Lakiranje drvenog poda u više slojeva, uključuje pripremu površine između slojeva.",
    info: "Podopolagački radovi – lakiranje drvenog poda.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.6,
    tags: %w[podopolagacki lakiranje drveni_pod kv],
    info_norm: false
  },
  {
    name: "Podlogiranje (KV)",
    description: "Podlogiranje zidnih/ stropnih površina odgovarajućom podlogom radi ujednačavanja upojnosti prije gletovanja i bojenja.",
    info: "Molersko-farbarski radovi – priprema podloge (impregnacija/podloga) prije bojenja.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.018,
    tags: %w[molerski podlogiranje priprema kv],
    info_norm: false
  },
  {
    name: "Bojenje disperzijom 1. i 2.  ruka (KV)",
    description: "Nanošenje dvije ruke disperzijske boje na prethodno pripremljene površine, uključuje provjeru i lokalnu sanaciju podloge.",
    info: "Molersko-farbarski radovi – bojanje unutrašnjih zidova i plafona disperzijskom bojom u dvije ruke.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.128,
    tags: %w[molerski bojenje disperzija unutrasnje kv],
    info_norm: false
  },
  {
    name: "Gletovanje I i II ruka (KV)",
    description: "Gletovanje zidova i plafona glet masom u dvije ruke uz brušenje između slojeva.",
    info: "Molersko-farbarski radovi – gletovanje unutrašnjih površina u dvije ruke.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.197,
    tags: %w[molerski gletovanje unutrasnje kv],
    info_norm: false
  },
  {
    name: "Ljuštenje slojeva ispucale boje (KV)",
    description: "Ručno ili mehaničko ljuštenje i struganje ispucale boje sa zidnih površina.",
    info: "Molersko-farbarski radovi – mehaničko uklanjanje starih ispucalih slojeva boje.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.069,
    tags: %w[molerski skidanje_boje renoviranje kv ljustenje],
    info_norm: false
  },
  {
    name: "Ljuštenje boje sa zidova (zdrave i nezdrave) lopaticom (KV)",
    description: "Skidanje starih premaza lopaticom sa zidova prije daljnje obrade.",
    info: "Molersko-farbarski radovi – uklanjanje postojeće boje lopaticom sa zdravih i nezdravih površina.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.144,
    tags: %w[molerski skidanje_boje lopatica kv ljustenje],
    info_norm: false
  },
  {
    name: "Farbanje fasade fasadnom bojom sa prethodnom impregnacijom (KV)",
    description: "Impregnacija i farbanje fasadnih površina fasadnom bojom u jednoj ili više ruku.",
    info: "Molersko-farbarski radovi – bojanje fasade fasadnom bojom sa prethodnom impregnacijom.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.16,
    tags: %w[molerski fasada farbanje impregnacija kv],
    info_norm: false
  },
  {
    name: "Gletovanje spoljašnjih površina (KV)",
    description: "Gletovanje vanjskih zidova glet masom prilagođenom fasadama.",
    info: "Molersko-farbarski radovi – gletovanje vanjskih fasadnih površina.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.197,
    tags: %w[molerski fasada gletovanje kv],
    info_norm: false
  },
  {
    name: "Bojenje 1. i 2.  ruka BK Pol Crystal Vodoperiva (KV)",
    description: "Nanošenje dvije ruke BK Pol Crystal vodoperive boje na unutrašnje zidove/plafone.",
    info: "Molersko-farbarski radovi – bojanje vodoperivom bojom BK Pol Crystal, dvije ruke.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.128,
    tags: %w[molerski bojenje bk_pol_crystal vodoperiva kv],
    info_norm: false
  },
  {
    name: "Osnovni hladni premaz bitulitom (KV)",
    description: "Osnovni hladni bitumenski premaz prije ugradnje hidroizolacionih traka. Norma rada po 1 m2 površine.",
    info: "Izolaterski radovi – osnovni hladni premaz bitulitom na betonskim ili zidanim površinama.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.008,
    tags: %w[izolaterski hidroizolacija bitumenski_premaz kv bitulit],
    info_norm: false
  },
  {
    name: "Osnovni hladni premaz bitulitom (NKV)",
    description: "Osnovni hladni bitumenski premaz prije ugradnje hidroizolacionih traka. Norma rada po 1 m2 površine.",
    info: "Izolaterski radovi – osnovni hladni premaz bitulitom na betonskim ili zidanim površinama.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.032,
    tags: %w[izolaterski hidroizolacija bitumenski_premaz nkv bitulit],
    info_norm: false
  },
  {
    name: "Kondor 3 sa varenjem preklopa (KV)",
    description: "Ugradnja kondor trake sa varenjem preklopa, uključuje pripremu podloge i izvođenje varova. Norma rada po 1 m2 površine.",
    info: "Izolaterski radovi – polaganje kondor bitumenske trake sa varenjem preklopa.",
    norm_type: :worker,
    subtype: :skilled,
    unit_of_measure: "m2",
    norm_value: 0.0206,
    tags: %w[izolaterski hidroizolacija kondor traka kv],
    info_norm: false
  },
  {
    name: "Kondor 3 sa varenjem preklopa (NKV)",
    description: "Ugradnja kondor trake sa varenjem preklopa, uključuje pripremu podloge i izvođenje varova. Norma rada po 1 m2 površine.",
    info: "Izolaterski radovi – polaganje kondor bitumenske trake sa varenjem preklopa.",
    norm_type: :worker,
    subtype: :unskilled,
    unit_of_measure: "m2",
    norm_value: 0.0824,
    tags: %w[izolaterski hidroizolacija kondor traka nkv],
    info_norm: false
  },
  {
    name: "Keramičarske pločice I klasa – standard",
    description: "Keramičarske pločice I klasa, standard. Jedinica mere: m2. Cijena po m2: 505 din. Potrošnja po 1 m2 obložene površine: 1 m2. Proizvođač: Ker.Kanjiža.",
    info: "Keramičarski radovi – informativna potrošnja i cijena materijala po 1 m2 keramičkih obloga.",
    unit_of_measure: "m2",
    norm_value: 1,
    tags: %w[keramika keramicarski materijal plocice],
    info_norm: true
  },
  {
    name: "Lepak za pločice AK 9",
    description: "Lepak za pločice AK 9. Jedinica mere: kg. Cijena po kg: 11.6 din. Potrošnja po 1 m2 obložene površine: 1,5-4 kg. Proizvođač: Isomat.",
    info: "Keramičarski radovi – informativna potrošnja i cijena materijala po 1 m2 keramičkih obloga.",
    unit_of_measure: "kg",
    norm_value: nil,
    tags: %w[keramika keramicarski materijal plocice lepak],
    info_norm: true
  },
  {
    name: "Lepak za pločice CM 11",
    description: "Lepak za pločice CM 11. Jedinica mere: kg. Cijena po kg: 25 din. Potrošnja po 1 m2 obložene površine: 2,5-3,7 kg. Proizvođač: Ceresit.",
    info: "Keramičarski radovi – informativna potrošnja i cijena materijala po 1 m2 keramičkih obloga.",
    unit_of_measure: "kg",
    norm_value: nil,
    tags: %w[keramika keramicarski materijal plocice lepak],
    info_norm: true
  },
  {
    name: "Lepak za pločice CM 16",
    description: "Lepak za pločice CM 16. Jedinica mere: kg. Cijena po kg: 44.16 din. Potrošnja po 1 m2 obložene površine: 2,5-3,7 kg. Proizvođač: Ceresit.",
    info: "Keramičarski radovi – informativna potrošnja i cijena materijala po 1 m2 keramičkih obloga.",
    unit_of_measure: "kg",
    norm_value: nil,
    tags: %w[keramika keramicarski materijal plocice lepak],
    info_norm: true
  },
  {
    name: "Fug masa za keramičke pločice",
    description: "Fug masa. Jedinica mere: kg. Cijena po kg: 85 din. Potrošnja po 1 m2 obložene površine: 0.3 kg. Proizvođač: Jub.",
    info: "Keramičarski radovi – informativna potrošnja i cijena materijala po 1 m2 keramičkih obloga.",
    unit_of_measure: "kg",
    norm_value: 0.3,
    tags: %w[keramika keramicarski materijal fug_masa],
    info_norm: true
  },
  {
    name: "Keramičarski radovi – ruke (GAT cijena)",
    description: "RUKE CIJENA GAT 10€/m2. Informativna cijena rada po 1 m2 keramičkih obloga.",
    info: "Keramičarski radovi – informativna cijena ruku (radova) prema GAT normativima.",
    unit_of_measure: "m2",
    norm_value: nil,
    tags: %w[keramika keramicarski ruke gat cijena],
    info_norm: true
  }
]
