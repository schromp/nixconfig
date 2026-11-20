import {
  type Group,
  type PluginHostSummary,
  type PluginSidebarViewProps,
  type ProjectRef,
  type WorkspaceRef,
  useHosts,
  useSettings,
  useWorkspace,
  useWorkspaces,
} from "@getpaseo/plugin/client";
import { Icon, ScrollView } from "@getpaseo/plugin/client/ui";
import { createContext, useCallback, useContext, useMemo, useRef, useState } from "react";
import { PanResponder, Pressable, Text, View, type ViewStyle } from "react-native";
import { type Layout, layoutSchema, layoutSettings } from "../shared/layout";
import { DragList, type Grip, applyOrder, mergeOrder } from "./drag-list";

type Theme = PluginSidebarViewProps["theme"];
type Navigation = PluginSidebarViewProps["navigation"];
type Indicator = "needs_input" | "failed" | "running" | "attention" | "done";

const defaultLayout: Layout = layoutSchema.parse({});

/** Layout persisted per device, with optimistic updates while a save is in flight. */
function useLayout() {
  const settings = useSettings(layoutSettings);
  const [pending, setPending] = useState<Layout | null>(null);
  const layout = pending ?? (settings.status === "ready" ? settings.values : defaultLayout);
  const update = useCallback(
    (change: (current: Layout) => Layout) => {
      const next = change(layout);
      setPending(next);
      if (settings.status !== "ready") return;
      void settings.save(next, settings.revision).then((saved) => {
        // On success the settings values now match; on failure fall back to what is stored.
        setPending(null);
        return saved;
      });
    },
    [layout, settings],
  );
  return useMemo(
    () => ({
      layout,
      isCollapsed: (key: string) => layout.collapsed.includes(key),
      toggle: (key: string) =>
        update((current) => ({
          ...current,
          collapsed: current.collapsed.includes(key)
            ? current.collapsed.filter((k) => k !== key)
            : [...current.collapsed, key],
        })),
      setHostOrder: (visible: string[]) =>
        update((current) => ({ ...current, hostOrder: mergeOrder(visible, current.hostOrder) })),
      setProjectOrder: (hostId: string, visible: string[]) =>
        update((current) => ({
          ...current,
          projectOrder: {
            ...current.projectOrder,
            [hostId]: mergeOrder(visible, current.projectOrder[hostId] ?? []),
          },
        })),
      setPaneSizes: (sizes: Record<string, number>) =>
        update((current) => ({ ...current, paneSizes: { ...current.paneSizes, ...sizes } })),
    }),
    [layout, update],
  );
}

type LayoutApi = ReturnType<typeof useLayout>;

/** The smallest a host pane gets while dragging a divider, in points. */
const MIN_PANE = 64;

interface Resize {
  above: string;
  below: string;
  heightAbove: number;
  heightBelow: number;
  weightAbove: number;
  weightBelow: number;
}

/** Divider dragging between two expanded host panes. Weights are flex-grow values. */
function usePaneResize(layout: LayoutApi, setDragging: (dragging: boolean) => void) {
  const heights = useRef(new Map<string, number>()).current;
  const [live, setLive] = useState<Record<string, number> | null>(null);
  const resize = useRef<Resize | null>(null);
  const liveRef = useRef<Record<string, number> | null>(null);
  const weightOf = (id: string) => live?.[id] ?? layout.layout.paneSizes[id] ?? 1;

  const latest = useRef({ weightOf, layout, setDragging });
  latest.current = { weightOf, layout, setDragging };

  const api = useRef({
    reportHeight(id: string, height: number) {
      heights.set(id, height);
    },
    start(above: string, below: string) {
      const { weightOf: weight } = latest.current;
      resize.current = {
        above,
        below,
        heightAbove: heights.get(above) ?? MIN_PANE,
        heightBelow: heights.get(below) ?? MIN_PANE,
        weightAbove: weight(above),
        weightBelow: weight(below),
      };
      latest.current.setDragging(true);
    },
    move(dy: number) {
      const r = resize.current;
      if (!r) return;
      const total = r.heightAbove + r.heightBelow;
      const above = Math.min(Math.max(r.heightAbove + dy, MIN_PANE), total - MIN_PANE);
      const weights = r.weightAbove + r.weightBelow;
      const weightAbove = (weights * above) / total;
      liveRef.current = { [r.above]: weightAbove, [r.below]: weights - weightAbove };
      setLive(liveRef.current);
    },
    end() {
      resize.current = null;
      latest.current.setDragging(false);
      if (liveRef.current) latest.current.layout.setPaneSizes(liveRef.current);
      liveRef.current = null;
      setLive(null);
    },
  }).current;

  return { weightOf, ...api };
}

