export const microwaveEtsiLink = () => {
  const etsiLink = {
    "name"
  :
    "Microwave",
      "copyright-information"
  :
    "Copyright Nokia 2020",
      "objects"
  :
    [{
      "name": "UBT-S",
      "id": "ubt-s",
      "SI": "UBT-S",
      "HTML_id": "tmpl-ubt",
      "UI_el": "dropdown",
      "size": 9,
      "default": true
    },
      {
        "name": "UBT-T",
        "id": "ubt-t",
        "SI": "UBT-t",
        "HTML_id": "tmpl-ubt",
        "UI_el": "dropdown",
        "size": 9,
        "default": false
      },
      {
        "name": "UBT-m",
        "id": "ubt-m",
        "SI": "UBT-m",
        "HTML_id": "tmpl-ubt",
        "UI_el": "dropdown",
        "size": 9,
        "default": false
      },
      {
        "name": "UBT-C",
        "id": "ubt-c",
        "SI": "UBT-c",
        "category": "ubt",
        "HTML_id": "tmpl-ubt",
        "UI_el": "dropdown",
        "size": 9
      },
      {
        "name": "UBT-m + UBT-S",
        "id": "ubt-m-and-ubt-s",
        "SI": "ubt-m-and-ubt-s",
        "HTML_id": "tmpl-ubt",
        "UI_el": "dropdown",
        "constraints": [],
        "size": 9,
        "default": true,
        "commands": ["select carrier-aggregation-millimeterwave-microwave-auto"]
      },
      {
        "name": "UBT-m + UBT-T",
        "id": "ubt-m-and-ubt-t",
        "SI": "ubt-m-and-ubt-t",
        "HTML_id": "tmpl-ubt",
        "UI_el": "dropdown",
        "constraints": [],
        "size": 9,
        "default": true,
        "commands": ["select carrier-aggregation-millimeterwave-microwave-auto"]
      },
      {
        "name": "1+0",
        "id": "radio-configuration-1+0",
        "SI": "1+0",
        "HTML_id": "tmpl-radio-configuration",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-t",
          "or",
          "contains-items ubt-m",
          "or",
          "contains-items ubt-c"
        ],
        "size": 6,
        "default": true
      },
      {
        "name": "1+1 HSB",
        "id": "radio-configuration-1+1-hsb",
        "SI": "1+1",
        "HTML_id": "tmpl-radio-configuration",
        "UI_el": "dropdown",
        "size": 6,
        "constraints": ["contains-items ubt-s"],
        "default": false
      },
      {
        "name": "2+0",
        "id": "radio-configuration-2+0",
        "SI": "2+0",
        "HTML_id": "tmpl-radio-configuration",
        "UI_el": "dropdown",
        "size": 6,
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-t",
          "or",
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s"
        ],
        "default": true
      },
      {
        "name": "2+2 HSB",
        "id": "radio-configuration-2+2-hsb",
        "SI": "2+2",
        "HTML_id": "tmpl-radio-configuration",
        "UI_el": "dropdown",
        "size": 6,
        "constraints": ["contains-items ubt-t"],
        "default": false
      },
      {
        "name": "3+0",
        "id": "radio-configuration-3+0",
        "SI": "3+0",
        "HTML_id": "tmpl-radio-configuration",
        "UI_el": "dropdown",
        "size": 6,
        "constraints": [
          "contains-items ubt-m-and-ubt-t",
          "or",
          "contains-items ubt-t"
        ],
        "default": true
      },
      {
        "name": "4+0",
        "id": "radio-configuration-4+0",
        "SI": "4+0",
        "HTML_id": "tmpl-radio-configuration",
        "UI_el": "dropdown",
        "size": 6,
        "constraints": ["contains-items ubt-t"],
        "default": false
      },
      {
        "name": "Adaptive modulation",
        "id": "adaptive-modulation",
        "SI": "ADAPTIVEMODULATION",
        "HTML_id": "tmpl-adaptive-modulation",
        "UI_el": "checkbox",
        "default": true
      },
      {
        "name": "HQAM",
        "description": "Standard HQAM",
        "id": "hqam",
        "SI": "HQAM",
        "HTML_id": "tmpl-hqam",
        "constraints": [
          "contains-items ubt-s ubt1-capacity-50mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-s ubt1-capacity-100mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-s ubt1-capacity-160mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-s ubt1-capacity-200mbit",
          "and",
          "doesnt-contain-items hqam-auto",
          "or",

          "contains-items ubt-s ubt1-capacity-300mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-s ubt1-capacity-400mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-s ubt1-capacity-600mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-s ubt1-capacity-800mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-50mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-100mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-160mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-200mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-300mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-400mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-600mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-c ubt1-capacity-800mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-t ubt1-capacity-300mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-t ubt1-capacity-400mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-t ubt1-capacity-600mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-t ubt1-capacity-800mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-t ubt1-capacity-1gbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-t ubt1-capacity-1.5gbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-50mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-100mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-160mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-200mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-300mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-400mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-600mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-s ubt2-capacity-800mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-t ubt2-capacity-300mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-t ubt2-capacity-400mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-t ubt2-capacity-600mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-t ubt2-capacity-800mbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-t ubt2-capacity-1gbit",
          "and",
          "doesnt-contain-items hqam-auto",

          "or",

          "contains-items ubt-m-and-ubt-t ubt2-capacity-1.5gbit",
          "and",
          "doesnt-contain-items hqam-auto"
        ],
        "UI_el": "checkbox",
        "default": false
      },
      {
        "name": "HQAM",
        "description": "Auto-selected HQAM",
        "id": "hqam-auto",
        "SI": "HQAM",
        "HTML_id": "tmpl-hqam",
        "constraints": [
          "contains-items ubt-s ubt1-capacity-1gbit",
          "or",
          "contains-items ubt-c ubt1-capacity-1gbit",
          "or",
          "contains-items ubt-t ubt1-capacity-2gbit",
          "or",
          "contains-items ubt-t ubt2-capacity-2gbit",
          "or",
          "contains-items ubt-s ubt2-capacity-1gbit",
          "or",
          "contains-items ubt-m-and-ubt-s ubt2-capacity-1gbit",
          "or",
          "contains-items ubt-m-and-ubt-t ubt2-capacity-2gbit"
        ],
        "UI_el": "checkbox",
        "default": false,
        "disabled": true
      },
      {
        "name": "HQAM E-band",
        "id": "hqam-e-band",
        "SI": "HQAM-E-BAND",
        "HTML_id": "tmpl-hqam-e-band",
        "constraints": [
          "contains-items ubt-m",
          "and",
          "doesnt-contain-items ubt1-capacity-10gbit",
          "or",
          "contains-items ubt-m-and-ubt-t",
          "and",
          "doesnt-contain-items ubt1-capacity-10gbit",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "and",
          "doesnt-contain-items ubt1-capacity-10gbit"
        ],
        "UI_el": "checkbox",
        "default": false
      },
      {
        "name": "HQAM E-band",
        "id": "hqam-e-band-auto",
        "SI": "HQAM-E-BAND",
        "HTML_id": "tmpl-hqam-e-band",
        "constraints": [
          "contains-items ubt-m ubt1-capacity-10gbit",
          "or",
          "contains-items ubt-m-and-ubt-t ubt1-capacity-10gbit",
          "or",
          "contains-items ubt-m-and-ubt-s ubt1-capacity-10gbit"
        ],
        "UI_el": "checkbox",
        "default": false,
        "disabled": true
      },
      {
        "name": "Channel spacing > 500 Mhz",
        "id": "channel-spacing-500-mhz",
        "SI": "CHANNELSPACING500MHZ",
        "HTML_id": "tmpl-channel-spacing-500-mhz",
        "constraints": [
          "contains-items ubt-m ubt1-capacity-1gbit",
          "or",
          "contains-items ubt-m ubt1-capacity-1.5gbit",
          "or",
          "contains-items ubt-m ubt1-capacity-2gbit",
          "or",
          "contains-items ubt-m-and-ubt-t ubt1-capacity-1gbit",
          "or",
          "contains-items ubt-m-and-ubt-t ubt1-capacity-1.5gbit",
          "or",
          "contains-items ubt-m-and-ubt-t ubt1-capacity-2gbit",
          "or",
          "contains-items ubt-m-and-ubt-s ubt1-capacity-1gbit",
          "or",
          "contains-items ubt-m-and-ubt-s ubt1-capacity-1.5gbit",
          "or",
          "contains-items ubt-m-and-ubt-s ubt1-capacity-2gbit"
        ],
        "UI_el": "checkbox",
        "default": false
      },
      {
        "name": "Channel spacing  > 500 Mhz",
        "id": "channel-spacing-500-mhz-auto",
        "SI": "CHANNELSPACING500MHZ",
        "HTML_id": "tmpl-channel-spacing-500-mhz",
        "constraints": [
          "contains-items ubt-m",
          "and",
          "doesnt-contain-items ubt1-capacity-1gbit ubt1-capacity-1.5gbit ubt1-capacity-2gbit",
          "or",
          "contains-items ubt-m-and-ubt-t",
          "and",
          "doesnt-contain-items ubt1-capacity-1gbit ubt1-capacity-1.5gbit ubt1-capacity-2gbit",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "and",
          "doesnt-contain-items ubt1-capacity-1gbit ubt1-capacity-1.5gbit ubt1-capacity-2gbit"
        ],
        "UI_el": "checkbox",
        "default": false,
        "disabled": true
      },
      {
        "name": "Copolar",
        "id": "copolar",
        "SI": "COPOLAR",
        "HTML_id": "tmpl-polarization",
        "UI_el": "dropdown",
        "size": "2",
        "constraints": [
          "contains-items ubt-s radio-configuration-2+0",
          "or",
          "contains-items ubt-t radio-configuration-1+0",
          "or",
          "contains-items ubt-t radio-configuration-2+0",
          "or",
          "contains-items ubt-t radio-configuration-2+2-hsb",
          "or",
          "contains-items ubt-t radio-configuration-3+0",
          "or",
          "contains-items ubt-t radio-configuration-4+0",
          "or",
          "contains-items ubt-m-and-ubt-t radio-configuration-3+0"
        ],
        "default": false
      },
      {
        "name": "Alternate polar",
        "id": "alternate-polar",
        "SI": "ALTERNATEPOLAR",
        "HTML_id": "tmpl-polarization",
        "UI_el": "dropdown",
        "size": "2",
        "constraints": [
          "contains-items ubt-s radio-configuration-2+0",
          "or",
          "contains-items ubt-t radio-configuration-1+0",
          "or",
          "contains-items ubt-t radio-configuration-2+0",
          "or",
          "contains-items ubt-t radio-configuration-2+2-hsb",
          "or",
          "contains-items ubt-t radio-configuration-3+0",
          "or",
          "contains-items ubt-t radio-configuration-4+0",
          "or",
          "contains-items ubt-m radio-configuration-2+0",
          "or",
          "contains-items ubt-m-and-ubt-t radio-configuration-3+0"
        ],
        "default": true
      },
      {
        "name": "None",
        "id": "no-polarization",
        "SI": "NOPOLARIZATION",
        "HTML_id": "tmpl-polarization",
        "UI_el": "dropdown",
        "size": "2",
        "constraints": [
          "contains-items ubt-s radio-configuration-1+0",
          "or",
          "contains-items ubt-s radio-configuration-1+1-hsb",
          "or",
          "contains-items ubt-m radio-configuration-1+0",
          "or",
          "contains-items ubt-c radio-configuration-1+0",
          "or",
          "contains-items ubt-m-and-ubt-s radio-configuration-2+0"
        ],
        "default": true
      },
      {
        "name": "XPIC",
        "id": "xpic",
        "SI": "XPIC",
        "HTML_id": "tmpl-xpic",
        "constraints": ["contains-items alternate-polar"],
        "UI_el": "checkbox",
        "default": false
      },
      {
        "name": "Carrier aggregation",
        "id": "carrier-aggregation-microwave-microwave",
        "SI": "carrier-aggregation-microwave-microwave",
        "HTML_id": "tmpl-carrier-aggregation",
        "constraints": [
          "contains-items ubt-t radio-configuration-3+0",
          "or",
          "contains-items ubt-t radio-configuration-4+0",
          "or",
          "contains-items ubt-s radio-configuration-2+0"
        ],
        "UI_el": "checkbox",
        "default": false
      },
      {
        "name": "Carrier aggregation",
        "id": "carrier-aggregation-millimeterwave-microwave-auto",
        "SI": "carrier-aggregation-millimeterwave-microwave-auto",
        "HTML_id": "tmpl-carrier-aggregation",
        "constraints": [
          "contains-items ubt-m-and-ubt-t",
          "or",
          "contains-items ubt-m-and-ubt-s"
        ],
        "UI_el": "checkbox",
        "default": false,
        "disabled": true
      },
      {
        "name": "Carrier aggregation",
        "id": "carrier-aggregation-millimeterwave-microwave",
        "SI": "carrier-aggregation-millimeterwave-microwave",
        "HTML_id": "tmpl-carrier-aggregation",
        "constraints": [
          "contains-items ubt-m radio-configuration-2+0"
        ],
        "UI_el": "checkbox",
        "default": false
      },
      {
        "name": "Show 2nd UBT capacity",
        "description": "Checkbox for controlling UBT 2 capacity list visibility",
        "id": "show-2nd-ubt-capacity",
        "SI": "SHOW2NDUBTCAPACITY",
        "HTML_id": "tmpl-show-2nd-ubt-capacity",
        "UI_el": "checkbox",
        "constraints": [
          "contains-items ubt-s radio-configuration-2+0",
          "or",
          "contains-items ubt-t radio-configuration-3+0",
          "or",
          "contains-items ubt-t radio-configuration-4+0",
          "or",
          "contains-items ubt-m radio-configuration-2+0"
        ],
        "default": false
      },
      {
        "name": "50 Mbit/s",
        "id": "ubt1-capacity-50mbit",
        "SI": "UBT1-CAPACITY-50MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "100 Mbit/s",
        "id": "ubt1-capacity-100mbit",
        "SI": "UBT1-CAPACITY-100MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "160 Mbit/s",
        "id": "ubt1-capacity-160mbit",
        "SI": "UBT1-CAPACITY-160MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "200 Mbit/s",
        "id": "ubt1-capacity-200mbit",
        "SI": "UBT1-CAPACITY-200MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "300 Mbit/s",
        "id": "ubt1-capacity-300mbit",
        "SI": "UBT1-CAPACITY-300MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c",
          "or",
          "contains-items ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "400 Mbit/s",
        "id": "ubt1-capacity-400mbit",
        "SI": "UBT1-CAPACITY-400MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c",
          "or",
          "contains-items ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "600 Mbit/s",
        "id": "ubt1-capacity-600mbit",
        "SI": "UBT1-CAPACITY-600MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c",
          "or",
          "contains-items ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "800 Mbit/s",
        "id": "ubt1-capacity-800mbit",
        "SI": "UBT1-CAPACITY-800MBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c",
          "or",
          "contains-items ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "1 Gbit/s",
        "id": "ubt1-capacity-1gbit",
        "description": "Automatically selects hqam",
        "SI": "UBT1-CAPACITY-1GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-s",
          "or",
          "contains-items ubt-c",
          "or",
          "contains-items ubt-t",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true,
        "commands": ["select hqam-auto"]
      },
      {
        "name": "1.5 Gbit/s",
        "id": "ubt1-capacity-1.5gbit",
        "SI": "UBT1-CAPACITY-1.5GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-t",
          "or",
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "2 Gbit/s",
        "id": "ubt1-capacity-2gbit",
        "SI": "UBT1-CAPACITY-2GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-t",
          "or",
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "3 Gbit/s",
        "id": "ubt1-capacity-3gbit",
        "SI": "UBT1-CAPACITY-3GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "4 Gbit/s",
        "id": "ubt1-capacity-4gbit",
        "SI": "UBT1-CAPACITY-4GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true,
        "commands": ["select channel-spacing-500-mhz-auto"]
      },
      {
        "name": "5 Gbit/s",
        "id": "ubt1-capacity-5gbit",
        "SI": "UBT1-CAPACITY-5GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true,
        "commands": ["select channel-spacing-500-mhz-auto"]
      },
      {
        "name": "6 Gbit/s",
        "id": "ubt1-capacity-6gbit",
        "SI": "UBT1-CAPACITY-6GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true,
        "commands": ["select channel-spacing-500-mhz-auto"]
      },
      {
        "name": "10 Gbit/s",
        "id": "ubt1-capacity-10gbit",
        "SI": "UBT1-CAPACITY-10GBIT",
        "HTML_id": "tmpl-ubt1-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true,
        "commands": [
          "select channel-spacing-500-mhz-auto",
          "select hqam-e-band-auto"
        ]
      },


      {
        "name": "50 Mbit/s",
        "id": "ubt2-capacity-50mbit",
        "SI": "UBT2-CAPACITY-50MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "100 Mbit/s",
        "id": "ubt2-capacity-100mbit",
        "SI": "UBT2-CAPACITY-100MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "160 Mbit/s",
        "id": "ubt2-capacity-160mbit",
        "SI": "UBT2-CAPACITY-160MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "200 Mbit/s",
        "id": "ubt2-capacity-200mbit",
        "SI": "UBT2-CAPACITY-200MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "300 Mbit/s",
        "id": "ubt2-capacity-300mbit",
        "SI": "UBT2-CAPACITY-300MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-t show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "400 Mbit/s",
        "id": "ubt2-capacity-400mbit",
        "SI": "UBT2-CAPACITY-400MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-t show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "600 Mbit/s",
        "id": "ubt2-capacity-600mbit",
        "SI": "UBT2-CAPACITY-600MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-t show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "800 Mbit/s",
        "id": "ubt2-capacity-800mbit",
        "SI": "UBT2-CAPACITY-800MBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-t show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "1 Gbit/s",
        "id": "ubt2-capacity-1gbit",
        "description": "Automatically selects hqam",
        "SI": "UBT2-CAPACITY-1GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-s show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-t show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true,
        "commands": ["select hqam-auto"]
      },
      {
        "name": "1.5 Gbit/s",
        "id": "ubt2-capacity-1.5gbit",
        "SI": "UBT2-CAPACITY-1.5GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-t show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "2 Gbit/s",
        "id": "ubt2-capacity-2gbit",
        "SI": "UBT2-CAPACITY-2GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-t show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m show-2nd-ubt-capacity",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 10,
        "default": true,
        "commands": ["select hqam-auto"]
      },
      {
        "name": "3 Gbit/s",
        "id": "ubt2-capacity-3gbit",
        "SI": "UBT2-CAPACITY-3GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m show-2nd-ubt-capacity"
        ],
        "size": 10,
        "default": true
      },
      {
        "name": "4 Gbit/s",
        "id": "ubt2-capacity-4gbit",
        "SI": "UBT2-CAPACITY-4GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m show-2nd-ubt-capacity"
        ],
        "size": 10,
        "default": true,
        "commands": ["select channel-spacing-500-mhz-auto"]
      },
      {
        "name": "5 Gbit/s",
        "id": "ubt2-capacity-5gbit",
        "SI": "UBT2-CAPACITY-5GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m show-2nd-ubt-capacity"
        ],
        "size": 10,
        "default": true,
        "commands": ["select channel-spacing-500-mhz-auto"]
      },
      {
        "name": "6 Gbit/s",
        "id": "ubt2-capacity-6gbit",
        "SI": "UBT2-CAPACITY-6GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m show-2nd-ubt-capacity"
        ],
        "size": 10,
        "default": true,
        "commands": ["select channel-spacing-500-mhz-auto"]
      },
      {
        "name": "10 Gbit/s",
        "id": "ubt2-capacity-10gbit",
        "SI": "UBT2-CAPACITY-10GBIT",
        "HTML_id": "tmpl-ubt2-capacity",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m show-2nd-ubt-capacity"
        ],
        "size": 10,
        "default": true,
        "commands": [
          "select channel-spacing-500-mhz-auto",
          "select hqam-e-band-auto"
        ]
      },


      {
        "name": "6 GHz",
        "id": "frequency-6-ghz-tx1",
        "SI": "FREQUENCY-6GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "7 GHz",
        "id": "frequency-7-ghz-tx1",
        "SI": "FREQUENCY-7GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "8 GHz",
        "id": "frequency-8-ghz-tx1",
        "SI": "FREQUENCY-8GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "11 GHz",
        "id": "frequency-11-ghz-tx1",
        "SI": "FREQUENCY-11GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "13 GHz",
        "id": "frequency-13-ghz-tx1",
        "SI": "FREQUENCY-13GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "15 GHz",
        "id": "frequency-15-ghz-tx1",
        "SI": "FREQUENCY-15GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "18 GHz",
        "id": "frequency-18-ghz-tx1",
        "SI": "FREQUENCY-18GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "23 GHz",
        "id": "frequency-23-ghz-tx1",
        "SI": "FREQUENCY-23GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "26 GHz",
        "id": "frequency-26-ghz-tx1",
        "SI": "FREQUENCY-26GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "28 GHz",
        "id": "frequency-28-ghz-tx1",
        "SI": "FREQUENCY-28GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "32 GHz",
        "id": "frequency-32-ghz-tx1",
        "SI": "FREQUENCY-32GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "38 GHz",
        "id": "frequency-38-ghz-tx1",
        "SI": "FREQUENCY-38GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "42 GHz",
        "id": "frequency-42-ghz-tx1",
        "SI": "FREQUENCY-42GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "80 GHz",
        "id": "frequency-80-ghz-tx1",
        "SI": "FREQUENCY-80GHZ",
        "HTML_id": "tmpl-tx1-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },

      {
        "name": "266 MHz",
        "id": "shifter-266-mhz-tx1",
        "SI": "SHIFTER-266MHZ",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "315 MHz",
        "id": "shifter-315-mhz-tx1",
        "SI": "SHIFTER-315MHZ",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "322 MHz",
        "id": "shifter-322-mhz-tx1",
        "SI": "SHIFTER-322MHZ",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "420 MHz",
        "id": "shifter-420-mhz-tx1",
        "SI": "SHIFTER-420MHZ",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "490 MHz",
        "id": "shifter-490-mhz-tx1",
        "SI": "SHIFTER-490MHZ",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "644 MHz",
        "id": "shifter-644-mhz-tx1",
        "SI": "SHIFTER-644MHZ",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "728 MHz",
        "id": "shifter-728-mhz-tx1",
        "SI": "SHIFTER-728MHZ",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "10 GHz",
        "id": "shifter-10-ghz-tx1",
        "HTML_id": "tmpl-shifter-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items ubt-m",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "266 MHz",
        "description": "====== SHIFTER 2 LIST STARTS HERE ======",
        "id": "shifter-266-mhz-tx2",
        "SI": "SHIFTER-266MHZ",
        "HTML_id": "tmpl-shifter-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-13-ghz-tx1 show-2nd-shifter-subband-settings"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "315 MHz",
        "id": "shifter-315-mhz-tx2",
        "SI": "SHIFTER-315MHZ",
        "HTML_id": "tmpl-shifter-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-15-ghz-tx1 show-2nd-shifter-subband-settings"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "322 MHz",
        "id": "shifter-322-mhz-tx2",
        "SI": "SHIFTER-322MHZ",
        "HTML_id": "tmpl-shifter-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-15-ghz-tx1 show-2nd-shifter-subband-settings"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "420 MHz",
        "id": "shifter-420-mhz-tx2",
        "SI": "SHIFTER-420MHZ",
        "HTML_id": "tmpl-shifter-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-15-ghz-tx1 show-2nd-shifter-subband-settings"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "490 MHz",
        "id": "shifter-490-mhz-tx2",
        "SI": "SHIFTER-490MHZ",
        "HTML_id": "tmpl-shifter-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-15-ghz-tx1 show-2nd-shifter-subband-settings"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "644 MHz",
        "id": "shifter-644-mhz-tx2",
        "SI": "SHIFTER-644MHZ",
        "HTML_id": "tmpl-shifter-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-15-ghz-tx1 show-2nd-shifter-subband-settings"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "728 MHz",
        "id": "shifter-728-mhz-tx2",
        "SI": "SHIFTER-728MHZ",
        "HTML_id": "tmpl-shifter-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-15-ghz-tx1 show-2nd-shifter-subband-settings"
        ],
        "size": 1,
        "default": true
      },


      {
        "name": "SB1 12 751-12 863/13 017-13 129",
        "id": "13ghz-266mhz-subband1",
        "SI": "13GHZ-266MHZ-SUBBAND1",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx1 shifter-266-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 12 807-12 919/13 073-13 185",
        "id": "13ghz-266mhz-subband2",
        "SI": "13GHZ-266MHZ-SUBBAND2",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx1 shifter-266-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 12 863-12 975/13 129-13 241",
        "id": "13ghz-266mhz-subband3",
        "SI": "13GHZ-266MHZ-SUBBAND3",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx1 shifter-266-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 648-14 704/14 963-15 019",
        "id": "15ghz-315mhz-subband1",
        "SI": "15GHZ-315MHZ-SUBBAND1",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 704-14 760/15 019-15 075",
        "id": "15ghz-315mhz-subband2",
        "SI": "15GHZ-315MHZ-SUBBAND2",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 760-14 816/15 075-15 131",
        "id": "15ghz-315mhz-subband3",
        "SI": "15GHZ-315MHZ-SUBBAND3",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 816-14 872/15 131-15 187",
        "id": "15ghz-315mhz-subband4",
        "SI": "15GHZ-315MHZ-SUBBAND4",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 618-14 683/14 940-15 005",
        "id": "15ghz-322mhz-subband1",
        "SI": "15GHZ-322MHZ-SUBBAND1",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 674-14 739/14 996-15 061",
        "id": "15ghz-322mhz-subband2",
        "SI": "15GHZ-322MHZ-SUBBAND2",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 730-14 795/15 052-15-117",
        "id": "15ghz-322mhz-subband3",
        "SI": "15GHZ-322MHZ-SUBBAND3",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 786-14 851/15 108-15-173",
        "id": "15ghz-322mhz-subband4",
        "SI": "15GHZ-322MHZ-SUBBAND4",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB5 14 842-14 907/15 164-15-229",
        "id": "15ghz-322mhz-subband5",
        "SI": "15GHZ-322MHZ-SUBBAND5",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 501-14 647/14 921-15 067",
        "id": "15ghz-420mhz-subband1",
        "SI": "15GHZ-420MHZ-SUBBAND1",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 611-14 757/15 031-15 177",
        "id": "15ghz-420mhz-subband2",
        "SI": "15GHZ-420MHZ-SUBBAND2",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 706-14 852/15 126-15-272",
        "id": "15ghz-420mhz-subband3",
        "SI": "15GHZ-420MHZ-SUBBAND3",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 782-14 928/15 202-15-348",
        "id": "15ghz-420mhz-subband4",
        "SI": "15GHZ-420MHZ-SUBBAND4",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 403-14 655/14 893-15 145",
        "id": "15ghz-490mhz-subband1",
        "SI": "15GHZ-490MHZ-SUBBAND1",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-490-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 501-14 753/14 991-15 243",
        "id": "15ghz-490mhz-subband2",
        "SI": "15GHZ-490MHZ-SUBBAND2",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-490-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 599-14 851/15 089-15-341",
        "id": "15ghz-490mhz-subband3",
        "SI": "15GHZ-490MHZ-SUBBAND3",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-490-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 500-14 704/15 144-15 348",
        "id": "15ghz-644mhz-subband1",
        "SI": "15GHZ-644MHZ-SUBBAND1",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-644-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "14 500-14 620/15 228-15 348",
        "id": "15ghz-728mhz-subband3",
        "SI": "15GHZ-728MHZ-SUBBAND3",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-728-mhz-tx1"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 71 000-76 000/81 000-86 000",
        "id": "80ghz-10ghz-subband1",
        "HTML_id": "tmpl-subband-tx1",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-80-ghz-tx1"
        ],
        "size": 1,
        "default": true
      },


      {
        "name": "SB1 12 751-12 863/13 017-13 129",
        "id": "13ghz-266mhz-subband1-tx2",
        "SI": "13GHZ-266MHZ-SUBBAND1-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx1 shifter-266-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 12 807-12 919/13 073-13 185",
        "id": "13ghz-266mhz-subband2-tx2",
        "SI": "13GHZ-266MHZ-SUBBAND2-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx1 shifter-266-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 12 863-12 975/13 129-13 241",
        "id": "13ghz-266mhz-subband3-tx2",
        "SI": "13GHZ-266MHZ-SUBBAND3-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx1 shifter-266-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 648-14 704/14 963-15 019",
        "id": "15ghz-315mhz-subband1-tx2",
        "SI": "15GHZ-315MHZ-SUBBAND1-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 704-14 760/15 019-15 075",
        "id": "15ghz-315mhz-subband2-tx2",
        "SI": "15GHZ-315MHZ-SUBBAND2-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 760-14 816/15 075-15 131",
        "id": "15ghz-315mhz-subband3-tx2",
        "SI": "15GHZ-315MHZ-SUBBAND3-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 816-14 872/15 131-15 187",
        "id": "15ghz-315mhz-subband4-tx2",
        "SI": "15GHZ-315MHZ-SUBBAND4-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-315-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 618-14 683/14 940-15 005",
        "id": "15ghz-322mhz-subband1-tx2",
        "SI": "15GHZ-322MHZ-SUBBAND1-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 674-14 739/14 996-15 061",
        "id": "15ghz-322mhz-subband2-tx2",
        "SI": "15GHZ-322MHZ-SUBBAND2-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 730-14 795/15 052-15-117",
        "id": "15ghz-322mhz-subband3-tx2",
        "SI": "15GHZ-322MHZ-SUBBAND3-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 786-14 851/15 108-15-173",
        "id": "15ghz-322mhz-subband4-tx2",
        "SI": "15GHZ-322MHZ-SUBBAND4-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB5 14 842-14 907/15 164-15-229",
        "id": "15ghz-322mhz-subband5-tx2",
        "SI": "15GHZ-322MHZ-SUBBAND5-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-322-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 501-14 647/14 921-15 067",
        "id": "15ghz-420mhz-subband1-tx2",
        "SI": "15GHZ-420MHZ-SUBBAND1-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 611-14 757/15 031-15 177",
        "id": "15ghz-420mhz-subband2-tx2",
        "SI": "15GHZ-420MHZ-SUBBAND2-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 706-14 852/15 126-15-272",
        "id": "15ghz-420mhz-subband3-tx2",
        "SI": "15GHZ-420MHZ-SUBBAND3-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 782-14 928/15 202-15-348",
        "id": "15ghz-420mhz-subband4-tx2",
        "SI": "15GHZ-420MHZ-SUBBAND4-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-420-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 403-14 655/14 893-15 145",
        "id": "15ghz-490mhz-subband1-tx2",
        "SI": "15GHZ-490MHZ-SUBBAND1-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-490-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 501-14 753/14 991-15 243",
        "id": "15ghz-490mhz-subband2-tx2",
        "SI": "15GHZ-490MHZ-SUBBAND2-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-490-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 599-14 851/15 089-15-341",
        "id": "15ghz-490mhz-subband3-tx2",
        "SI": "15GHZ-490MHZ-SUBBAND3-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-490-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 500-14 704/15 144-15 348",
        "id": "15ghz-644mhz-subband1-tx2",
        "SI": "15GHZ-644MHZ-SUBBAND1-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-644-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "14 500-14 620/15 228-15 348",
        "id": "15ghz-728mhz-subband3-tx2",
        "SI": "15GHZ-728MHZ-SUBBAND3-tx2",
        "HTML_id": "tmpl-subband-tx2",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx1 shifter-728-mhz-tx2"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "low / high",
        "id": "subband-low-high",
        "SI": "SUBBANDLOWHIGH",
        "HTML_id": "tmpl-subband-station-selector",
        "UI_el": "radio",
        "alignment": "vertical",
        "constraints": [
          "contains-items ubt-c",
          "or",
          "contains-items ubt-m"
        ],
        "default": true
      },
      {
        "name": "high / low",
        "id": "subband-high-low",
        "SI": "SUBBANDHIGHLOW",
        "HTML_id": "tmpl-subband-station-selector",
        "UI_el": "radio",
        "alignment": "vertical",
        "constraints": [
          "contains-items ubt-c",
          "or",
          "contains-items ubt-m"
        ],
        "default": false
      },
      {
        "name": "hide subband-high-low",
        "id": "hide-subband-high-low",
        "HTML_id": "tmpl-subband-high-low-hide",
        "UI_el": "visibility",
        "constraints": [
          "contains-items ubt-c",
          "or",
          "contains-items ubt-m"
        ]
      },
      {
        "name": "integrated",
        "id": "antenna1-integrated",
        "SI": "ANTENNA1-INTEGRATED",
        "HTML_id": "tmpl-antenna1-integration",
        "UI_el": "dropdown",
        "constraints": [],
        "default": true,
        "size": 3
      },
      {
        "name": "Not integrated",
        "id": "antenna1-not-integrated",
        "SI": "ANTENNA1-NOT-INTEGRATED",
        "HTML_id": "tmpl-antenna1-integration",
        "UI_el": "dropdown",
        "constraints": [],
        "default": true,
        "size": 3
      },
      {
        "name": "No antenna",
        "id": "antenna1-no-antenna",
        "SI": "ANTENNA1-NO-ANTENNA",
        "HTML_id": "tmpl-antenna1-integration",
        "UI_el": "dropdown",
        "constraints": [],
        "default": true,
        "size": 3
      },
      {
        "name": "integrated",
        "id": "antenna2a-integrated",
        "SI": "ANTENNA2A-INTEGRATED",
        "HTML_id": "tmpl-antenna2a-integration",
        "UI_el": "dropdown",
        "constraints": [],
        "default": true,
        "size": 3
      },
      {
        "name": "Not integrated",
        "id": "antenna2a-not-integrated",
        "SI": "ANTENNA2A-NOT-INTEGRATED",
        "HTML_id": "tmpl-antenna2a-integration",
        "UI_el": "dropdown",
        "constraints": [],
        "default": true,
        "size": 3
      },
      {
        "name": "No antenna",
        "id": "antenna2a-no-antenna",
        "SI": "ANTENNA2A-NO-ANTENNA",
        "HTML_id": "tmpl-antenna2a-integration",
        "UI_el": "dropdown",
        "constraints": [],
        "default": true,
        "size": 3
      },
      {
        "name": "hide diameter station1",
        "id": "hide-diameter-station1",
        "HTML_id": "hide-diameter-station1",
        "UI_el": "visibility",
        "constraints": [
          "doesnt-contain-items antenna1-no-antenna"
        ]
      },
      {
        "name": "hide diameter station 2",
        "id": "hide-diameter-station-2",
        "HTML_id": "hide-diameter-station-2",
        "UI_el": "visibility",
        "constraints": [
          "doesnt-contain-items antenna2a-no-antenna"
        ]
      },
      {
        "name": "Antenna support",
        "id": "antenna-support",
        "SI": "OUTDOORSUPPORT",
        "HTML_id": "tmpl-antenna-support",
        "UI_el": "checkbox"
      },
      {
        "name": "Hide cables label",
        "id": "hide-cables-label",
        "HTML_id": "tmpl-cable-length-div1",
        "UI_el": "visibility",
        "constraints": [
          "contains-item outdoor-unit-cables-checkbox-longer",
          "or",
          "contains-item outdoor-unit-cables-checkbox-shorter"

        ]
      },
      {
        "name": "Hide cables label 2",
        "id": "hide-cables-label2",
        "HTML_id": "tmpl-cable-length-div2",
        "UI_el": "visibility",
        "constraints": [
          "contains-item outdoor-unit-cables-checkbox-shorter2",
          "or",
          "contains-item outdoor-unit-cables-checkbox-longer2"
        ]
      },
      {
        "name": "Outdoor unit cables",
        "description": "CHECKBOX -------------------",
        "id": "outdoor-unit-cables-checkbox-shorter",
        "SI": "OUTDOORUNITCABLES",
        "HTML_id": "tmpl-outdoor-unit-cables-checkbox",
        "UI_el": "checkbox",
        "commands": [
          "set-default-value outdoor-unit-cables-length-shorter"
        ],
        "constraints": [
          "contains-items ubt-t",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ]
      },
      {
        "name": "Outdoor unit cables",
        "description": "CHECKBOX -------------------",
        "id": "outdoor-unit-cables-checkbox-longer",
        "SI": "OUTDOORUNITCABLES",
        "HTML_id": "tmpl-outdoor-unit-cables-checkbox",
        "UI_el": "checkbox",
        "commands": [
          "set-default-value outdoor-unit-cables-length-longer",
          "select outdoor-unit-cables-length-longer"
        ],
        "constraints": [
          "doesnt-contain-items ubt-t ubt-m-and-ubt-t"
        ]
      },
      {
        "name": "Outdoor unit cables length",
        "id": "outdoor-unit-cables-length-shorter",
        "SI": "OUTDOORUNITCABLESLENGTH",
        "HTML_id": "tmpl-outdoor-unit-cables-length",
        "default_value": 50,
        "min_value": 1,
        "max_value": 270,
        "UI_el": "number",
        "constraints": [
          "contains-item outdoor-unit-cables-checkbox-shorter"
        ]
      },
      {
        "name": "Outdoor unit cables length",
        "id": "outdoor-unit-cables-length-longer",
        "SI": "OUTDOORUNITCABLESLENGTH",
        "HTML_id": "tmpl-outdoor-unit-cables-length",
        "default_value": 50,
        "min_value": 1,
        "max_value": 300,
        "UI_el": "number",
        "constraints": [
          "contains-item outdoor-unit-cables-checkbox-longer"
        ]
      },
      {
        "name": "Antenna support",
        "id": "antenna-support2",
        "SI": "OUTDOORSUPPORT2",
        "HTML_id": "tmpl-antenna-support2",
        "UI_el": "checkbox"
      },
      {
        "name": "Outdoor unit cables",
        "description": "CHECKBOX -------------------",
        "id": "outdoor-unit-cables-checkbox-shorter2",
        "SI": "OUTDOORUNITCABLES2",
        "HTML_id": "tmpl-outdoor-unit-cables-checkbox2",
        "UI_el": "checkbox",
        "commands": [
          "set-default-value outdoor-unit-cables-length-shorter2"
        ],
        "constraints": [
          "contains-items ubt-t",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ]
      },
      {
        "name": "Outdoor unit cables",
        "description": "CHECKBOX -------------------",
        "id": "outdoor-unit-cables-checkbox-longer2",
        "SI": "OUTDOORUNITCABLES2",
        "HTML_id": "tmpl-outdoor-unit-cables-checkbox2",
        "UI_el": "checkbox",
        "commands": [
          "set-default-value outdoor-unit-cables-length-longer2"
        ],
        "constraints": [
          "doesnt-contain-items ubt-t ubt-m-and-ubt-t"
        ]
      },
      {
        "name": "Outdoor unit cables length",
        "id": "outdoor-unit-cables-length-shorter2",
        "SI": "OUTDOORUNITCABLESLENGTH2",
        "HTML_id": "tmpl-outdoor-unit-cables-length2",
        "default_value": 50,
        "min_value": 1,
        "max_value": 270,
        "UI_el": "number",
        "constraints": [
          "contains-item outdoor-unit-cables-checkbox-shorter2"
        ]
      },
      {
        "name": "Outdoor unit cables length",
        "id": "outdoor-unit-cables-length-longer2",
        "SI": "OUTDOORUNITCABLESLENGTH2",
        "HTML_id": "tmpl-outdoor-unit-cables-length2",
        "default_value": 50,
        "min_value": 1,
        "max_value": 300,
        "UI_el": "number",
        "constraints": [
          "contains-item outdoor-unit-cables-checkbox-longer2"
        ]
      },
      {
        "name": "0.3 m / 1 ft",
        "id": "antenna1-0.3m",
        "SI": "ANTENNA1-0.3M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-6-ghz-tx1 frequency-7-ghz-tx1 frequency-8-ghz-tx1 frequency-10.5-ghz-tx1 frequency-11-ghz-tx1 antenna1-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "0.6 m / 2 ft",
        "id": "antenna1-0.6m",
        "SI": "ANTENNA1-0.6M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-6-ghz-tx1 antenna1-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "0.9 m / 3 ft",
        "id": "antenna1-0.9m",
        "SI": "ANTENNA1-0.9M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-28-ghz-tx1 frequency-32-ghz-tx1 frequency-38-ghz-tx1 frequency-42-ghz-tx1 frequency-80-ghz-tx1 antenna1-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "1.2 m / 4 ft",
        "id": "antenna1-1.2m",
        "SI": "ANTENNA1-1.2M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-28-ghz-tx1 frequency-32-ghz-tx1 frequency-38-ghz-tx1 frequency-42-ghz-tx1 frequency-80-ghz-tx1 antenna1-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "1.8 m / 6 ft",
        "id": "antenna1-1.8m",
        "SI": "ANTENNA1-1.8M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-26-ghz-tx1 frequency-28-ghz-tx1 frequency-32-ghz-tx1 frequency-38-ghz-tx1 frequency-42-ghz-tx1 frequency-80-ghz-tx1 antenna1-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "2.4 m",
        "id": "antenna1-2.4m",
        "SI": "ANTENNA1-2.4M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items antenna1-not-integrated frequency-6-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-7-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-8-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-11-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-13-ghz-tx1"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "3.0 m",
        "id": "antenna1-3.0m",
        "SI": "ANTENNA1-3.0M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items antenna1-not-integrated frequency-6-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-7-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-8-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-11-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-13-ghz-tx1"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "3.7 m",
        "id": "antenna1-3.7m",
        "SI": "ANTENNA1-3.7M",
        "HTML_id": "tmpl-antenna1-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items antenna1-not-integrated frequency-6-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-7-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-8-ghz-tx1",
          "or",
          "contains-items antenna1-not-integrated frequency-11-ghz-tx1"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "0.3 m / 1 ft",
        "id": "antenna2A-0.3m",
        "SI": "ANTENNA2A-0.3M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-6-ghz frequency-7-ghz frequency-8-ghz frequency-10.5-ghz frequency-11-ghz antenna2a-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "0.6 m / 2 ft",
        "id": "antenna2A-0.6m",
        "SI": "ANTENNA2A-0.6M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-6-ghz antenna2a-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "0.9 m / 3 ft",
        "id": "antenna2A-0.9m",
        "SI": "ANTENNA2A-0.9M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-28-ghz frequency-32-ghz frequency-38-ghz frequency-42-ghz frequency-80-ghz antenna2a-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "1.2 m / 4 ft",
        "id": "antenna2A-1.2m",
        "SI": "ANTENNA2A-1.2M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-28-ghz frequency-32-ghz frequency-38-ghz frequency-42-ghz frequency-80-ghz antenna2a-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "1.8 m / 6 ft",
        "id": "antenna2a-1.8m",
        "SI": "ANTENNA2a-1.8M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items frequency-26-ghz frequency-28-ghz frequency-32-ghz frequency-38-ghz frequency-42-ghz frequency-80-ghz antenna2a-no-antenna"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "2.4 m",
        "id": "antenna2A-2.4m",
        "SI": "ANTENNA2A-2.4M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items antenna2a-not-integrated frequency-6-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-7-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-8-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-11-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-13-ghz"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "3.0 m",
        "id": "antenna2A-3.0m",
        "SI": "ANTENNA2A-3.0M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items antenna2a-not-integrated frequency-6-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-7-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-8-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-11-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-13-ghz"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "3.7 m",
        "id": "antenna2A-3.7m",
        "SI": "ANTENNA2A-3.7M",
        "HTML_id": "tmpl-antenna2a-diameter",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items antenna2a-not-integrated frequency-6-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-7-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-8-ghz",
          "or",
          "contains-items antenna2a-not-integrated frequency-11-ghz"
        ],
        "default": true,
        "size": 1
      },
      {
        "name": "Show 2nd shifter & subband settings",
        "id": "show-2nd-shifter-subband-settings",
        "SI": "SHOW2ND",
        "HTML_id": "tmpl-show-2nd-transceiver-settings",
        "UI_el": "checkbox",
        "constraints": [
          "contains-items ubt-t"
        ]
      },
      {
        "name": "Show 2nd shifter & subband settings",
        "id": "show-2nd-shifter-subband-settings-div",
        "SI": "SHOW2ND",
        "HTML_id": "tmpl-show-2nd-transceiver-settings-div",
        "UI_el": "visibility",
        "constraints": [
          "contains-items show-2nd-shifter-subband-settings frequency-13-ghz-tx1 show-2nd-shifter-subband-settings"
        ]
      },
      {
        "name": "Show 2nd UBT frequency settings",
        "id": "show-2nd-ubt-frequency-settings",
        "HTML_id": "tmpl-show-2nd-ubt-frequency-settings",
        "UI_el": "checkbox",
        "constraints": [
          "contains-items ubt-s radio-configuration-2+0",
          "or",
          "contains-items ubt-t radio-configuration-3+0",
          "or",
          "contains-items ubt-t radio-configuration-4+0"
        ]
      },
      {
        "name": "Show 2nd UBT frequency settings SHOW/HIDE DIV BLOCK!",
        "description": "Controls visibility of the complete UBT 2 frequency settings DIV",
        "id": "ubt2-div-js",
        "HTML_id": "ubt2-div-js",
        "UI_el": "visibility",
        "constraints": [
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items show-2nd-ubt-frequency-settings-auto"
        ]
      },

      {
        "name": "6 GHz",
        "id": "frequency-6-ghz-tx3",
        "SI": "FREQUENCY-6GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "7 GHz",
        "id": "frequency-7-ghz-tx3",
        "SI": "FREQUENCY-7GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "8 GHz",
        "id": "frequency-8-ghz-tx3",
        "SI": "FREQUENCY-8GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "11 GHz",
        "id": "frequency-11-ghz-tx3",
        "SI": "FREQUENCY-11GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": false
      },
      {
        "name": "13 GHz",
        "id": "frequency-13-ghz-tx3",
        "SI": "FREQUENCY-13GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "15 GHz",
        "id": "frequency-15-ghz-tx3",
        "SI": "FREQUENCY-15GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "18 GHz",
        "id": "frequency-18-ghz-tx3",
        "SI": "FREQUENCY-18GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "23 GHz",
        "id": "frequency-23-ghz-tx3",
        "SI": "FREQUENCY-23GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "26 GHz",
        "id": "frequency-26-ghz-tx3",
        "SI": "FREQUENCY-26GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "28 GHz",
        "id": "frequency-28-ghz-tx3",
        "SI": "FREQUENCY-28GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "32 GHz",
        "id": "frequency-32-ghz-tx3",
        "SI": "FREQUENCY-32GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "38 GHz",
        "id": "frequency-38-ghz-tx3",
        "SI": "FREQUENCY-38GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "42 GHz",
        "id": "frequency-42-ghz-tx3",
        "SI": "FREQUENCY-42GHZ-TX3",
        "HTML_id": "tmpl-tx3-frequency",
        "UI_el": "dropdown",
        "constraints": [
          "doesnt-contain-items ubt-m",
          "and",
          "contains-items show-2nd-ubt-frequency-settings",
          "or",
          "contains-items ubt-m-and-ubt-s",
          "or",
          "contains-items ubt-m-and-ubt-t"
        ],
        "size": 13,
        "default": true
      },
      {
        "name": "266 MHz",
        "id": "shifter-266-mhz-tx3",
        "description": "====== SHIFTER 3 LIST STARTS HERE ======",
        "SI": "SHIFTER-266MHZ",
        "HTML_id": "tmpl-shifter-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "315 MHz",
        "id": "shifter-315-mhz-tx3",
        "SI": "SHIFTER-315MHZ",
        "HTML_id": "tmpl-shifter-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "322 MHz",
        "id": "shifter-322-mhz-tx3",
        "SI": "SHIFTER-322MHZ",
        "HTML_id": "tmpl-shifter-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "420 MHz",
        "id": "shifter-420-mhz-tx3",
        "SI": "SHIFTER-420MHZ",
        "HTML_id": "tmpl-shifter-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "490 MHz",
        "id": "shifter-490-mhz-tx3",
        "SI": "SHIFTER-490MHZ",
        "HTML_id": "tmpl-shifter-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "644 MHz",
        "id": "shifter-644-mhz-tx3",
        "SI": "SHIFTER-644MHZ",
        "HTML_id": "tmpl-shifter-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "728 MHz",
        "id": "shifter-728-mhz-tx3",
        "SI": "SHIFTER-728MHZ",
        "HTML_id": "tmpl-shifter-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3"
        ],
        "size": 1,
        "default": true
      },


      {
        "name": "SB1 12 751-12 863/13 017-13 129",
        "id": "13ghz-266mhz-subband1-tx3",
        "SI": "13GHZ-266MHZ-SUBBAND1-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3 shifter-266-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 12 807-12 919/13 073-13 185",
        "id": "13ghz-266mhz-subband2-tx3",
        "SI": "13GHZ-266MHZ-SUBBAND2-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3 shifter-266-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 12 863-12 975/13 129-13 241",
        "id": "13ghz-266mhz-subband3-tx3",
        "SI": "13GHZ-266MHZ-SUBBAND3-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3 shifter-266-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 648-14 704/14 963-15 019",
        "id": "15ghz-315mhz-subband1-tx3",
        "SI": "15GHZ-315MHZ-SUBBAND1-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 704-14 760/15 019-15 075",
        "id": "15ghz-315mhz-subband2-tx3",
        "SI": "15GHZ-315MHZ-SUBBAND2-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 760-14 816/15 075-15 131",
        "id": "15ghz-315mhz-subband3-tx3",
        "SI": "15GHZ-315MHZ-SUBBAND3-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 816-14 872/15 131-15 187",
        "id": "15ghz-315mhz-subband4-tx3",
        "SI": "15GHZ-315MHZ-SUBBAND4-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 618-14 683/14 940-15 005",
        "id": "15ghz-322mhz-subband1-tx3",
        "SI": "15GHZ-322MHZ-SUBBAND1-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 674-14 739/14 996-15 061",
        "id": "15ghz-322mhz-subband2-tx3",
        "SI": "15GHZ-322MHZ-SUBBAND2-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 730-14 795/15 052-15-117",
        "id": "15ghz-322mhz-subband3-tx3",
        "SI": "15GHZ-322MHZ-SUBBAND3-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 786-14 851/15 108-15-173",
        "id": "15ghz-322mhz-subband4-tx3",
        "SI": "15GHZ-322MHZ-SUBBAND4-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB5 14 842-14 907/15 164-15-229",
        "id": "15ghz-322mhz-subband5-tx3",
        "SI": "15GHZ-322MHZ-SUBBAND5-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 501-14 647/14 921-15 067",
        "id": "15ghz-420mhz-subband1-tx3",
        "SI": "15GHZ-420MHZ-SUBBAND1-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 611-14 757/15 031-15 177",
        "id": "15ghz-420mhz-subband2-tx3",
        "SI": "15GHZ-420MHZ-SUBBAND2-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 706-14 852/15 126-15-272",
        "id": "15ghz-420mhz-subband3-tx3",
        "SI": "15GHZ-420MHZ-SUBBAND3-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 782-14 928/15 202-15-348",
        "id": "15ghz-420mhz-subband4-tx3",
        "SI": "15GHZ-420MHZ-SUBBAND4-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 403-14 655/14 893-15 145",
        "id": "15ghz-490mhz-subband1-tx3",
        "SI": "15GHZ-490MHZ-SUBBAND1-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-490-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 501-14 753/14 991-15 243",
        "id": "15ghz-490mhz-subband2-tx3",
        "SI": "15GHZ-490MHZ-SUBBAND2-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-490-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 599-14 851/15 089-15-341",
        "id": "15ghz-490mhz-subband3-tx3",
        "SI": "15GHZ-490MHZ-SUBBAND3-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-490-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 500-14 704/15 144-15 348",
        "id": "15ghz-644mhz-subband1-tx3",
        "SI": "15GHZ-644MHZ-SUBBAND1-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-644-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "14 500-14 620/15 228-15 348",
        "id": "15ghz-728mhz-subband3-tx3",
        "SI": "15GHZ-728MHZ-SUBBAND3-tx3",
        "HTML_id": "tmpl-subband-tx3",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-728-mhz-tx3"
        ],
        "size": 1,
        "default": true
      },

      {
        "name": "266 MHz",
        "id": "shifter-266-mhz-tx4",
        "description": "====== SHIFTER 4 LIST STARTS HERE ======",
        "SI": "SHIFTER-266MHZ",
        "HTML_id": "tmpl-shifter-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3 ubt-t radio-configuration-3+0",
          "or",
          "contains-items frequency-13-ghz-tx3 ubt-t radio-configuration-4+0",
          "or",
          "contains-items frequency-13-ghz-tx3 ubt-m radio-configuration-3+0",
          "or",
          "contains-items frequency-13-ghz-tx3 ubt-m radio-configuration-4+0",
          "or",
          "contains-items frequency-13-ghz-tx3 ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "315 MHz",
        "id": "shifter-315-mhz-tx4",
        "SI": "SHIFTER-315MHZ",
        "HTML_id": "tmpl-shifter-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "322 MHz",
        "id": "shifter-322-mhz-tx4",
        "SI": "SHIFTER-322MHZ",
        "HTML_id": "tmpl-shifter-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "420 MHz",
        "id": "shifter-420-mhz-tx4",
        "SI": "SHIFTER-420MHZ",
        "HTML_id": "tmpl-shifter-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "490 MHz",
        "id": "shifter-490-mhz-tx4",
        "SI": "SHIFTER-490MHZ",
        "HTML_id": "tmpl-shifter-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "644 MHz",
        "id": "shifter-644-mhz-tx4",
        "SI": "SHIFTER-644MHZ",
        "HTML_id": "tmpl-shifter-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "728 MHz",
        "id": "shifter-728-mhz-tx4",
        "SI": "SHIFTER-728MHZ",
        "HTML_id": "tmpl-shifter-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-t radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-3+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m radio-configuration-4+0",
          "or",
          "contains-items frequency-15-ghz-tx3 ubt-m-and-ubt-t"
        ],
        "size": 1,
        "default": true
      },


      {
        "name": "SB1 12 751-12 863/13 017-13 129",
        "description": "======= SUBBAND TX 4 STARTS HERE =======",
        "id": "13ghz-266mhz-subband1-tx4",
        "SI": "13GHZ-266MHZ-SUBBAND1-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3 shifter-266-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 12 807-12 919/13 073-13 185",
        "id": "13ghz-266mhz-subband2-tx4",
        "SI": "13GHZ-266MHZ-SUBBAND2-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3 shifter-266-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 12 863-12 975/13 129-13 241",
        "id": "13ghz-266mhz-subband3-tx4",
        "SI": "13GHZ-266MHZ-SUBBAND3-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-13-ghz-tx3 shifter-266-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 648-14 704/14 963-15 019",
        "id": "15ghz-315mhz-subband1-tx4",
        "SI": "15GHZ-315MHZ-SUBBAND1-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 704-14 760/15 019-15 075",
        "id": "15ghz-315mhz-subband2-tx4",
        "SI": "15GHZ-315MHZ-SUBBAND2-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 760-14 816/15 075-15 131",
        "id": "15ghz-315mhz-subband3-tx4",
        "SI": "15GHZ-315MHZ-SUBBAND3-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 816-14 872/15 131-15 187",
        "id": "15ghz-315mhz-subband4-tx4",
        "SI": "15GHZ-315MHZ-SUBBAND4-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-315-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 618-14 683/14 940-15 005",
        "id": "15ghz-322mhz-subband1-tx4",
        "SI": "15GHZ-322MHZ-SUBBAND1-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 674-14 739/14 996-15 061",
        "id": "15ghz-322mhz-subband2-tx4",
        "SI": "15GHZ-322MHZ-SUBBAND2-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 730-14 795/15 052-15-117",
        "id": "15ghz-322mhz-subband3-tx4",
        "SI": "15GHZ-322MHZ-SUBBAND3-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 786-14 851/15 108-15-173",
        "id": "15ghz-322mhz-subband4-tx4",
        "SI": "15GHZ-322MHZ-SUBBAND4-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB5 14 842-14 907/15 164-15-229",
        "id": "15ghz-322mhz-subband5-tx4",
        "SI": "15GHZ-322MHZ-SUBBAND5-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-322-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 501-14 647/14 921-15 067",
        "id": "15ghz-420mhz-subband1-tx4",
        "SI": "15GHZ-420MHZ-SUBBAND1-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 611-14 757/15 031-15 177",
        "id": "15ghz-420mhz-subband2-tx4",
        "SI": "15GHZ-420MHZ-SUBBAND2-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 706-14 852/15 126-15-272",
        "id": "15ghz-420mhz-subband3-tx4",
        "SI": "15GHZ-420MHZ-SUBBAND3-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB4 14 782-14 928/15 202-15-348",
        "id": "15ghz-420mhz-subband4-tx4",
        "SI": "15GHZ-420MHZ-SUBBAND4-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-420-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 403-14 655/14 893-15 145",
        "id": "15ghz-490mhz-subband1-tx4",
        "SI": "15GHZ-490MHZ-SUBBAND1-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-490-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB2 14 501-14 753/14 991-15 243",
        "id": "15ghz-490mhz-subband2-tx4",
        "SI": "15GHZ-490MHZ-SUBBAND2-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-490-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB3 14 599-14 851/15 089-15-341",
        "id": "15ghz-490mhz-subband3-tx4",
        "SI": "15GHZ-490MHZ-SUBBAND3-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-490-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "SB1 14 500-14 704/15 144-15 348",
        "id": "15ghz-644mhz-subband1-tx4",
        "SI": "15GHZ-644MHZ-SUBBAND1-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-644-mhz-tx4"
        ],
        "size": 1,
        "default": true
      },
      {
        "name": "14 500-14 620/15 228-15 348",
        "id": "15ghz-728mhz-subband3-tx4",
        "SI": "15GHZ-728MHZ-SUBBAND3-tx4",
        "HTML_id": "tmpl-subband-tx4",
        "UI_el": "dropdown",
        "constraints": [
          "contains-items frequency-15-ghz-tx3 shifter-728-mhz-tx4"
        ],
        "size": 1,
        "default": true
      }
    ]
  };
  return JSON.stringify(etsiLink);
}
