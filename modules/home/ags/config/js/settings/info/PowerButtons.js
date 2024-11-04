import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';

const PowerButton = (command, icon) => Widget.Button({
  className: 'info-power-button',
  child: Widget.Icon({
    icon,
  }),
  on_clicked: () => Utils.exec(command),
})

const PowerButtonRow = Widget.Box({
  className: 'info-power-button-row',
  hpack: 'center',
  children: [
    PowerButton('dunstify poweroff', 'system-shutdown-symbolic'),
    PowerButton('dunstify reboot', 'system-reboot-symbolic'),
    PowerButton('dunstify reboot', 'system-reboot-symbolic'),
    PowerButton('dunstify reboot', 'system-reboot-symbolic'),
  ]
})

export default PowerButtonRow;
