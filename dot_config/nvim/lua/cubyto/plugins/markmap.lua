--  [markdown markmap]
--  https://github.com/Zeioth/markmap.nvim
return {
  "Zeioth/markmap.nvim",
  build = "yarn global add markmap-cli",
  cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
  opts = {
    html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
    hide_toolbar = false, -- (default)
    grace_period = 3600000 -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
  },
  config = function(_, opts) require("markmap").setup(opts) end
}
-- :MarkmapOpen 	Open markmap
-- :MarkmapSave 	Save markmap without opening it
-- :MarkmapWatch 	Open markmap and watch for changes
-- :MarkmapWatchStop 	The watch server ends automatically after a grace period, or when closing nvim. But it can also be stopped manually with this command.
