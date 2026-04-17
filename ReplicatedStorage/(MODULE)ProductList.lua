local ProductList = {}

local Materials = {
	IronOre   = { name = "Iron Ore", SellValue = 10  },
	Coal      = { name = "Coal",     SellValue = 6   },
	CopperOre = { name = "Copper Ore", SellValue = 8 },
}

local Products = {
	Steel = {
		name = "Steel",
		Materials = {
			{ Material = Materials.IronOre, Amount = 100 },
			{ Material = Materials.Coal, Amount = 50 },
		},
		SellValue = 500,
	},
	CopperWire = {
		name = "Copper Wire",
		Materials = {
			{ Material = Materials.Copper, Amount = 75 },
		},
		SellValue = 300,
	},
}

ProductList.Materials = Materials
ProductList.Products = Products

return ProductList
