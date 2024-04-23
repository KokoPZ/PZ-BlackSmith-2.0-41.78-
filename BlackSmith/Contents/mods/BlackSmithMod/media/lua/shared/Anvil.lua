Anvil = Anvil or {}
Anvil.Items = Anvil.Items or {}
Anvil.Tabs = Anvil.Tabs or {}
Anvil.Inject = Anvil.Inject or {}
Anvil.SellisBlacklist = false
Anvil.SellisWhitelist = true
Anvil.defaultPrice = 1
Anvil.defaultPriceBroken = 1

Tab = Tab or {}
Tab["Favorite"] = "Favorite"
Tab["All"] = "All"

Anvil.Tabs[Tab.Favorite] = getText("IGUI_Tab_Favorite")
Anvil.Tabs[Tab.All] = getText("IGUI_Tab_All")

