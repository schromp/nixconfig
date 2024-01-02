import { Widget } from "resource:///com/github/Aylur/ags/widget.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";

const VolumeSlider = (index, type = "speakers") =>
  Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => (Audio[type][index].volume = value),
    setup: (self) =>
      self.hook(
        Audio,
        () => {
          self.value = Audio[type][index]?.volume || 0;
        },
        `microphone-changed`,
      ),
  });

const SourceSelector = (index) =>
  Widget.Button({
    child: Widget.Label("default"),
    onPrimaryClick: () =>
      Audio.control.set_default_source(Audio.microphones[index].stream),
  });

const MicrophoneItem = (index, type, description) =>
  Widget.Box({
    vertical: true,
    className: "Microphone-item",
    children: [
      Widget.Label(description.split(" ").slice(0, 3).join(" ")),
      Widget.Box({
        children: [VolumeSlider(index, type), SourceSelector(index)],
      }),
    ],
  });

const VolumeSourceSelector = (type = "speakers") =>
  Widget.Box({
    className: "VolumeSourceSelector",
    vertical: true,
    setup: (self) =>
      self
        .hook(
          Audio,
          (self) => {
            self.children = Audio[type].map(({ description }, index) =>
              MicrophoneItem(index, type, description),
            );
          },
          "stream-added",
        )
        .hook(
          Audio,
          (self) => {
            self.children = Audio[type].map(({ description }, index) =>
              MicrophoneItem(index, type, description),
            );
          },
          "stream-removed",
        ),
  });

export { VolumeSourceSelector };
