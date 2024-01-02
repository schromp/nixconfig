import { Widget } from "resource:///com/github/Aylur/ags/widget.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";

const VolumeSlider = (index) =>
  Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => (Audio.microphones[index].volume = value),
    setup: (self) =>
      self.hook(
        Audio,
        () => {
          console.log(index)
          self.value = Audio.microphones[index]?.volume || 0;
        },
        `microphone-changed`,
      ),
  });

const SourceSelector = (index) =>
  Widget.Button({
    child: Widget.Label("hello"),
    onPrimaryClick: () => Audio.control.set_default_source(Audio.microphones[index].stream),
  });

const MicrophoneItem = (index, description) =>
  Widget.Box({
    vertical: true,
    className: "Microphone-item",
    children: [
      Widget.Label(description),
      Widget.Box({
        children: [VolumeSlider(index), SourceSelector(index)],
      }),
    ],
  });

const Microphone = Widget.Box({
  className: "MicrophoneSource",
  vertical: true,
  setup: (self) =>
    self.hook(
      Audio,
      (self) => {
        self.children = Audio.microphones.map(({ description }, index) =>
          MicrophoneItem(index, description),
        );
      },
      "microphone-changed",
    ),
});

export { Microphone };
