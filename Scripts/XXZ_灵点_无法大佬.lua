local ZH = GameMain:GetMod("ZH_zhanghu")

local LSDS = 0				----临时灵点增加

function ZH:OnSave()
	ZH:AddLingNum(nil,true)
	return nil;
end

function ZH:AddLingNum(cost,saveto) 					--灵点余额

	local ZHYE 
	local Acost = cost or 0
	LSDS = LSDS + Acost 

		local file = io.open(".\\saves\\lingdiansave", "r")
		if not file then 
			local file2 = io.open(".\\saves\\lingdiansave", "w+")
			ZHYE = 0
			file2:write(ZHYE)
			file2:close()
		else 
			ZHYE = file:read("*n")
			file:close()
		end 

		if saveto == true and LSDS ~= 0 then
			local file = io.open(".\\saves\\lingdiansave", "w+")
			ZHYE = (ZHYE or 0) + LSDS 
			LSDS = 0
			if ZHYE < 0 then 
				ZHYE = 0
			end 
			file:write(ZHYE)
			file:close()
		else
			ZHYE = (ZHYE or 0) + LSDS 
			if ZHYE < 0 then 
				ZHYE = 0
			end 
		end 
	return ZHYE
end 




-- GameMain:GetMod("ZH_zhanghu"):AddLingNum(1) 
