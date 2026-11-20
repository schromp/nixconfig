import { defineSettings } from "@getpaseo/plugin";
import { z } from "zod";

export const layoutSchema = z.object({
  /** Collapsed host and project keys. */
  collapsed: z.array(z.string()).default([]),
  /** Host server IDs in the order the user dragged them into. */
  hostOrder: z.array(z.string()).default([]),
  /** Per host server ID, project IDs in the order the user dragged them into. */
  projectOrder: z.record(z.string(), z.array(z.string())).default({}),
  /** Per host server ID, the pane's flex weight set by dragging the dividers. */
  paneSizes: z.record(z.string(), z.number().positive()).default({}),
});

export type Layout = z.output<typeof layoutSchema>;

/** Sidebar layout choices. Stays on this device. */
export const layoutSettings = defineSettings({
  id: "layout",
  scope: "device",
  version: 1,
  schema: layoutSchema,
});
