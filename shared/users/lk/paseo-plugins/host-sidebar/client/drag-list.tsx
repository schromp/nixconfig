import { type ReactNode, useCallback, useMemo, useRef, useState } from "react";
import {
  type GestureResponderHandlers,
  type LayoutChangeEvent,
  PanResponder,
  View,
  type ViewStyle,
} from "react-native";

export interface Grip {
  /** Spread onto the drag handle view. */
  handlers: GestureResponderHandlers;
  dragging: boolean;
}

interface Box {
  y: number;
  h: number;
}

interface DragState {
  key: string;
  dy: number;
}

/** Where the dragged item lands, as an index into the list without it. */
function dropIndex(keys: readonly string[], boxes: Map<string, Box>, drag: DragState): number {
  const box = boxes.get(drag.key);
  if (!box) return keys.indexOf(drag.key);
  const center = box.y + box.h / 2 + drag.dy;
  let index = 0;
  for (const key of keys) {
    if (key === drag.key) continue;
    const other = boxes.get(key);
    if (other && other.y + other.h / 2 < center) index += 1;
  }
  return index;
}

/** Offset that makes room for the dragged item while it hovers. */
function shiftFor(i: number, from: number, to: number, height: number): number {
  if (i > from && i <= to) return -height;
  if (i < from && i >= to) return height;
  return 0;
}

function DragItem({
  itemKey,
  offset,
  dragging,
  liftedColor,
  callbacks,
  onLayout,
  style,
  children,
}: {
  itemKey: string;
  style?: ViewStyle;
  offset: number;
  dragging: boolean;
  liftedColor: string;
  callbacks: { current: Callbacks };
  onLayout: (key: string, event: LayoutChangeEvent) => void;
  children: (grip: Grip) => ReactNode;
}) {
  const responder = useMemo(
    () =>
      PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        onStartShouldSetPanResponderCapture: () => true,
        onMoveShouldSetPanResponder: () => true,
        onMoveShouldSetPanResponderCapture: () => true,
        onPanResponderTerminationRequest: () => false,
        onShouldBlockNativeResponder: () => true,
        onPanResponderGrant: () => callbacks.current.start(itemKey),
        onPanResponderMove: (_event, gesture) => callbacks.current.move(gesture.dy),
        onPanResponderRelease: () => callbacks.current.end(true),
        onPanResponderTerminate: () => callbacks.current.end(false),
      }),
    [itemKey, callbacks],
  );
  return (
    <View
      onLayout={(event) => onLayout(itemKey, event)}
      style={{
        ...style,
        transform: [{ translateY: offset }],
        zIndex: dragging ? 10 : 0,
        elevation: dragging ? 4 : 0,
        opacity: dragging ? 0.92 : 1,
        backgroundColor: dragging ? liftedColor : "transparent",
        borderRadius: 6,
      }}
    >
      {children({ handlers: responder.panHandlers, dragging })}
    </View>
  );
}

interface Callbacks {
  start(key: string): void;
  move(dy: number): void;
  end(commit: boolean): void;
}

/**
 * A vertical list whose items can be dragged by a grip into a new order.
 * Items render their own grip by spreading `grip.handlers` onto a view.
 */
export function DragList<Item>({
  items,
  keyOf,
  onReorder,
  onDraggingChange,
  liftedColor,
  style,
  itemStyle,
  children,
}: {
  items: readonly Item[];
  style?: ViewStyle;
  itemStyle?: (item: Item) => ViewStyle;
  keyOf: (item: Item) => string;
  onReorder: (keys: string[]) => void;
  onDraggingChange?: (dragging: boolean) => void;
  liftedColor: string;
  children: (item: Item, grip: Grip) => ReactNode;
}) {
  const keys = items.map(keyOf);
  const boxes = useRef(new Map<string, Box>()).current;
  const [drag, setDrag] = useState<DragState | null>(null);

  const latest = { keys, drag, onReorder, onDraggingChange };
  const latestRef = useRef(latest);
  latestRef.current = latest;

  const callbacks = useRef<Callbacks>({
    start(key) {
      setDrag({ key, dy: 0 });
      latestRef.current.onDraggingChange?.(true);
    },
    move(dy) {
      setDrag((current) => (current ? { ...current, dy } : current));
    },
    end(commit) {
      const { keys: currentKeys, drag: currentDrag, onReorder: reorder } = latestRef.current;
      setDrag(null);
      latestRef.current.onDraggingChange?.(false);
      if (!commit || !currentDrag) return;
      const from = currentKeys.indexOf(currentDrag.key);
      const to = dropIndex(currentKeys, boxes, currentDrag);
      if (from < 0 || from === to) return;
      const next = currentKeys.filter((key) => key !== currentDrag.key);
      next.splice(to, 0, currentDrag.key);
      reorder(next);
    },
  });

  const onLayout = useCallback(
    (key: string, event: LayoutChangeEvent) => {
      const { y, height } = event.nativeEvent.layout;
      boxes.set(key, { y, h: height });
    },
    [boxes],
  );

  const from = drag ? keys.indexOf(drag.key) : -1;
  const to = drag ? dropIndex(keys, boxes, drag) : -1;
  const draggedHeight = drag ? (boxes.get(drag.key)?.h ?? 0) : 0;

  return (
    <View style={style}>
      {items.map((item, i) => {
        const key = keys[i]!;
        const isDragged = drag?.key === key;
        // Layout positions are measured untransformed, so shifting does not disturb them.
        const offset = isDragged ? drag.dy : drag ? shiftFor(i, from, to, draggedHeight) : 0;
        return (
          <DragItem
            key={key}
            itemKey={key}
            offset={offset}
            dragging={isDragged}
            liftedColor={liftedColor}
            callbacks={callbacks}
            onLayout={onLayout}
            style={itemStyle?.(item)}
          >
            {(grip) => children(item, grip)}
          </DragItem>
        );
      })}
    </View>
  );
}

/** Sort items by a saved key order; items not in it keep their order at the end. */
export function applyOrder<Item>(
  items: readonly Item[],
  keyOf: (item: Item) => string,
  order: readonly string[],
): Item[] {
  const rank = new Map(order.map((key, index) => [key, index]));
  return items
    .map((item, index) => ({ item, index, rank: rank.get(keyOf(item)) ?? Number.POSITIVE_INFINITY }))
    .sort((a, b) => a.rank - b.rank || a.index - b.index)
    .map(({ item }) => item);
}

/** A new saved order: the visible keys as dragged, then remembered keys not shown now. */
export function mergeOrder(visible: readonly string[], saved: readonly string[]): string[] {
  const shown = new Set(visible);
  return [...visible, ...saved.filter((key) => !shown.has(key))];
}
