-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- pi core commands
vim.keymap.set("n", "<leader>aip", "<cmd>PiSend<cr>", { desc = "Ask pi (prompt)" })
vim.keymap.set("n", "<leader>aid", "<cmd>Pi<cr>", { desc = "Open pi dialog" })

-- pi send commands (buffer context)
vim.keymap.set("n", "<leader>aif", "<cmd>PiSendFile<cr>", { desc = "Send file + prompt" })
vim.keymap.set("n", "<leader>aib", "<cmd>PiSendBuffer<cr>", { desc = "Send buffer + prompt" })

-- pi selection commands (visual mode)
vim.keymap.set("v", "<leader>aip", "<cmd>PiSendSelection<cr>", { desc = "Send selection + prompt" })

-- pi utility commands
vim.keymap.set("n", "<leader>ap", "<cmd>PiPing<cr>", { desc = "Check pi reachability" })
vim.keymap.set("n", "<leader>as", "<cmd>PiSessions<cr>", { desc = "List/switch sessions" })

-- pi terminal (toggleterm)
local pi_terminal = require("toggleterm.terminal").Terminal:new({
  cmd = "pi",
  dir = LazyVim.root.get(),
  direction = "vertical",
  size = function(term)
    return math.floor(vim.o.lines * 0.35)
  end,
  start_in_insert = true,
  name = "pi",
})

vim.keymap.set("n", "<leader>at", function()
  pi_terminal:toggle()
end, { desc = "Toggle pi terminal (horizontal)" })

-- pi subagent workflows
vim.keymap.set("n", "<leader>aw", function()
  local workflows = {
    {
      name = "Generate Commit Message",
      desc = "Generate a commit message from the current git diff",
      prompt = "Analyze the current git diff and generate a clear, conventional commit message. Include a brief summary and bullet points for the changes.",
      agent = "worker",
      model = "",
    },
    {
      name = "Parallel Code Review",
      desc = "Run 3 reviewers (correctness, tests, simplicity)",
      prompt = "Run a parallel code review of the current diff. Launch 3 fresh-context reviewer agents with distinct angles: correctness/regressions, tests/validation, and simplicity/maintainability. Synthesize their findings.",
      agent = "reviewer",
      model = "",
    },
    {
      name = "Parallel Research",
      desc = "Combine local code context with external research",
      prompt = "Research this topic by combining local code context with external evidence. Launch a scout for local patterns and a researcher for external docs/specs. Provide a synthesis with source links.",
      agent = "",
      model = "",
    },
    {
      name = "Code Cleanup Review",
      desc = "Deslop + verbosity cleanup pass",
      prompt = "Run a cleanup review of the current diff with two fresh-context reviewers: one deslop pass for AI-slop patterns and one verbosity pass. Flag concrete issues with file/line references.",
      agent = "reviewer",
      model = "",
    },
    {
      name = "Gather Context",
      desc = "Scout codebase + ask clarifying questions",
      prompt = "Gather context for this task by exploring relevant code areas. Then ask any clarifying questions needed before planning or implementation.",
      agent = "scout",
      model = "",
    },
    {
      name = "Plan Implementation",
      desc = "Create an implementation plan",
      prompt = "Analyze the current codebase and requirements, then create a detailed implementation plan with steps, files to modify, and acceptance criteria.",
      agent = "planner",
      model = "",
    },
    {
      name = "Oracle Review",
      desc = "Decision-consistency advisory review",
      prompt = "Review the current direction and challenge assumptions. Propose the best next move considering architectural boundaries, risks, and tradeoffs.",
      agent = "oracle",
      model = "",
    },
  }

  local choices = vim.list_extend(
    vim
      .iter(workflows)
      :map(function(w)
        return { w.name, w.desc, w.prompt, w.agent, w.model }
      end)
      :totable(),
    { { "Custom Prompt...", "Enter a custom prompt", "", "", "" } }
  )

  vim.ui.select(choices, {
    prompt = "pi Workflow",
    format_item = function(item)
      return item[1]
    end,
  }, function(choice)
    if not choice then
      return
    end
    if choice[3] == "" then
      vim.ui.input({ prompt = "pi prompt: " }, function(input)
        if input and #input > 0 then
          vim.cmd("PiSend " .. vim.fn.shellescape(input))
        end
      end)
      return
    end

    local full_prompt = choice[3]
    if choice[4] ~= "" then
      full_prompt = "[agent=" .. choice[4] .. "] " .. full_prompt
    end
    if choice[5] ~= "" then
      full_prompt = "[model=" .. choice[5] .. "] " .. full_prompt
    end

    vim.cmd("PiSend " .. vim.fn.shellescape(full_prompt))
  end)
end, { desc = "pi workflow picker" })

