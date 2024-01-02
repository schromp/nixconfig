import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

const WorkspaceButton = (i) => Widget.Button({
  on_primary_click_release: () => Hyprland.sendMessage(`dispatch workspace ${i}`),
  connections: [
    [Hyprland.active.workspace, (button) => {
      button.toggleClassName('active', Hyprland.active.workspace.id === i)
    }]
  ]
})

const Workspaces = Widget.Box({
  className: 'workspaces',
  vertical: true,
  children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => WorkspaceButton(i)),
  connections: [
    [Hyprland, (box) => {
      box.children.forEach((button, i) => {
        const ws = Hyprland.getWorkspace(i + 1) // +1 due to indexing
        button.toggleClassName("occupied", ws?.windows > 0)
      })
    }, 'notify::workspaces']
  ]
});

const SysTrayItem = item => Widget.Button({
  className: 'tray-item',
  child: Widget.Icon({
    binds: [['icon', item, 'icon']],
  }),
  binds: [['tooltip-markup', item, 'tooltip-markup']],
  onPrimaryClick: (_, event) => item.activate(event),
  onSecondaryClick: (_, event) => item.openMenu(event),
});

const sysTray = Widget.Box({
  className: 'tray',
  vertical: true,
  hpack: 'center',
  vpack: 'center',
  binds: [['children', SystemTray, 'items', i => i.map(SysTrayItem)]],
});

const ClockHour = Widget.Label({ label: '00' });
const ClockMinute = Widget.Label({ label: '00' });

const Clock = Widget.Box({
  vertical: true,
  className: 'clock',
  children: [
    ClockHour,
    ClockMinute,
  ],
  connections: [[5000, _ => {
    Utils.execAsync([`date`, "+%H%M"]).then(timeString => {
      ClockHour.label = timeString.slice(0, 2);
      ClockMinute.label = timeString.slice(2, 5);
    }).catch(print);
  }]],
});

const SettingsSelector = (name, icon) => Widget.Button({
  className: 'settings-selector',
  child: Widget.Icon(icon),
  on_clicked: () => {
    App.toggleWindow('Settings')
  }
})

const Settings = Widget.Box({
  className: 'settings',
  vertical: true,
  children: [
    SettingsSelector('bluetooth', 'bluetooth-symbolic'),
    SettingsSelector('audio', 'audio-volume-medium'),
    SettingsSelector('info', 'emblem-system-symbolic'),
  ],
})

const Top = () => Widget.Box({
  vertical: true,
  children: [
    Workspaces,
  ],
});

const Center = () => Widget.Box({
  hpack: 'center',
  vertical: true,
  children: [
    Clock,
  ],
});

const Bottom = () => Widget.Box({
  vpack: 'end',
  vertical: true,
  children: [
    sysTray,
    Settings,
  ],
});

export const Bar = Widget.Window({
  name: 'Bar',
  className: 'bar',
  anchor: ['left', 'top', 'bottom'],
  exclusivity: 'exclusive',
  focusable: false,
  layer: 'top',
  margin: [6, 6],
  monitor: 0,
  child: Widget.CenterBox({
    className: 'bar-bg',
    vertical: true,
    startWidget: Top(),
    centerWidget: Center(),
    endWidget: Bottom(),
  }),
});
