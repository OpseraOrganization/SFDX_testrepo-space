import { c as controllers } from './index.js';
export { B as BarController, a as BubbleController, D as DoughnutController, L as LineController, b as PieController, P as PolarAreaController, R as RadarController, S as ScatterController, c as controllers } from './index.js';
export { S as Scale, T as Ticks, a as _adapters } from './coreScale.js';
export { A as Animation, a as Animations, b as animator } from './coreAnimations.js';
export { C as Chart, I as Interaction, r as registry } from './coreController.js';
export { D as DatasetController } from './coreDatasetController.js';
export { d as defaults } from './helpersDom.js';
export { E as Element } from './coreElement.js';
export { l as layouts } from './coreLayouts.js';
import { e as elements } from './index2.js';
export { A as ArcElement, B as BarElement, P as PointElement, e as elements } from './index2.js';
export { BasePlatform, BasicPlatform, DomPlatform, _detectPlatform } from './platform.js';
import { p as plugins } from './index3.js';
export { a as Decimation, b as Filler, c as Legend, d as SubTitle, e as Title, f as Tooltip, p as plugins } from './index3.js';
import { s as scales } from './index4.js';
export { C as CategoryScale, L as LinearScale, a as LogarithmicScale, R as RadialLinearScale, T as TimeScale, b as TimeSeriesScale, s as scales } from './index4.js';
export { L as LineElement } from './elementLine.js';
import './helpersCollection.js';
import './helpersIntl.js';
import './helpersOptions.js';
import './helpersExtras.js';
import './helpersEasing.js';
import './helpersConfig.js';
import './helpersSegment.js';
import './helpersRtl.js';

const registerables = [
  controllers,
  elements,
  plugins,
  scales,
];

export { registerables };