import type { PluginClientContext } from "@getpaseo/plugin/client";
import { HostSidebarView } from "./client/host-view";

export default function contribute(client: PluginClientContext) {
  return client.addSidebarView({
    id: "by-host",
    title: "By machine",
    description: "Workspaces split by host, then by project",
    Component: HostSidebarView,
  });
}
