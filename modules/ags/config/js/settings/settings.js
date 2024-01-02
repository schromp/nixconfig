import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

import PowerButtonRow from "./info/PowerButtons.js";
import { Microphone } from "./info/Sounds.js";

const Sound = Widget.Box({
  className: "sound",
  vertical: true,
  children: [Widget.Label("Sound")],
});

const Info = Widget.Box({
  className: "info",
  vertical: true,
  children: [Microphone, Widget.Label("text"), PowerButtonRow],
});

const SettingsContainer = Widget.Box({
  className: "settings-container",
  children: [
    Widget.Stack({
      items: [
        ["sound", Widget.Label("sound")],
        ["bluetooth", Widget.Label("bluetooth")],
        ["info", Info],
      ],
      shown: "info",
    }),
  ],
});

const Settings = () =>
  Widget.Window({
    name: "Settings",
    className: "settings",
    anchor: ["left", "bottom"],
    visible: false,
    popup: true,
    focusable: true,
    // layer: 'overlay',
    // exclusivity: 'normal',
    monitor: 0,
    child: SettingsContainer,
  });

export default Settings;
