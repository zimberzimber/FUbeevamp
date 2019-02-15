
require "/zb/zb_util.lua"

-- This builder handles the tooltip and default genome generation
function build(directory, config, parameters, level, seed)

	-- populate tooltip fields
	config.tooltipFields = {}
	
	-- for _,tag in ipairs(config.itemTags) do
		-- if tag == "queen" or tag == "youngQueen" then
			-- Add time left to live element to the tooltip
			-- config.tooltipFields.objectImage = "/assetmissing.png"
		-- end
	-- end
	
	-- Mark the bee as wild if it doesn't have a genome, and generate a default one for it
	-- Wild drones replace their genome with a wild queens genome when in the same hive
	if not parameters.genome then
		require "/bees/genomeLibrary.lua"
		parameters.wild = true
		parameters.genome = genelib.generateDefaultGenome(config.itemName)
	end
	
	if parameters.wild then
		config.tooltipFields.objectImage = "/interface/tooltips/wildImage.png"
	else
		config.tooltipFields.objectImage = "/assetmissing.png"
	end
	
	-- TEMPORARY!
	if not root.itemHasTag(config.itemName, "drone") then
		parameters.genomeInspected = true
	end
	
	if parameters.genomeInspected then
		require "/bees/genomeLibrary.lua"
		
		local stats = genelib.returnFullGenomeStats(parameters.genome)
		for stat, value in pairs(stats) do
			if stat == "subtype" then
				local underscore1 = string.find(config.itemName, "_")
				local underscore2 = string.find(config.itemName, "_", underscore1+1)
				local beeName = string.sub(config.itemName, underscore1+1, underscore2-1)
				
				local subtype = root.assetJson("/bees/bees/beeData.config").stats[beeName][value].name
				subtype = string.gsub(subtype, ".", string.upper, 1)
				config.tooltipFields.subTitle = "Subtype: "..subtype
				
			elseif stat == "workTime" then
				if value == "day" then
					config.tooltipFields[stat.."Label"] = "Day"
				elseif value == "night" then
					config.tooltipFields[stat.."Label"] = "Night"
				else
					config.tooltipFields[stat.."Label"] = "Day & Night"
				end
				
			else
				config.tooltipFields[stat.."Label"] = tostring(value)
			end
		end
		
		local formatedGenome = ""
		for i = 1, string.len(parameters.genome)/2 do
			local str = string.sub(parameters.genome, (i-1)*2+1, (i-1)*2+2)
			
			if i%2 == 0 then
				str = "^#FFB2B2;"..str
			else
				str = "^#B2B2FF;"..str
			end
			
			formatedGenome = formatedGenome..str
		end
		
		config.tooltipFields.genomeLabel = "^gray;Genome: "..formatedGenome
	else
		config.tooltipFields.subTitle = "Unknown Subtype"
		config.tooltipFields.baseProductionLabel = "???"
		config.tooltipFields.droneToughnessLabel = "???"
		config.tooltipFields.droneBreedRateLabel = "???"
		config.tooltipFields.queenBreedRateLabel = "???"
		config.tooltipFields.queenLifespanLabel = "???"
		config.tooltipFields.mutationChanceLabel = "???"
		config.tooltipFields.miteResistanceLabel = "???"
		config.tooltipFields.workTimeLabel = "???"
		config.tooltipFields.genomeLabel = "^gray;Unidentified Bee"
	end
	
	return config, parameters
end
