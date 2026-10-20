#!/usr/bin/env node
/**
 * Generate a `langdock` provider block for a pi `models.json`.
 *
 * Langdock (https://langdock.com) is an OpenAI-compatible enterprise AI gateway.
 * There is no MCP server, so pi integrates it as a custom endpoint in models.json
 * rather than as an extension/plugin.
 *
 * Docs: https://docs.langdock.com/en/developer/completion-api/openai.md
 *   base URL : https://api.langdock.com/openai/{region}/v1     region: eu | us
 *   models   : GET  /openai/{region}/v1/models                 (workspace-specific)
 *   auth     : Bearer <personal or workspace API key>
 *
 * This script reads the live model list from your workspace instead of hardcoding
 * model ids, so nothing here is invented.
 *
 * Usage:
 *   LANGDOCK_API_KEY=... node langdock-provider.mjs              # print block
 *   LANGDOCK_API_KEY=... node langdock-provider.mjs --write FILE # merge into models.json
 *
 * Env:
 *   LANGDOCK_API_KEY  required
 *   LANGDOCK_REGION   optional, default "eu"
 *   LANGDOCK_DEPLOY   optional, dedicated deployment base (e.g. https://x.y/api/public)
 */
import { readFile, writeFile } from "node:fs/promises";

const region = process.env.LANGDOCK_REGION ?? "eu";
const deploy = process.env.LANGDOCK_DEPLOY;
const key = process.env.LANGDOCK_API_KEY;

if (!key) {
	console.error("error: LANGDOCK_API_KEY is not set.");
	console.error("  Create a key: https://app.langdock.com  ->  personal API keys");
	process.exit(1);
}

if (!["eu", "us"].includes(region)) {
	console.error(`error: LANGDOCK_REGION must be "eu" or "us" (got "${region}").`);
	process.exit(1);
}

const base = deploy
	? `${deploy.replace(/\/$/, "")}/openai/${region}/v1`
	: `https://api.langdock.com/openai/${region}/v1`;

const res = await fetch(`${base}/models`, {
	headers: { authorization: `Bearer ${key}`, accept: "application/json" },
});

if (!res.ok) {
	console.error(`error: GET ${base}/models -> ${res.status} ${res.statusText}`);
	console.error("       Check the key, the region, and whether the workspace has the Completion API scope.");
	process.exit(1);
}

const payload = await res.json();
const ids = (payload.data ?? []).map((m) => m.id).filter(Boolean).sort();

if (ids.length === 0) {
	console.error("error: workspace returned no models. Confirm the Completion API is enabled for this key.");
	process.exit(1);
}

const provider = {
	baseUrl: base,
	api: "openai-completions",
	apiKey: "$LANGDOCK_API_KEY",
	models: ids.map((id) => ({
		id,
		name: `${id} (Langdock)`,
		reasoning: true,
		input: ["text"],
		defaultThinkingLevel: "medium",
		// Langdock proxies several vendors with different windows. These are
		// conservative defaults; adjust per model once you know the real limits.
		contextWindow: 128000,
		maxTokens: 32768,
	})),
};

const block = `  "langdock": ${JSON.stringify(provider, null, 2).split("\n").join("\n  ")}`;

const writeIndex = process.argv.indexOf("--write");
if (writeIndex === -1) {
	console.log(block);
	process.exit(0);
}

const target = process.argv[writeIndex + 1];
if (!target) {
	console.error("error: --write needs a path to models.json");
	process.exit(1);
}

let doc = {};
try {
	doc = JSON.parse(await readFile(target, "utf8"));
} catch (err) {
	if (err.code !== "ENOENT") throw err;
}
doc.providers ??= {};
doc.providers.langdock = provider;
await writeFile(target, `${JSON.stringify(doc, null, 2)}\n`, "utf8");

console.error(`wrote ${ids.length} model(s) to ${target} -> providers.langdock (${region})`);