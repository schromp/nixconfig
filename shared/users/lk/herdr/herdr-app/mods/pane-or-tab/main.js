// pane.go, but at the edge of the tab move to the next/previous tab instead.
// Keys send "pane-or-tab.<direction>" (keys.json). pane.go answers ok even when
// nothing is there, so compare the focused pane before and after.
// Lives in the layout as an invisible floating block: key commands reach shown copies only.
import { View, div } from "gpui-kit";
import { focused, nextCommand, run } from "herdr";

const FALLBACK = { down: "tab.next", right: "tab.next", up: "tab.prev", left: "tab.prev" };

export default class PaneOrTab extends View {
  init(_props, cx) {
    cx.spawn(async (cx) => {
      for (;;) {
        const direction = await nextCommand();
        if (!FALLBACK[direction]) continue;
        const before = focused();
        run("pane.go", { direction });
        // a layout terminal block has no pane: nothing to compare, leave it to pane.go
        if (!before?.pane) continue;
        cx.timer.after(60, () => {
          const now = focused();
          if (now && now.tab === before.tab && now.pane === before.pane) run(FALLBACK[direction]);
        });
      }
    });
  }

  render() {
    return div();
  }
}
