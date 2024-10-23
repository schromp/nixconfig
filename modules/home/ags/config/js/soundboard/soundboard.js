import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";
import Gio from "gi://Gio"

function readFolderContents(folderPath) {
    let folder = Gio.File.new_for_path(folderPath);
    let fileNames = [];

    try {
        let enumerator = folder.enumerate_children('standard::name', Gio.FileQueryInfoFlags.NONE, null);

        let fileInfo;
        while ((fileInfo = enumerator.next_file(null)) !== null) {
            let name = fileInfo.get_name();
            fileNames.push(name);
        }
    } catch (error) {
        print('Error reading folder contents:', error.message);
    }

    return fileNames;
}

const TestButton = (name) =>
  Widget.Button({
    className: "test",
    attribute: name,
    child: Widget.Label(name),
    on_clicked: () => {
      console.log(name)
      execAsync([
        "bash",
        "-c",
        `pw-cat --target="Chromium input" --volume 25 --playback ~/Sounds/Jawa/soundboard/${name}`,
      ]).catch(print);
      execAsync([
        "bash",
        "-c",
        `pw-cat --target=auto --volume 10 --playback ~/Sounds/Jawa/soundboard/${name}`,
      ]).catch(print);
    },
  });


export const Soundboard = Widget.Window({
  name: "Soundboard",
  className: "soundboard",
  focusable: true,
  popup: true,
  margin: [6, 6],
  anchor: ["left", "top"],
  visible: false,
  monitor: 0,
  child: Widget.Box({
    className: "bar-bg",
    vertical: true,
    setup: (self) => {
      // self.children = [TestButton(readFolderContents('/home/lk/Sounds/Jawa/Uttini'))];
      self.children = readFolderContents('/home/lk/Sounds/Jawa/soundboard').map((name, id) =>
        TestButton(name)
      );
    },
  }),
});
