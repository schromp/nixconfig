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
        `changed`,
      ),
  });

const SourceSelector = (index, type, id) =>
  Widget.Button({
    child: Widget.Label("default"),
    className: 'default-audio-unselected',
    onPrimaryClick: () => {
      if (type == 'microphones') {
        Audio.control.set_default_source(Audio[type][index].stream)
      } else if (type == 'speakers'){
        Audio.control.set_default_sink(Audio[type][index].stream)
      }
    }
  }).hook(Audio, button => {
    if(type == 'microphones') {
      Audio.control.get_default_source()?.id == id ? button.className = "default-audio-selected" : button.className = "default-audio-unselected"
    }
    if(type == 'speakers') {
      Audio.control.get_default_sink()?.id == id ? button.className = "default-audio-selected" : button.className = "default-audio-unselected"
    }
  }, 'changed');

const MicrophoneItem = (index, type, description, id) =>
  Widget.Box({
    vertical: true,
    className: "Microphone-item",
    children: [
      Widget.Label(description.split(" ").slice(0, 3).join(" ")),
      Widget.Box({
        children: [VolumeSlider(index, type), type != 'apps' ? SourceSelector(index, type, id) : null],
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
            self.children = Audio[type].map(({ description, id}, index) =>
              MicrophoneItem(index, type, description, id),
            );
          },
          "stream-added",
        )
        .hook(
          Audio,
          (self) => {
            self.children = Audio[type].map(({ description, id}, index) =>
              MicrophoneItem(index, type, description, id),
            );
          },
          "stream-removed",
        ),
  });

export { VolumeSourceSelector };