type PaneResize = ReturnType<typeof usePaneResize>;

interface ViewContext {
  props: PluginSidebarViewProps;
  layout: LayoutApi;
  panes: PaneResize;
  dragging: boolean;
  setDragging: (dragging: boolean) => void;
}

const Ctx = createContext<ViewContext | null>(null);
function useView(): ViewContext {
  const value = useContext(Ctx);
  if (!value) throw new Error("Host sidebar context missing");
  return value;
}

function indicatorColor(theme: Theme, indicator: Indicator): string | null {
  switch (indicator) {
    case "running":
      return theme.colors.accent;
    case "needs_input":
    case "attention":
      return theme.colors.statusWarning;
    case "failed":
      return theme.colors.statusDanger;
    default:
      return null;
  }
}

function hostStatusColor(theme: Theme, status: PluginHostSummary["status"]): string {
  switch (status) {
    case "online":
      return theme.colors.statusSuccess;
    case "connecting":
    case "idle":
      return theme.colors.statusWarning;
    default:
      return theme.colors.statusDanger;
  }
}

function GripHandle({ grip, label, theme }: { grip: Grip; label: string; theme: Theme }) {
  return (
    <View
      {...grip.handlers}
      accessibilityLabel={`Drag to reorder ${label}`}
      hitSlop={6}
      style={{ paddingHorizontal: 2, paddingVertical: 4, cursor: grip.dragging ? "grabbing" : "grab" } as object}
    >
      <Icon
        name="GripVertical"
        size={12}
        color={grip.dragging ? theme.colors.accent : theme.colors.foregroundMuted}
      />
    </View>
  );
}

function WorkspaceRow({
  reference,
  active,
  theme,
  navigation,
}: {
  reference: WorkspaceRef;
  active: boolean;
  theme: Theme;
  navigation: Navigation;
}) {
  const row = useWorkspace(reference, (ws) => ({
    label: ws.title ?? ws.name,
    branch: ws.branch,
    indicator: ws.indicator,
    indicatorLabel: ws.indicatorLabel,
  }));
  if (!row) return null;
  const dot = indicatorColor(theme, row.indicator);
  const secondary = row.branch && row.branch !== row.label ? row.branch : null;
  return (
    <Pressable
      accessibilityRole="button"
      accessibilityLabel={`Open workspace ${row.label}${row.indicatorLabel ? `, ${row.indicatorLabel}` : ""}`}
      onPress={() => navigation.openWorkspace(reference)}
      style={({ hovered, pressed }: { hovered?: boolean; pressed: boolean }) => ({
        minHeight: 28,
        paddingLeft: 40,
        paddingRight: 12,
        paddingVertical: 4,
        flexDirection: "row",
        alignItems: "center",
        gap: 8,
        borderRadius: 6,
        marginHorizontal: 4,
        backgroundColor:
          active || pressed ? theme.colors.surface2 : hovered ? theme.colors.surface1 : "transparent",
      })}
    >
      <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: dot ?? "transparent" }} />
      <View style={{ flex: 1, minWidth: 0 }}>
        <Text numberOfLines={1} style={{ color: theme.colors.foreground, fontSize: 12, lineHeight: 16 }}>
          {row.label}
        </Text>
        {secondary ? (
          <Text numberOfLines={1} style={{ color: theme.colors.foregroundMuted, fontSize: 11 }}>
            {secondary}
          </Text>
        ) : null}
      </View>
    </Pressable>
  );
}

