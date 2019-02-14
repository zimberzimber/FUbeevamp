
function damage(args)
	if args.sourceKind == "bugnet" then
		captured = true
		status.setResourcePercentage("health", 0)
	end
end

function die()
	if captured then
		local params = config.getParameter("param", nil)
		sb.logError("params = %s", params)
		
		if params then
			
			local dropPools = config.getParameter("dropPools", nil)
			local asd = root.monsterParameters(monster.type())
			-- local item = root.createTreasure(dropPools["bugnet"], world.threatLevel())
			
			sb.logError("dropPools = %s", dropPools)
			sb.logError("asd = %s", asd)
			
			world.spawnMonster(monster.type(), entity.position(), {param = params + 1})
			monster.setDropPool(nil)
		end
	end
end