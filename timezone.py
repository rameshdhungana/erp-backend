# timezone_list = []
# for each in countries:
#     zones = each['timezones']
#     for zone in zones:
#         timezone_list.append(((zone), (each['code'])))
# with open('timezone.py', 'w') as time_zone:
#     time_zone.write(str(tuple(timezone_list)))
# print(timezone_list)

timezones = (('Europe/Andorra', 'AD'), ('Asia/Kabul', 'AF'), ('America/Antigua', 'AG'), ('Europe/Tirane', 'AL'),
             ('Asia/Yerevan', 'AM'), ('Africa/Luanda', 'AO'), ('America/Argentina/Buenos_Aires', 'AR'),
             ('America/Argentina/Cordoba', 'AR'), ('America/Argentina/Jujuy', 'AR'),
             ('America/Argentina/Tucuman', 'AR'),
             ('America/Argentina/Catamarca', 'AR'), ('America/Argentina/La_Rioja', 'AR'),
             ('America/Argentina/San_Juan', 'AR'),
             ('America/Argentina/Mendoza', 'AR'), ('America/Argentina/Rio_Gallegos', 'AR'),
             ('America/Argentina/Ushuaia', 'AR'),
             ('Europe/Vienna', 'AT'), ('Australia/Lord_Howe', 'AU'), ('Australia/Hobart', 'AU'),
             ('Australia/Currie', 'AU'),
             ('Australia/Melbourne', 'AU'), ('Australia/Sydney', 'AU'), ('Australia/Broken_Hill', 'AU'),
             ('Australia/Brisbane', 'AU'), ('Australia/Lindeman', 'AU'), ('Australia/Adelaide', 'AU'),
             ('Australia/Darwin', 'AU'),
             ('Australia/Perth', 'AU'), ('Asia/Baku', 'AZ'), ('America/Barbados', 'BB'), ('Asia/Dhaka', 'BD'),
             ('Europe/Brussels', 'BE'), ('Africa/Ouagadougou', 'BF'), ('Europe/Sofia', 'BG'), ('Asia/Bahrain', 'BH'),
             ('Africa/Bujumbura', 'BI'), ('Africa/Porto-Novo', 'BJ'), ('Asia/Brunei', 'BN'), ('America/La_Paz', 'BO'),
             ('America/Noronha', 'BR'), ('America/Belem', 'BR'), ('America/Fortaleza', 'BR'), ('America/Recife', 'BR'),
             ('America/Araguaina', 'BR'), ('America/Maceio', 'BR'), ('America/Bahia', 'BR'),
             ('America/Sao_Paulo', 'BR'),
             ('America/Campo_Grande', 'BR'), ('America/Cuiaba', 'BR'), ('America/Porto_Velho', 'BR'),
             ('America/Boa_Vista', 'BR'),
             ('America/Manaus', 'BR'), ('America/Eirunepe', 'BR'), ('America/Rio_Branco', 'BR'),
             ('America/Nassau', 'BS'),
             ('Asia/Thimphu', 'BT'), ('Africa/Gaborone', 'BW'), ('Europe/Minsk', 'BY'), ('America/Belize', 'BZ'),
             ('America/St_Johns', 'CA'), ('America/Halifax', 'CA'), ('America/Glace_Bay', 'CA'),
             ('America/Moncton', 'CA'),
             ('America/Goose_Bay', 'CA'), ('America/Blanc-Sablon', 'CA'), ('America/Montreal', 'CA'),
             ('America/Toronto', 'CA'),
             ('America/Nipigon', 'CA'), ('America/Thunder_Bay', 'CA'), ('America/Pangnirtung', 'CA'),
             ('America/Iqaluit', 'CA'),
             ('America/Atikokan', 'CA'), ('America/Rankin_Inlet', 'CA'), ('America/Winnipeg', 'CA'),
             ('America/Rainy_River', 'CA'),
             ('America/Cambridge_Bay', 'CA'), ('America/Regina', 'CA'), ('America/Swift_Current', 'CA'),
             ('America/Edmonton', 'CA'),
             ('America/Yellowknife', 'CA'), ('America/Inuvik', 'CA'), ('America/Dawson_Creek', 'CA'),
             ('America/Vancouver', 'CA'),
             ('America/Whitehorse', 'CA'), ('America/Dawson', 'CA'), ('Africa/Kinshasa', 'CD'),
             ('Africa/Lubumbashi', 'CD'),
             ('Africa/Brazzaville', 'CG'), ('Africa/Abidjan', 'CI'), ('America/Santiago', 'CL'),
             ('Pacific/Easter', 'CL'),
             ('Africa/Douala', 'CM'), ('Asia/Shanghai', 'CN'), ('Asia/Harbin', 'CN'), ('Asia/Chongqing', 'CN'),
             ('Asia/Urumqi', 'CN'), ('Asia/Kashgar', 'CN'), ('America/Bogota', 'CO'), ('America/Costa_Rica', 'CR'),
             ('America/Havana', 'CU'), ('Atlantic/Cape_Verde', 'CV'), ('Asia/Nicosia', 'CY'), ('Europe/Prague', 'CZ'),
             ('Europe/Berlin', 'DE'), ('Africa/Djibouti', 'DJ'), ('Europe/Copenhagen', 'DK'),
             ('America/Dominica', 'DM'),
             ('America/Santo_Domingo', 'DO'), ('America/Guayaquil', 'EC'), ('Pacific/Galapagos', 'EC'),
             ('Europe/Tallinn', 'EE'),
             ('Africa/Cairo', 'EG'), ('Africa/Asmera', 'ER'), ('Africa/Addis_Ababa', 'ET'), ('Europe/Helsinki', 'FI'),
             ('Pacific/Fiji', 'FJ'), ('Europe/Paris', 'FR'), ('Africa/Libreville', 'GA'), ('Asia/Tbilisi', 'GE'),
             ('Africa/Accra', 'GH'), ('Africa/Banjul', 'GM'), ('Africa/Conakry', 'GN'), ('Europe/Athens', 'GR'),
             ('America/Guatemala', 'GT'), ('America/Guatemala', 'GT'), ('Africa/Bissau', 'GW'),
             ('America/Guyana', 'GY'),
             ('America/Tegucigalpa', 'HN'), ('Europe/Budapest', 'HU'), ('Asia/Jakarta', 'ID'), ('Asia/Pontianak', 'ID'),
             ('Asia/Makassar', 'ID'), ('Asia/Jayapura', 'ID'), ('Europe/Dublin', 'IE'), ('Asia/Jerusalem', 'IL'),
             ('Asia/Calcutta', 'IN'), ('Asia/Baghdad', 'IQ'), ('Asia/Tehran', 'IR'), ('Atlantic/Reykjavik', 'IS'),
             ('Europe/Rome', 'IT'), ('America/Jamaica', 'JM'), ('Asia/Amman', 'JO'), ('Asia/Tokyo', 'JP'),
             ('Africa/Nairobi', 'KE'),
             ('Asia/Bishkek', 'KG'), ('Pacific/Tarawa', 'KI'), ('Pacific/Enderbury', 'KI'),
             ('Pacific/Kiritimati', 'KI'),
             ('Asia/Pyongyang', 'KP'), ('Asia/Seoul', 'KR'), ('Asia/Kuwait', 'KW'), ('Asia/Beirut', 'LB'),
             ('Europe/Vaduz', 'LI'),
             ('Africa/Monrovia', 'LR'), ('Africa/Maseru', 'LS'), ('Europe/Vilnius', 'LT'), ('Europe/Luxembourg', 'LU'),
             ('Europe/Riga', 'LV'), ('Africa/Tripoli', 'LY'), ('Indian/Antananarivo', 'MG'), ('Pacific/Majuro', 'MH'),
             ('Pacific/Kwajalein', 'MH'), ('Europe/Skopje', 'MK'), ('Africa/Bamako', 'ML'), ('Asia/Rangoon', 'MM'),
             ('Asia/Ulaanbaatar', 'MN'), ('Asia/Hovd', 'MN'), ('Asia/Choibalsan', 'MN'), ('Africa/Nouakchott', 'MR'),
             ('Europe/Malta', 'MT'), ('Indian/Mauritius', 'MU'), ('Indian/Maldives', 'MV'), ('Africa/Blantyre', 'MW'),
             ('America/Mexico_City', 'MX'), ('America/Cancun', 'MX'), ('America/Merida', 'MX'),
             ('America/Monterrey', 'MX'),
             ('America/Mazatlan', 'MX'), ('America/Chihuahua', 'MX'), ('America/Hermosillo', 'MX'),
             ('America/Tijuana', 'MX'),
             ('Asia/Kuala_Lumpur', 'MY'), ('Asia/Kuching', 'MY'), ('Africa/Maputo', 'MZ'), ('Africa/Windhoek', 'NA'),
             ('Africa/Niamey', 'NE'), ('Africa/Lagos', 'NG'), ('America/Managua', 'NI'), ('Europe/Amsterdam', 'NL'),
             ('Europe/Oslo', 'NO'), ('Asia/Katmandu', 'NP'), ('Pacific/Nauru', 'NR'), ('Pacific/Auckland', 'NZ'),
             ('Pacific/Chatham', 'NZ'), ('Asia/Muscat', 'OM'), ('America/Panama', 'PA'), ('America/Lima', 'PE'),
             ('Pacific/Port_Moresby', 'PG'), ('Asia/Manila', 'PH'), ('Asia/Karachi', 'PK'), ('Europe/Warsaw', 'PL'),
             ('Europe/Lisbon', 'PT'), ('Atlantic/Madeira', 'PT'), ('Atlantic/Azores', 'PT'), ('Pacific/Palau', 'PW'),
             ('America/Asuncion', 'PY'), ('Asia/Qatar', 'QA'), ('Europe/Bucharest', 'RO'), ('Europe/Kaliningrad', 'RU'),
             ('Europe/Moscow', 'RU'), ('Europe/Volgograd', 'RU'), ('Europe/Samara', 'RU'), ('Asia/Yekaterinburg', 'RU'),
             ('Asia/Omsk', 'RU'), ('Asia/Novosibirsk', 'RU'), ('Asia/Krasnoyarsk', 'RU'), ('Asia/Irkutsk', 'RU'),
             ('Asia/Yakutsk', 'RU'), ('Asia/Vladivostok', 'RU'), ('Asia/Sakhalin', 'RU'), ('Asia/Magadan', 'RU'),
             ('Asia/Kamchatka', 'RU'), ('Asia/Anadyr', 'RU'), ('Africa/Kigali', 'RW'), ('Asia/Riyadh', 'SA'),
             ('Pacific/Guadalcanal', 'SB'), ('Indian/Mahe', 'SC'), ('Africa/Khartoum', 'SD'),
             ('Europe/Stockholm', 'SE'),
             ('Asia/Singapore', 'SG'), ('Europe/Ljubljana', 'SI'), ('Europe/Bratislava', 'SK'),
             ('Africa/Freetown', 'SL'),
             ('Europe/San_Marino', 'SM'), ('Africa/Dakar', 'SN'), ('Africa/Mogadishu', 'SO'),
             ('America/Paramaribo', 'SR'),
             ('Africa/Sao_Tome', 'ST'), ('Asia/Damascus', 'SY'), ('Africa/Lome', 'TG'), ('Asia/Bangkok', 'TH'),
             ('Asia/Dushanbe', 'TJ'), ('Asia/Ashgabat', 'TM'), ('Africa/Tunis', 'TN'), ('Pacific/Tongatapu', 'TO'),
             ('Europe/Istanbul', 'TR'), ('America/Port_of_Spain', 'TT'), ('Pacific/Funafuti', 'TV'),
             ('Africa/Dar_es_Salaam', 'TZ'),
             ('Europe/Kiev', 'UA'), ('Europe/Uzhgorod', 'UA'), ('Europe/Zaporozhye', 'UA'), ('Europe/Simferopol', 'UA'),
             ('Africa/Kampala', 'UG'), ('America/New_York', 'US'), ('America/Detroit', 'US'),
             ('America/Kentucky/Louisville', 'US'),
             ('America/Kentucky/Monticello', 'US'), ('America/Indiana/Indianapolis', 'US'),
             ('America/Indiana/Marengo', 'US'),
             ('America/Indiana/Knox', 'US'), ('America/Indiana/Vevay', 'US'), ('America/Chicago', 'US'),
             ('America/Indiana/Vincennes', 'US'), ('America/Indiana/Petersburg', 'US'), ('America/Menominee', 'US'),
             ('America/North_Dakota/Center', 'US'), ('America/North_Dakota/New_Salem', 'US'), ('America/Denver', 'US'),
             ('America/Boise', 'US'), ('America/Shiprock', 'US'), ('America/Phoenix', 'US'),
             ('America/Los_Angeles', 'US'),
             ('America/Anchorage', 'US'), ('America/Juneau', 'US'), ('America/Yakutat', 'US'), ('America/Nome', 'US'),
             ('America/Adak', 'US'), ('Pacific/Honolulu', 'US'), ('America/Montevideo', 'UY'), ('Asia/Samarkand', 'UZ'),
             ('Asia/Tashkent', 'UZ'), ('Europe/Vatican', 'VA'), ('America/Caracas', 'VE'), ('Asia/Saigon', 'VN'),
             ('Pacific/Efate', 'VU'), ('Asia/Aden', 'YE'), ('Africa/Lusaka', 'ZM'), ('Africa/Harare', 'ZW'),
             ('Africa/Algiers', 'DZ'), ('Europe/Sarajevo', 'BA'), ('Asia/Phnom_Penh', 'KH'), ('Africa/Bangui', 'CF'),
             ('Africa/Ndjamena', 'TD'), ('Indian/Comoro', 'KM'), ('Europe/Zagreb', 'HR'), ('Asia/Dili', 'TL'),
             ('America/El_Salvador', 'SV'), ('Africa/Malabo', 'GQ'), ('America/Grenada', 'GD'), ('Asia/Almaty', 'KZ'),
             ('Asia/Qyzylorda', 'KZ'), ('Asia/Aqtobe', 'KZ'), ('Asia/Aqtau', 'KZ'), ('Asia/Oral', 'KZ'),
             ('Asia/Vientiane', 'LA'),
             ('Pacific/Truk', 'FM'), ('Pacific/Ponape', 'FM'), ('Pacific/Kosrae', 'FM'), ('Europe/Chisinau', 'MD'),
             ('Europe/Monaco', 'MC'), ('Europe/Podgorica', 'ME'), ('Africa/Casablanca', 'MA'),
             ('America/St_Kitts', 'KN'),
             ('America/St_Lucia', 'LC'), ('America/St_Vincent', 'VC'), ('Pacific/Apia', 'WS'),
             ('Europe/Belgrade', 'RS'),
             ('Africa/Johannesburg', 'ZA'), ('Europe/Madrid', 'ES'), ('Africa/Ceuta', 'ES'), ('Atlantic/Canary', 'ES'),
             ('Asia/Colombo', 'LK'), ('Africa/Mbabane', 'SZ'), ('Europe/Zurich', 'CH'), ('Asia/Dubai', 'AE'),
             ('Europe/London', 'GB'))