function ProjectSection({
  hostId,
  group,
  grip,
}: {
  hostId: string;
  group: Group<WorkspaceRef>;
  grip: Grip;
}) {
  const { props, layout } = useView();
  const { theme, navigation, active } = props;
  const title = group.title ?? group.key;
  const collapseKey = `project:${hostId}:${group.key}`;
  const isCollapsed = layout.isCollapsed(collapseKey);
  const project: ProjectRef | null = useWorkspace(group.items[0]!, (ws) => ws.project);
  return (
    <View>
      <View style={{ flexDirection: "row", alignItems: "center", paddingLeft: 12, paddingRight: 8, gap: 2 }}>
        <GripHandle grip={grip} label={`project ${title}`} theme={theme} />
        <Pressable
          accessibilityRole="button"
          accessibilityLabel={`${isCollapsed ? "Expand" : "Collapse"} project ${title}`}
          onPress={() => layout.toggle(collapseKey)}
          style={{ flex: 1, minHeight: 26, flexDirection: "row", alignItems: "center", gap: 4 }}
        >
          <Icon
            name={isCollapsed ? "ChevronRight" : "ChevronDown"}
            size={12}
            color={theme.colors.foregroundMuted}
          />
          <Text
            numberOfLines={1}
            style={{ color: theme.colors.foreground, fontSize: 12, fontWeight: "500", flexShrink: 1 }}
          >
            {title}
          </Text>
          <Text style={{ color: theme.colors.foregroundMuted, fontSize: 11 }}>{group.items.length}</Text>
        </Pressable>
        {project ? (
          <Pressable
            accessibilityRole="button"
            accessibilityLabel={`New workspace in ${title}`}
            onPress={() => navigation.openProject(project)}
            hitSlop={6}
            style={{ padding: 4 }}
          >
            <Icon name="Plus" size={12} color={theme.colors.foregroundMuted} />
          </Pressable>
        ) : null}
      </View>
      {isCollapsed || grip.dragging
        ? null
        : group.items.map((ref) => (
            <WorkspaceRow
              key={ref.key}
              reference={ref}
              active={active.workspace?.key === ref.key}
              theme={theme}
              navigation={navigation}
            />
          ))}
    </View>
  );
}

const groupKey = (group: Group<WorkspaceRef>) => group.key;
const hostCollapseKey = (serverId: string) => `host:${serverId}`;

/** The line between two host panes. Drag it to give one pane more room than the other. */
function PaneDivider({ above, below }: { above: string; below: string }) {
  const { props, layout, panes } = useView();
  const { theme } = props;
  const [active, setActive] = useState(false);
  const enabled = !layout.isCollapsed(hostCollapseKey(above)) && !layout.isCollapsed(hostCollapseKey(below));
  const latest = useRef({ above, below, enabled, panes });
  latest.current = { above, below, enabled, panes };
  const responder = useMemo(
    () =>
      PanResponder.create({
        onStartShouldSetPanResponder: () => latest.current.enabled,
        onStartShouldSetPanResponderCapture: () => latest.current.enabled,
        onMoveShouldSetPanResponderCapture: () => latest.current.enabled,
        onPanResponderTerminationRequest: () => false,
        onShouldBlockNativeResponder: () => true,
        onPanResponderGrant: () => {
          setActive(true);
          latest.current.panes.start(latest.current.above, latest.current.below);
        },
        onPanResponderMove: (_event, gesture) => latest.current.panes.move(gesture.dy),
        onPanResponderRelease: () => {
          setActive(false);
          latest.current.panes.end();
        },
        onPanResponderTerminate: () => {
          setActive(false);
          latest.current.panes.end();
        },
      }),
    [],
  );
  return (
    <View
      {...responder.panHandlers}
      accessibilityRole="adjustable"
      accessibilityLabel="Resize host panes"
      style={{ height: 9, justifyContent: "center", cursor: enabled ? "row-resize" : "auto" } as object}
    >
      <View
        style={{
          height: active ? 2 : 1,
          marginHorizontal: active ? 0 : 12,
          backgroundColor: active ? theme.colors.accent : theme.colors.border,
        }}
      />
    </View>
  );
}

