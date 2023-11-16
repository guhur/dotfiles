local home = vim.fn.expand("$HOME")
use({
  "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
      api_key_cmd = "gpg --decrypt " .. home .. "/secret.txt.gpg"
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
})
