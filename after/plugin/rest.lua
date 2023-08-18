local rest_nvim = require("rest-nvim")

rest_nvim.setup({
	-- Open request results in a horizontal split
	result_split_horizontal = true,
	-- Skip SSL verification, useful for unknown certificates
	skip_ssl_verification = false,
	-- Highlight request on run
	highlight = {
		enabled = true,
		timeout = 150,
	},
  result = {
      show_curl_command = false,
      show_url = false,
      show_http_info = false,
      show_headers = false,
      formatters = {
        json = "jq",
        html = function(body)
          if vim.fn.executable("tidy") == 0 then
            return body
          end
          -- stylua: ignore
          return vim.fn.system({
            "tidy", "-i", "-q",
            "--tidy-mark",      "no",
            "--show-body-only", "auto",
            "--show-errors",    "0",
            "--show-warnings",  "0",
            "-",
          }, body):gsub("\n$", "")
        end,
      },
    },
	-- Jump to request line on run
	jump_to_request = false,
	env_file = ".env",
	custom_dynamic_variables = {},
	yank_dry_run = true,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function ()
        local buff = tonumber(vim.fn.expand("<abuf>"), 10)
        vim.keymap.set("n", "<leader>cn", rest_nvim.run, { noremap = true, buffer = buff })
        vim.keymap.set("n", "<leader>cl", rest_nvim.last, { noremap = true, buffer = buff })
        vim.keymap.set("n", "<leader>cp", function () rest_nvim.run(true) end, { noremap = true, buffer = buff })
    end
})
