local utils = require("utils")
local wk = require("which-key")

wk.register({
  s = {
    name = "Snippet",
  },
  sf = {
      name = "File"
  },
  sm = {
      name = "Method"
  },
  sc = {
      name = "Class"
  },
  sb = {
      name = "Belgrade"
  }
}, { prefix = "<leader>", buffer = 0 })

utils.map_snippet("<leader>se", "Exception", "Exception")
utils.map_snippet("<leader>sp", "Property Header", "Property Header")
utils.map_snippet("<leader>ss", "Summary", "Summary")
utils.map_snippet("<leader>su", "External Unit", "External Unit")
utils.map_snippet("<leader>sv", "Property Value", "Property Value")
utils.map_snippet("<leader>sw", "Gets or Sets Whether", "Gets or Sets Whether...")

utils.map_snippet("<leader>sfh", "File Header", "File Header")
utils.map_snippet("<leader>sfr", "File Modified", "File Revision")

utils.map_snippet("<leader>sch", "Class Header", "Class Header")
utils.map_snippet("<leader>scr", "Class Revision", "Class Revision")
utils.map_snippet("<leader>sco", "Construct", "Constructor")

utils.map_snippet("<leader>smh", "Method Header", "Method Header")
utils.map_snippet("<leader>smr", "Method Revision", "Method Revision")
utils.map_snippet("<leader>smp", "Method Parameter", "Method Parameter")
utils.map_snippet("<leader>smt", "Method Return", "Method Return")
utils.map_snippet("<leader>smg", "Method Tag", "Method Tag")

utils.map_snippet("<leader>sbf", "Belgrade File Header", "File Header")
utils.map_snippet("<leader>sbl", "Belgrade Class Header", "Class Header")
utils.map_snippet("<leader>sbc", "Belgrade Class Revision", "Class Revision")
utils.map_snippet("<leader>sbm", "Belgrade Method Revision", "Method Revision")
utils.map_snippet("<leader>sbh", "Belgrade Method Header", "Method Header")
utils.map_snippet("<leader>sbp", "Belgrade Property Header", "Property Header")
utils.map_snippet("<leader>sbu", "Belgrade Call", "Call Sequence Unit")
