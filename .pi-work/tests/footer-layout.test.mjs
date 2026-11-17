import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import test from "node:test";

for (const profile of [".pi", ".pi-work"]) {
  test(`${profile} reserves quota display for the dedicated row without duplicates`, () => {
    const { powerline } = JSON.parse(readFileSync(join(homedir(), profile, "agent/settings.json"), "utf8"));
    assert.equal(powerline.secondaryOverflow, "wrap");
    assert.equal(powerline.separator, "dot");
    const keys = profile === ".pi-work"
      ? ["ccburn", "codex-weekly", "neuralwatt-usage"]
      : ["usage", "codex-weekly", "neuralwatt-usage"];
    for (const key of keys) assert.ok(powerline.hiddenExtensionStatusKeys.includes(key), `${key} must not appear twice`);
    assert.deepEqual(powerline.layout.right, []);
    assert.deepEqual(powerline.layout.secondary, [], "only usage widget belongs below the editor");
    assert.ok(powerline.layout.left.includes("thinking"));
    assert.ok(powerline.layout.left.includes("custom:ponytail"));
    assert.ok(powerline.hiddenExtensionStatusKeys.includes("pi-effort-thinking"), "no duplicate effort indicator");
    assert.equal(powerline.model.showThinkingLevel, false);
    assert.equal(powerline.context.format, "full", "tokens/max (used %) is the expected context format");
    assert.equal(powerline.customItems.find((item) => item.id === "ponytail").position, "left");
    assert.ok(!powerline.layout.left.includes("extension_statuses"), "unfiltered statuses must not leak back below the editor");
  });
}
