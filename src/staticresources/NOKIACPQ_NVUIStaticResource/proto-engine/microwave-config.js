import { etsiStation } from './html-templates/etsi-station'
import { etsiLink } from './html-templates/etsi-link'
import { ansiStation } from './html-templates/ansi-station'
import { ansiLink } from "./html-templates/ansi-link";
import { microwaveBothRegionsStation } from "./ui-rules/microwave-both-regions-station";
import { microwaveEtsiLink } from "./ui-rules/microwave-etsi-link";
import { microwaveAnsiLink } from "./ui-rules/microwave-ansi-link";
export default {
  regions: {
    "ETSI": {
      "region": "Europe",
      "station-ui-model-file": '',
      "station-ui-template-file": '',
      "link-ui-model-file": '',
      "link-ui-template-file": '',
      "si_ci_list_filtering_options": [
        "Commercial Items",
        "Sales Items",
        "Commercial Items & Sales Items",
      ]
    },
    "ANSI": {
      "region": "USA",
      "station-ui-model-file": microwaveBothRegionsStation(),
      "station-ui-template-file": ansiStation(),
      "link-ui-model-file": microwaveAnsiLink(),
      "link-ui-template-file": ansiLink(),
      "si_ci_list_filtering_options": [
        "Sales Items"
      ]
    }
  }
}
