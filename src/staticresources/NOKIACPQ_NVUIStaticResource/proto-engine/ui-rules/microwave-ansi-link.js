export const microwaveAnsiLink = () => {
  const ansiLink = {
    "name": "Microwave",
    "copyright-information": "Copyright Nokia 2020",
    "objects": [
    {
      "name": "UBT-S",
      "id": "ubt-s",
      "SI": "UBT-S",
      "HTML_id": "tmpl-ubt",
      "UI_el": "dropdown",
      "size": 6,
      "default": true,
      "commands": [
        "select outdoor-unit-cables-checkbox-longer",
        "select outdoor-unit-cables-checkbox-longer2",

        "set-value outdoor-unit-cables-length-longer 30",
        "set-min-value outdoor-unit-cables-length-longer 1",
        "set-max-value outdoor-unit-cables-length-longer 300",

        "set-value outdoor-unit-cables-length-longer2 30",
        "set-min-value outdoor-unit-cables-length-longer2 1",
        "set-max-value outdoor-unit-cables-length-longer2 300"
      ]
    },
    {
      "name": "UBT-T",
      "id": "ubt-t",
      "SI": "UBT-t",
      "HTML_id": "tmpl-ubt",
      "UI_el": "dropdown",
      "commands": [
        "select outdoor-unit-cables-checkbox-shorter",
        "select outdoor-unit-cables-checkbox-shorter2",

        "set-value outdoor-unit-cables-length-shorter 30",
        "set-min-value outdoor-unit-cables-length-shorter 1",
        "set-max-value outdoor-unit-cables-length-shorter 270",

        "set-value outdoor-unit-cables-length-shorter2 30",
        "set-min-value outdoor-unit-cables-length-shorter2 1",
        "set-max-value outdoor-unit-cables-length-shorter2 270"
      ],
      "commands_comment": "Commands are triggered (further in commands chain), so correct default/min/max TX/RX input values are set",
      "size": 6,
      "default": false
    },
    {
      "name": "UBT-m",
      "id": "ubt-m",
      "SI": "UBT-m",
      "HTML_id": "tmpl-ubt",
      "UI_el": "dropdown",
      "commands": [
        "select outdoor-unit-cables-checkbox-longer",
        "select outdoor-unit-cables-checkbox-longer2",

        "set-value outdoor-unit-cables-length-longer 30",
        "set-min-value outdoor-unit-cables-length-longer 1",
        "set-max-value outdoor-unit-cables-length-longer 300",

        "set-value outdoor-unit-cables-length-longer2 30",
        "set-min-value outdoor-unit-cables-length-longer2 1",
        "set-max-value outdoor-unit-cables-length-longer2 300"
      ],
      "size": 6,
      "default": false
    },
    {
      "name": "UBT-C",
      "id": "ubt-c",
      "SI": "UBT-c",
      "category": "ubt",
      "HTML_id": "tmpl-ubt",
      "UI_el": "dropdown",
      "commands": [
        "select outdoor-unit-cables-checkbox-longer",
        "select outdoor-unit-cables-checkbox-longer2",

        "set-value outdoor-unit-cables-length-longer 30",
        "set-min-value outdoor-unit-cables-length-longer 1",
        "set-max-value outdoor-unit-cables-length-longer 300",

        "set-value outdoor-unit-cables-length-longer2 30",
        "set-min-value outdoor-unit-cables-length-longer2 1",
        "set-max-value outdoor-unit-cables-length-longer2 300"
      ],
      "size": 6
    },
    {
      "name": "UBT-m + UBT-S",
      "id": "ubt-m-and-ubt-s",
      "SI": "ubt-m-and-ubt-s",
      "HTML_id": "tmpl-ubt",
      "UI_el": "dropdown",
      "constraints": [],
      "size": 6,
      "default": true,
      "commands": [
        "select carrier-aggregation-millimeterwave-microwave-auto",
        "select show-2nd-ubt-frequency-settings-auto",
        "trigger-commands-of-categories ubt1-frequency ubt2-frequency",

        "select outdoor-unit-cables-checkbox-longer",
        "select outdoor-unit-cables-checkbox-longer2",

        "set-value outdoor-unit-cables-length-longer 30",
        "set-min-value outdoor-unit-cables-length-longer 1",
        "set-max-value outdoor-unit-cables-length-longer 300",

        "set-value outdoor-unit-cables-length-longer2 30",
        "set-min-value outdoor-unit-cables-length-longer2 1",
        "set-max-value outdoor-unit-cables-length-longer2 300"
      ]
    },
    {
      "name": "UBT-m + UBT-T",
      "id": "ubt-m-and-ubt-t",
      "SI": "ubt-m-and-ubt-t",
      "HTML_id": "tmpl-ubt",
      "UI_el": "dropdown",
      "constraints": [],
      "size": 6,
      "default": true,
      "commands": [
        "select carrier-aggregation-millimeterwave-microwave-auto",
        "select show-2nd-ubt-frequency-settings-auto",
        "trigger-commands-of-categories ubt1-frequency ubt2-frequency",
        "select outdoor-unit-cables-checkbox-shorter",

        "select outdoor-unit-cables-checkbox-shorter",
        "select outdoor-unit-cables-checkbox-shorter2",

        "set-value outdoor-unit-cables-length-shorter 30",
        "set-min-value outdoor-unit-cables-length-shorter 1",
        "set-max-value outdoor-unit-cables-length-shorter 270",

        "set-value outdoor-unit-cables-length-shorter2 30",
        "set-min-value outdoor-unit-cables-length-shorter2 1",
        "set-max-value outdoor-unit-cables-length-shorter2 270"
      ]
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
      "commands": ["trigger-commands-of-categories ubt1-frequency ubt2-frequency"],
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
      "commands": ["trigger-commands-of-categories ubt1-frequency ubt2-frequency"],
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
      "commands": ["trigger-commands-of-categories ubt1-frequency ubt2-frequency"],
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
      "commands": ["trigger-commands-of-categories ubt1-frequency ubt2-frequency"],
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
      "commands": ["trigger-commands-of-categories ubt1-frequency ubt2-frequency"],
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
      "commands": ["trigger-commands-of-categories ubt1-frequency ubt2-frequency"],
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
      "name": "High modulation",
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
      "name": "High modulation",
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
        "and",
        "doesnt-contain-items ubt2-capacity-10gbit",

        "or",

        "contains-items ubt-m-and-ubt-t",
        "and",
        "doesnt-contain-items ubt1-capacity-10gbit",
        "and",
        "doesnt-contain-items ubt2-capacity-10gbit",

        "or",

        "contains-items ubt-m-and-ubt-s",
        "and",
        "doesnt-contain-items ubt1-capacity-10gbit",
        "and",
        "doesnt-contain-items ubt2-capacity-10gbit"
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
        "contains-items ubt-m-and-ubt-s ubt1-capacity-10gbit",
        "or",
        "contains-items ubt-m ubt2-capacity-10gbit",
        "or",
        "contains-items ubt-m-and-ubt-t ubt2-capacity-10gbit",
        "or",
        "contains-items ubt-m-and-ubt-s ubt2-capacity-10gbit"
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
        "contains-items ubt-m",
        "and",
        "doesnt-contain-tag activates-channel-spacing-500-mhz-auto",

        "or",

        "contains-items ubt-m-and-ubt-t",
        "and",
        "doesnt-contain-tag activates-channel-spacing-500-mhz-auto",

        "or",

        "contains-items ubt-m-and-ubt-s",
        "and",
        "doesnt-contain-tag activates-channel-spacing-500-mhz-auto"
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
        "contains-tag activates-channel-spacing-500-mhz-auto",

        "or",

        "contains-items ubt-m-and-ubt-t",
        "and",
        "contains-tag activates-channel-spacing-500-mhz-auto",

        "or",

        "contains-items ubt-m-and-ubt-s",
        "and",
        "contains-tag activates-channel-spacing-500-mhz-auto"
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
      "commands": ["select hqam-auto"],
      "size": 10,
      "default": true
    },
    {
      "name": "3 Gbit/s",
      "id": "ubt1-capacity-3gbit",
      "SI": "UBT1-CAPACITY-3GBIT",
      "HTML_id": "tmpl-ubt1-capacity",
      "tags": ["activates-channel-spacing-500-mhz-auto"],
      "UI_el": "dropdown",
      "constraints": [
        "contains-items ubt-m",
        "or",
        "contains-items ubt-m-and-ubt-s",
        "or",
        "contains-items ubt-m-and-ubt-t"
      ],
      "commands": ["select channel-spacing-500-mhz-auto"],
      "size": 10,
      "default": true
    },
    {
      "name": "4 Gbit/s",
      "id": "ubt1-capacity-4gbit",
      "SI": "UBT1-CAPACITY-4GBIT",
      "HTML_id": "tmpl-ubt1-capacity",
      "UI_el": "dropdown",
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "tags": ["activates-channel-spacing-500-mhz-auto"],
      "constraints": [
        "contains-items ubt-m show-2nd-ubt-capacity"
      ],
      "commands": ["select channel-spacing-500-mhz-auto"],
      "size": 10,
      "default": true
    },
    {
      "name": "4 Gbit/s",
      "id": "ubt2-capacity-4gbit",
      "SI": "UBT2-CAPACITY-4GBIT",
      "HTML_id": "tmpl-ubt2-capacity",
      "UI_el": "dropdown",
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "tags": ["activates-channel-spacing-500-mhz-auto"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
      "size": 13,
      "default": true,
      "constraints": [
        "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
      ],
      "commands": [
        "set-min-value frequency-station1-tx1 12700",
        "set-max-value frequency-station1-tx1 13150",
        "set-min-value frequency-station1-rx1 12700",
        "set-max-value frequency-station1-rx1 13150",
        "set-min-value frequency-station2-tx1 12700",
        "set-max-value frequency-station2-tx1 13150",
        "set-min-value frequency-station2-rx1 12700",
        "set-max-value frequency-station2-rx1 13150",
        "set-min-value frequency-station1-tx2 12700",
        "set-max-value frequency-station1-tx2 13150",
        "set-min-value frequency-station1-rx2 12700",
        "set-max-value frequency-station1-rx2 13150",
        "set-min-value frequency-station2-tx2 12700",
        "set-max-value frequency-station2-tx2 13150",
        "set-min-value frequency-station2-rx2 12700",
        "set-max-value frequency-station2-rx2 13150",
        "set-value frequency-station1-tx1 12750",
        "set-value frequency-station1-rx1 12975",
        "set-value frequency-station1-tx2 12750",
        "set-value frequency-station1-rx2 12975",
        "set-value frequency-station2-tx1 12975",
        "set-value frequency-station2-rx1 12750",
        "set-value frequency-station2-tx2 12975",
        "set-value frequency-station2-rx2 12750"
      ]
    },
    {
      "name": "15 GHz",
      "id": "frequency-15-ghz-tx1",
      "SI": "FREQUENCY-15GHZ",
      "HTML_id": "tmpl-tx1-frequency",
      "UI_el": "dropdown",
      "categories": ["ubt1-frequency"],
      "size": 13,
      "default": false,
      "constraints": [
        "doesnt-contain-items ubt-m ubt-m-and-ubt-s ubt-m-and-ubt-t"
      ],
      "commands": [
        "set-min-value frequency-station1-tx1 14500",
        "set-max-value frequency-station1-tx1 15350",
        "set-min-value frequency-station1-rx1 14500",
        "set-max-value frequency-station1-rx1 15350",
        "set-min-value frequency-station2-tx1 14500",
        "set-max-value frequency-station2-tx1 15350",
        "set-min-value frequency-station2-rx1 14500",
        "set-max-value frequency-station2-rx1 15350",
        "set-min-value frequency-station1-tx2 14500",
        "set-max-value frequency-station1-tx2 15350",
        "set-min-value frequency-station1-rx2 14500",
        "set-max-value frequency-station1-rx2 15350",
        "set-min-value frequency-station2-tx2 14500",
        "set-max-value frequency-station2-tx2 15350",
        "set-min-value frequency-station2-rx2 14500",
        "set-max-value frequency-station2-rx2 15350",
        "set-value frequency-station1-tx1 14580",
        "set-value frequency-station1-rx1 15055",
        "set-value frequency-station2-tx1 15055",
        "set-value frequency-station2-rx1 14580",
        "set-value frequency-station1-tx2 14580",
        "set-value frequency-station1-rx2 15055",
        "set-value frequency-station2-tx2 15055",
        "set-value frequency-station2-rx2 14580"
      ]
    },
    {
      "name": "18 GHz",
      "id": "frequency-18-ghz-tx1",
      "SI": "FREQUENCY-18GHZ",
      "HTML_id": "tmpl-tx1-frequency",
      "UI_el": "dropdown",
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
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
      "categories": ["ubt1-frequency"],
      "constraints": [
        "contains-items ubt-m",
        "or",
        "contains-items ubt-m-and-ubt-s",
        "or",
        "contains-items ubt-m-and-ubt-t"
      ],
      "commands": [
        "set-min-value frequency-station1-tx1 71000",
        "set-max-value frequency-station1-tx1 86000",
        "set-min-value frequency-station1-rx1 71000",
        "set-max-value frequency-station1-rx1 86000",
        "set-value frequency-station1-tx1 73500",
        "set-value frequency-station1-rx1 83500",
        "set-value frequency-station2-tx1 83500",
        "set-value frequency-station2-rx1 73500"
      ],
      "size": 13,
      "default": true
    },

    {
      "name": "10 MHz",
      "id": "bandwidth-ubt1-10-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "20 MHz",
      "id": "bandwidth-ubt1-20-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "30 MHz",
      "id": "bandwidth-ubt1-30-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "40 MHz",
      "id": "bandwidth-ubt1-40-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "50 MHz",
      "id": "bandwidth-ubt1-50-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "10 MHz",
      "id": "bandwidth-ubt2-10-mhz",
      "HTML_id": "tmpl-bandwidth-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items frequency-80-ghz-tx1",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ]
    },
    {
      "name": "20 MHz",
      "id": "bandwidth-ubt2-20-mhz",
      "HTML_id": "tmpl-bandwidth-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items frequency-80-ghz-tx1",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ]
    },
    {
      "name": "30 MHz",
      "id": "bandwidth-ubt2-30-mhz",
      "HTML_id": "tmpl-bandwidth-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items frequency-80-ghz-tx1",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ]
    },
    {
      "name": "40 MHz",
      "id": "bandwidth-ubt2-40-mhz",
      "HTML_id": "tmpl-bandwidth-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items frequency-80-ghz-tx1",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ]
    },
    {
      "name": "50 MHz",
      "id": "bandwidth-ubt2-50-mhz",
      "HTML_id": "tmpl-bandwidth-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items frequency-80-ghz-tx1",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ]
    },
    {
      "name": "62,5 MHz",
      "id": "bandwidth-ubt2-62-5-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "125 MHz",
      "id": "bandwidth-ubt2-125-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "250 MHz",
      "id": "bandwidth-ubt2-250-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "500 MHz",
      "id": "bandwidth-ubt2-500-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "750 MHz",
      "id": "bandwidth-ubt2-750-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "1000 MHz",
      "id": "bandwidth-ubt2-1000-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "1250 MHz",
      "id": "bandwidth-ubt2-1250-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "1500 MHz",
      "id": "bandwidth-ubt2-1500-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "2000 MHz",
      "id": "bandwidth-ubt2-2000-mhz",
      "HTML_id": "tmpl-bandwidth-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "contains-items frequency-80-ghz-tx1"
      ]
    },


    {
      "name": "16 QAM",
      "id": "modulation-16-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true
    },
    {
      "name": "32 QAM",
      "id": "modulation-32-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true
    },
    {
      "name": "64 QAM",
      "id": "modulation-64-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true
    },
    {
      "name": "128 QAM",
      "id": "modulation-128-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true
    },
    {
      "name": "256 QAM",
      "id": "modulation-256-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true
    },
    {
      "name": "512 QAM",
      "id": "modulation-512-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "1024 QAM",
      "id": "modulation-1024-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "2048 QAM",
      "id": "modulation-2048-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },
    {
      "name": "4096 QAM",
      "id": "modulation-4096-qam-ubt1",
      "HTML_id": "tmpl-modulation-ubt1",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1"
      ]
    },

    {
      "name": "16 QAM",
      "id": "modulation-16-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "32 QAM",
      "id": "modulation-32-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "64 QAM",
      "id": "modulation-64-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "128 QAM",
      "id": "modulation-128-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "256 QAM",
      "id": "modulation-256-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "512 QAM",
      "id": "modulation-512-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "1024 QAM",
      "id": "modulation-1024-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "2048 QAM",
      "id": "modulation-2048-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
      ]
    },
    {
      "name": "4096 QAM",
      "id": "modulation-4096-qam-ubt2",
      "HTML_id": "tmpl-modulation-ubt2",
      "UI_el": "dropdown",
      "size": 10,
      "default": true,
      "constraints": [
        "doesnt-contain-items frequency-80-ghz-tx1",
        "and",
        "contains-items show-2nd-ubt-frequency-settings"
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
      "name": "Antenna support",
      "id": "antenna-support",
      "SI": "OUTDOORSUPPORT",
      "HTML_id": "tmpl-antenna-support",
      "UI_el": "checkbox"
    },
    {
      "name": "Antenna support",
      "id": "antenna-support2",
      "SI": "OUTDOORSUPPORT2",
      "HTML_id": "tmpl-antenna-support2",
      "UI_el": "checkbox"
    },
    {
      "name": "hide diameter antena1",
      "id": "hide-diameter-antena-1",
      "HTML_id": "hide-diameter-antena-1",
      "UI_el": "visibility",
      "constraints": [
        "doesnt-contain-items antenna1-no-antenna"
      ]
    },
    {
      "name": "hide diameter antena 2",
      "id": "hide-diameter-antena-2",
      "HTML_id": "hide-diameter-antena-2",
      "UI_el": "visibility",
      "constraints": [
        "doesnt-contain-items antenna2a-no-antenna"
      ]
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
      "description": "CHECKBOX CABLE 1 SHORT-------------------",
      "id": "outdoor-unit-cables-checkbox-shorter",
      "SI": "OUTDOORUNITCABLES",
      "HTML_id": "tmpl-outdoor-unit-cables-checkbox",
      "UI_el": "checkbox",
      "commands": [
        "set-value outdoor-unit-cables-length-shorter 30",
        "set-min-value outdoor-unit-cables-length-shorter 1",
        "set-max-value outdoor-unit-cables-length-shorter 270"
      ],
      "constraints": [
        "contains-items ubt-t",
        "or",
        "contains-items ubt-m-and-ubt-t"
      ]
    },
    {
      "name": "Outdoor unit cables",
      "description": "CHECKBOX CABLE 1 LONG -------------------",
      "id": "outdoor-unit-cables-checkbox-longer",
      "SI": "OUTDOORUNITCABLES",
      "HTML_id": "tmpl-outdoor-unit-cables-checkbox",
      "UI_el": "checkbox",
      "commands": [
        "set-value outdoor-unit-cables-length-longer 30",
        "set-min-value outdoor-unit-cables-length-longer 1",
        "set-max-value outdoor-unit-cables-length-longer 300"
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
      "UI_el": "number",
      "constraints": [
        "contains-item outdoor-unit-cables-checkbox-longer"
      ]
    },


    {
      "name": "Outdoor unit cables",
      "description": "CHECKBOX CABLE 2 SHORT-------------------",
      "id": "outdoor-unit-cables-checkbox-shorter2",
      "SI": "OUTDOORUNITCABLES",
      "HTML_id": "tmpl-outdoor-unit-cables-checkbox2",
      "UI_el": "checkbox",
      "commands": [
        "set-value outdoor-unit-cables-length-shorter2 30",
        "set-min-value outdoor-unit-cables-length-shorter2 1",
        "set-max-value outdoor-unit-cables-length-shorter2 270"
      ],
      "constraints": [
        "contains-items ubt-t",
        "or",
        "contains-items ubt-m-and-ubt-t"
      ]
    },
    {
      "name": "Outdoor unit cables",
      "description": "CHECKBOX CABLE 2 LONG -------------------",
      "id": "outdoor-unit-cables-checkbox-longer2",
      "SI": "OUTDOORUNITCABLES",
      "HTML_id": "tmpl-outdoor-unit-cables-checkbox2",
      "UI_el": "checkbox",
      "commands": [
        "set-value outdoor-unit-cables-length-longer2 30",
        "set-min-value outdoor-unit-cables-length-longer2 1",
        "set-max-value outdoor-unit-cables-length-longer2 300"
      ],
      "constraints": [
        "doesnt-contain-items ubt-t ubt-m-and-ubt-t"
      ]
    },
    {
      "name": "Outdoor unit cables length",
      "id": "outdoor-unit-cables-length-shorter2",
      "SI": "OUTDOORUNITCABLESLENGTH",
      "HTML_id": "tmpl-outdoor-unit-cables-length2",
      "UI_el": "number",
      "constraints": [
        "contains-item outdoor-unit-cables-checkbox-shorter2"
      ]
    },
    {
      "name": "Outdoor unit cables length",
      "id": "outdoor-unit-cables-length-longer2",
      "SI": "OUTDOORUNITCABLESLENGTH",
      "HTML_id": "tmpl-outdoor-unit-cables-length2",
      "UI_el": "number",
      "constraints": [
        "contains-item outdoor-unit-cables-checkbox-longer2"
      ]
    },




    {
      "name": "0.3 m / 1ft",
      "id": "antenna1-0.3m",
      "SI": "ANTENNA1-0.3M",
      "HTML_id": "tmpl-antenna1-diameter",
      "UI_el": "dropdown",
      "constraints": [
        "doesnt-contain-items frequency-6-ghz-tx1- frequency-7-ghz-tx1 frequency-8-ghz-tx1 frequency-10.5-ghz-tx1 frequency-11-ghz-tx1 antenna1-no-antenna"
      ],
      "default": true,
      "size": 1
    },
    {
      "name": "0.6 m / 2ft",
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
      "name": "0.9 m / 3ft",
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
      "name": "1.2 m / 4ft",
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
      "name": "1.8 m / 6ft",
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
      "name": "2.4 m / 8ft",
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
      "name": "3.0 m / 10ft",
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
      "name": "3.7 m / 12ft",
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
      "name": "0.3 m / 1ft",
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
      "name": "0.6 m / 2ft",
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
      "name": "0.9 m / 3ft",
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
      "name": "1.2 m / 4ft",
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
      "name": "1.8 m / 6ft",
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
      "name": "2.4 m / 8ft",
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
      "name": "3.0 m / 10ft",
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
      "name": "3.7 m / 12ft",
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
      "name": "Show 2nd UBT frequency settings",
      "id": "show-2nd-ubt-frequency-settings",
      "HTML_id": "tmpl-show-2nd-ubt-frequency-settings",
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
      "commands" : ["trigger-commands-of-categories ubt2-frequency"]
    },
    {
      "name": "Show 2nd UBT frequency settings",
      "id": "show-2nd-ubt-frequency-settings-auto",
      "HTML_id": "tmpl-show-2nd-ubt-frequency-settings",
      "UI_el": "checkbox",
      "constraints": [
        "contains-items ubt-m-and-ubt-s",
        "or",
        "contains-items ubt-m-and-ubt-t"
      ],
      "commands" : ["trigger-commands-of-categories ubt2-frequency"],
      "disabled": true
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
      "constraints": [
        "doesnt-contain-items ubt-m",
        "and",
        "contains-items show-2nd-ubt-frequency-settings",
        "or",
        "contains-items ubt-m-and-ubt-s",
        "or",
        "contains-items ubt-m-and-ubt-t"
      ],
      "commands": [
        "set-min-value frequency-station1-tx3 12700",
        "set-max-value frequency-station1-tx3 13150",
        "set-min-value frequency-station1-rx3 12700",
        "set-max-value frequency-station1-rx3 13150",
        "set-min-value frequency-station1-tx4 12700",
        "set-max-value frequency-station1-tx4 13150",
        "set-min-value frequency-station1-rx4 12700",
        "set-max-value frequency-station1-rx4 13150",
        "set-value frequency-station1-tx3 12750",
        "set-value frequency-station1-rx3 12975",
        "set-value frequency-station1-tx4 12750",
        "set-value frequency-station1-rx4 12975",
        "set-value frequency-station2-tx3 12975",
        "set-value frequency-station2-rx3 12750",
        "set-value frequency-station2-tx4 12975",
        "set-value frequency-station2-rx4 12750"
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
      "categories": ["ubt2-frequency"],
      "size": 13,
      "default": false,
      "constraints": [
        "doesnt-contain-items ubt-m",
        "and",
        "contains-items show-2nd-ubt-frequency-settings",
        "or",
        "contains-items ubt-m-and-ubt-s",
        "or",
        "contains-items ubt-m-and-ubt-t"
      ],
      "commands": [
        "set-min-value frequency-station1-tx3 14500",
        "set-max-value frequency-station1-tx3 15350",
        "set-min-value frequency-station1-rx3 14500",
        "set-max-value frequency-station1-rx3 15350",
        "set-min-value frequency-station1-tx4 14500",
        "set-max-value frequency-station1-tx4 15350",
        "set-min-value frequency-station1-rx4 14500",
        "set-max-value frequency-station1-rx4 15350",
        "set-value frequency-station1-tx3 14580",
        "set-value frequency-station1-rx3 15055",
        "set-value frequency-station1-tx4 14580",
        "set-value frequency-station1-rx4 15055",
        "set-value frequency-station2-tx3 15055",
        "set-value frequency-station2-rx3 14580",
        "set-value frequency-station2-tx4 15055",
        "set-value frequency-station2-rx4 14580"
      ]

    },
    {
      "name": "18 GHz",
      "id": "frequency-18-ghz-tx3",
      "SI": "FREQUENCY-18GHZ-TX3",
      "HTML_id": "tmpl-tx3-frequency",
      "UI_el": "dropdown",
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "categories": ["ubt2-frequency"],
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
      "name": "80 GHz",
      "id": "frequency-80-ghz-tx3",
      "SI": "FREQUENCY-80GHZ",
      "HTML_id": "tmpl-tx3-frequency",
      "UI_el": "dropdown",
      "categories": ["ubt1-frequency"],
      "constraints": [
        "contains-items ubt-m radio-configuration-2+0 show-2nd-ubt-frequency-settings"
      ],
      "commands": [
        "set-min-value frequency-station1-tx3 71000",
        "set-max-value frequency-station1-tx3 86000",
        "set-min-value frequency-station1-rx3 71000",
        "set-max-value frequency-station1-rx3 86000",
        "set-value frequency-station1-tx3 73500",
        "set-value frequency-station1-rx3 83500",
        "set-value frequency-station2-tx3 83500",
        "set-value frequency-station2-rx3 73500"
      ],
      "size": 13,
      "default": true
    },
    {
      "name": "Frequency Station 1 TX1",
      "id": "frequency-station1-tx1",
      "HTML_id": "tmpl-frequency-station1-tx1",
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "UI_el": "number",
      "commands": [
        "copy-my-value-to-id frequency-station2-rx1"
      ]
    },
    {
      "name": "Frequency Station 2 RX1",
      "id": "frequency-station2-rx1",
      "HTML_id": "tmpl-frequency-station2-rx1",
      "UI_el": "number",
      "disabled": true
    },
    {
      "name": "Frequency Station 1 RX1",
      "id": "frequency-station1-rx1",
      "HTML_id": "tmpl-frequency-station1-rx1",
      "UI_el": "number",
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "commands": [
        "copy-my-value-to-id frequency-station2-tx1"
      ]
    },
    {
      "name": "Frequency Station 2 TX1",
      "id": "frequency-station2-tx1",
      "HTML_id": "tmpl-frequency-station2-tx1",
      "UI_el": "number",
      "disabled": true
    },
    {
      "name": "Frequency Station 1 TX2",
      "id": "frequency-station1-tx2",
      "HTML_id": "tmpl-frequency-station1-tx2",
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "UI_el": "number",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ],
      "commands": [
        "copy-my-value-to-id frequency-station2-rx2"
      ]
    },
    {
      "name": "Frequency Station 2 RX2",
      "id": "frequency-station2-rx2",
      "HTML_id": "tmpl-frequency-station2-rx2",
      "UI_el": "number",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ],
      "disabled": true
    },
    {
      "name": "Frequency Station 1 RX2",
      "id": "frequency-station1-rx2",
      "HTML_id": "tmpl-frequency-station1-rx2",
      "UI_el": "number",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ],
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "commands": [
        "copy-my-value-to-id frequency-station2-tx2"
      ]
    },
    {
      "name": "Frequency Station 2 TX2",
      "id": "frequency-station2-tx2",
      "HTML_id": "tmpl-frequency-station2-tx2",
      "UI_el": "number",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ],
      "disabled": true
    },
    {
      "name": "Show transmition/receive inputs",
      "description": "Controls visibility of TX2/RX2 and TX4/RX4",
      "id": "tx-rx-control",
      "HTML_id": "tx-rx-control",
      "UI_el": "visibility",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ]
    },
    {
      "name": "Show transmition/receive inputs",
      "description": "Controls visibility of TX2/RX2 and TX4/RX4",
      "id": "tx-rx-control2",
      "HTML_id": "tx-rx-control2",
      "UI_el": "visibility",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ]
    },
    {
      "name": "Show transmition/receive inputs",
      "description": "Controls visibility of TX2/RX2 and TX4/RX4",
      "id": "tx-rx-control3",
      "HTML_id": "tx-rx-control3",
      "UI_el": "visibility",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ]
    },
    {
      "name": "Show transmition/receive inputs",
      "description": "Controls visibility of TX2/RX2 and TX4/RX4",
      "id": "tx-rx-control4",
      "HTML_id": "tx-rx-control4",
      "UI_el": "visibility",
      "constraints": [
        "contains-items ubt-t radio-configuration-1+0",
        "or",
        "contains-items ubt-t radio-configuration-2+0",
        "or",
        "contains-items ubt-t radio-configuration-2+2-hsb",
        "or",
        "contains-items ubt-t radio-configuration-3+0",
        "or",
        "contains-items ubt-t radio-configuration-4+0"
      ]
    },
    {
      "name": "Frequency Station 1 TX3",
      "id": "frequency-station1-tx3",
      "HTML_id": "tmpl-frequency-station1-tx3",
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "UI_el": "number",
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ],
      "commands": [
        "copy-my-value-to-id frequency-station2-rx3"
      ]
    },
    {
      "name": "Frequency Station 2 RX3",
      "id": "frequency-station2-rx3",
      "HTML_id": "tmpl-frequency-station2-rx3",
      "UI_el": "number",
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ],
      "disabled": true
    },
    {
      "name": "Frequency Station 1 RX3",
      "id": "frequency-station1-rx3",
      "HTML_id": "tmpl-frequency-station1-rx3",
      "UI_el": "number",
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ],
      "commands": [
        "copy-my-value-to-id frequency-station2-tx3"
      ]
    },
    {
      "name": "Frequency Station 2 TX3",
      "id": "frequency-station2-tx3",
      "HTML_id": "tmpl-frequency-station2-tx3",
      "UI_el": "number",
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "or",
        "contains-items show-2nd-ubt-frequency-settings-auto"
      ],
      "disabled": true
    },
    {
      "name": "Frequency Station 1 TX4",
      "id": "frequency-station1-tx4",
      "HTML_id": "tmpl-frequency-station1-tx4",
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "UI_el": "number",
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items ubt-s ubt-m"
      ],
      "commands": [
        "copy-my-value-to-id frequency-station2-rx4"
      ]
    },
    {
      "name": "Frequency Station 2 RX4",
      "id": "frequency-station2-rx4",
      "HTML_id": "tmpl-frequency-station2-rx4",
      "UI_el": "number",
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items ubt-s ubt-m"
      ],
      "disabled": true
    },
    {
      "name": "Frequency Station 1 RX4",
      "id": "frequency-station1-rx4",
      "HTML_id": "tmpl-frequency-station1-rx4",
      "UI_el": "number",
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items ubt-s ubt-m"
      ],
      "default_value": 15000,
      "min_value": 1,
      "max_value": 30270,
      "commands": [
        "copy-my-value-to-id frequency-station2-tx4"
      ]
    },
    {
      "name": "Frequency Station 2 TX4",
      "id": "frequency-station2-tx4",
      "HTML_id": "tmpl-frequency-station2-tx4",
      "UI_el": "number",
      "constraints": [
        "contains-items show-2nd-ubt-frequency-settings",
        "and",
        "doesnt-contain-items ubt-s ubt-m"
      ],
      "disabled": true
    }


  ]
  };
  return JSON.stringify(ansiLink);
}
