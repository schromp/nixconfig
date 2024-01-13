import App from 'resource:///com/github/Aylur/ags/app.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';

import { Bar } from "./js/bar.js";
import Settings from './js/settings/settings.js';
import { Soundboard } from './js/soundboard/soundboard.js';

const scss = App.configDir + "/scss/main.scss";
const css = App.configDir + "/style.css";

console.log("Starting AGS!")

let ret = Utils.exec(`sassc ${scss} ${css}`);

export default {
  style: css,
  windows: [Bar, Settings(), Soundboard]
}
