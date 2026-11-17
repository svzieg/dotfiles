import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import providerUsage from "../../../.pi/agent/extensions/provider-usage.ts";

export default function workProviderUsage(pi: ExtensionAPI): void {
  providerUsage(pi);
}
