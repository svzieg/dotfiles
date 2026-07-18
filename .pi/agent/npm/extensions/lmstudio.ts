import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// LM Studio provider - OpenAI-compatible local inference
export default async function (pi: ExtensionAPI) {
  let models: Array<{
    id: string;
    name: string;
    reasoning: boolean;
    input: ("text" | "image")[];
    cost: { input: number; output: number; cacheRead: number; cacheWrite: number };
    contextWindow: number;
    maxTokens: number;
  }> = [];

  try {
    const response = await fetch("http://localhost:1234/v1/models");
    if (response.ok) {
      const payload = (await response.json()) as {
        data: Array<{
          id: string;
          name?: string;
          context_window?: number;
          max_tokens?: number;
        }>;
      };
      models = payload.data.map((model) => ({
        id: model.id,
        name: model.name ?? model.id,
        reasoning: false,
        input: ["text"] as ("text" | "image")[],
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        contextWindow: model.context_window ?? 128000,
        maxTokens: model.max_tokens ?? 8192,
      }));
    }
  } catch {
    // LM Studio not running - register a placeholder model
    models = [
      {
        id: "local-model",
        name: "Local Model (LM Studio)",
        reasoning: false,
        input: ["text"],
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        contextWindow: 128000,
        maxTokens: 8192,
      },
    ];
  }

  pi.registerProvider("lmstudio", {
    name: "LM Studio",
    baseUrl: "http://localhost:1234/v1",
    apiKey: "lmstudio",
    api: "openai-completions",
    models,
  });
}