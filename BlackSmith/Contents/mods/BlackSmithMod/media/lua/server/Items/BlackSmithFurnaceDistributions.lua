require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"
require "Vehicles/VehicleDistributions"
require "Items/ItemPicker"		

------------------------------------------ Book ------------------------------------------
-- All (General)
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, 0.5);

-- Bookstore
table.insert(ProceduralDistributions.list["BookstoreBooks"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["BookstoreBooks"].items, 5);

-- Post Office Storage
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, 0.5);

-- ClassroomMisc
table.insert(ProceduralDistributions.list["ClassroomMisc"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["ClassroomMisc"].items, 0.5);

-- ClassroomDesk
table.insert(ProceduralDistributions.list["ClassroomDesk"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["ClassroomDesk"].items, 0.5);

--BedroomSideTable
table.insert(ProceduralDistributions.list["BedroomSideTable"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["BedroomSideTable"].items, 0.5);

-- LibraryBooks
table.insert(ProceduralDistributions.list["LibraryBooks"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["LibraryBooks"].items, 5);

-- LibraryCounter
table.insert(ProceduralDistributions.list["LibraryCounter"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["LibraryCounter"].items, 5);

-- MechanicShelfBooks
table.insert(ProceduralDistributions.list["MechanicShelfBooks"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["MechanicShelfBooks"].items, 1);

-- ToolStoreBooks
table.insert(ProceduralDistributions.list["ToolStoreBooks"].items, "Base.SmithingMagazine");
table.insert(ProceduralDistributions.list["ToolStoreBooks"].items, 8);

------------------------------------------ Item ------------------------------------------

-- CabinetFactoryTools
table.insert(ProceduralDistributions.list["CabinetFactoryTools"].items, "Base.Bellows");
table.insert(ProceduralDistributions.list["CabinetFactoryTools"].items, 3);