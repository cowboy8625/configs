local dap = require("dap")

-- pip install debugpy
-- python -m debugpy --listen 5678 script.py
require("dap-python").setup("python")

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return "python"
    end,
  },

  {
    type = "python",
    request = "attach",
    name = "Attach remote",
    connect = {
      host = "127.0.0.1",
      port = 5678,
    },
  },
}