function HostSection({
  host,
  grip,
  above,
}: {
  host: PluginHostSummary;
  grip: Grip;
  above: string | null;
}) {
  const { props, layout, panes, dragging, setDragging } = useView();
  const { theme } = props;
  const hostKey = hostCollapseKey(host.serverId);
  const isCollapsed = layout.isCollapsed(hostKey);
  const hosts = useMemo(() => [host.serverId], [host.serverId]);
  const groups = useWorkspaces({
    hosts,
    where: (ws) => !ws.background && ws.archivingAt === null,
    orderBy: (a, b) =>
      a.projectDisplayName.localeCompare(b.projectDisplayName) ||
      (b.lastPromptAt ?? b.createdAt ?? "").localeCompare(a.lastPromptAt ?? a.createdAt ?? ""),
    groupBy: (ws) => ({ key: ws.projectId, title: ws.projectDisplayName }),
  });
  const savedOrder = layout.layout.projectOrder[host.serverId];
  const ordered = useMemo(() => applyOrder(groups, groupKey, savedOrder ?? []), [groups, savedOrder]);
  const count = groups.reduce((n, g) => n + g.items.length, 0);

  return (
    <View
      style={{ flex: 1, minHeight: 0 }}
      onLayout={(event) => panes.reportHeight(host.serverId, event.nativeEvent.layout.height)}
    >
      {above ? <PaneDivider above={above} below={host.serverId} /> : <View style={{ height: 4 }} />}
      <View style={{ flexDirection: "row", alignItems: "center", paddingLeft: 8, paddingRight: 12, gap: 2 }}>
        <GripHandle grip={grip} label={`host ${host.label}`} theme={theme} />
        <Pressable
          accessibilityRole="button"
          accessibilityLabel={`${isCollapsed ? "Expand" : "Collapse"} host ${host.label}, ${host.status}`}
          onPress={() => layout.toggle(hostKey)}
          style={{ flex: 1, minHeight: 30, flexDirection: "row", alignItems: "center", gap: 6 }}
        >
          <Icon
            name={isCollapsed ? "ChevronRight" : "ChevronDown"}
            size={12}
            color={theme.colors.foregroundMuted}
          />
          <Icon name="Server" size={13} color={theme.colors.foregroundMuted} />
          <Text
            numberOfLines={1}
            style={{
              color: theme.colors.foregroundMuted,
              fontSize: 11,
              fontWeight: "600",
              letterSpacing: 0.6,
              textTransform: "uppercase",
              flexShrink: 1,
            }}
          >
            {host.label}
          </Text>
          <View
            style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: hostStatusColor(theme, host.status) }}
          />
          <View style={{ flex: 1 }} />
          <Text style={{ color: theme.colors.foregroundMuted, fontSize: 11 }}>{count}</Text>
        </Pressable>
      </View>
      {isCollapsed || grip.dragging ? null : (
        <ScrollView
          style={{ flex: 1 }}
          scrollEnabled={!dragging}
          contentContainerStyle={{ paddingBottom: 6 }}
        >
          {ordered.length === 0 ? (
            <Text style={{ color: theme.colors.foregroundMuted, fontSize: 11, paddingLeft: 40, paddingVertical: 4 }}>
              {host.status === "online" ? "No workspaces" : `Host ${host.status}`}
            </Text>
          ) : (
            <DragList
              items={ordered}
              keyOf={groupKey}
              liftedColor={theme.colors.surface1}
              onDraggingChange={setDragging}
              onReorder={(keys) => layout.setProjectOrder(host.serverId, keys)}
            >
              {(group, projectGrip) => <ProjectSection hostId={host.serverId} group={group} grip={projectGrip} />}
            </DragList>
          )}
        </ScrollView>
      )}
    </View>
  );
}

const hostKeyOf = (host: PluginHostSummary) => host.serverId;

export function HostSidebarView(props: PluginSidebarViewProps) {
  const hosts = useHosts();
  const layout = useLayout();
  const [dragging, setDragging] = useState(false);
  const panes = usePaneResize(layout, setDragging);
  const { theme } = props;
  const ordered = useMemo(
    () => applyOrder(hosts, hostKeyOf, layout.layout.hostOrder),
    [hosts, layout.layout.hostOrder],
  );
  const context = useMemo(
    () => ({ props, layout, panes, dragging, setDragging }),
    [props, layout, panes, dragging],
  );
  // Expanded hosts share the height by weight; collapsed hosts shrink to their header.
  const paneStyle = (host: PluginHostSummary): ViewStyle =>
    layout.isCollapsed(hostCollapseKey(host.serverId))
      ? { flexGrow: 0, flexShrink: 0 }
      : { flexGrow: panes.weightOf(host.serverId), flexShrink: 1, flexBasis: 0, minHeight: MIN_PANE };
  return (
    <Ctx.Provider value={context}>
      <DragList
        items={ordered}
        keyOf={hostKeyOf}
        liftedColor={theme.colors.surface1}
        onDraggingChange={setDragging}
        onReorder={layout.setHostOrder}
        style={{ flex: 1, minHeight: 0 }}
        itemStyle={paneStyle}
      >
        {(host, grip) => {
          const index = ordered.indexOf(host);
          return <HostSection host={host} grip={grip} above={index > 0 ? ordered[index - 1]!.serverId : null} />;
        }}
      </DragList>
    </Ctx.Provider>
  );
}
