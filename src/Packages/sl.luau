--!strict

--[[

	ShortLua Utility
	by @Cayla
	
	Last Updated: 2025-01-31

]]

local ShortLua = {}

--------------------------------------------------------------------------------------------------------

--[[
	Returns whether or not a string starts with Match.

	@param String The string to check.
	@param Match The matching string to check for.

	@returns Whether the string starts with Match.
]]
function ShortLua.StartsWith(String: string, Match: string): boolean
	return String:sub(1, #Match) == Match
end

--[[
	Returns whether or not a string ends with Match.

	@param String The string to check.
	@param Match The matching string to check for.

	@returns Whether the string ends with Match.
]]
function ShortLua.EndsWith(String: string, Match: string): boolean
	return String:sub(-#Match) == Match
end

--[[
	Returns a string's character by index.

	@param String The string to retrieve the character from.
	@param Index The index of the character.

	@returns The string's character.
]]
function ShortLua.Char(String: string, Index: number): string
	return String:sub(Index, Index)
end

--[[
	Replaces all matching patterns in a string.
	
	@param String The string to perform replacement on.
	@param Pattern The pattern to match.
	@param Replacement The replacement string.
	
	@returns The replaced string.
]]
function ShortLua.Replace(String: string, Pattern: string, Replacement: string): string
	local Replaced = String:gsub(Pattern, Replacement)
	return Replaced
end

--[[
	Removes trailing whitespace from a string.
	
	@param String The string you want to remove the trailing whitespace from.
	
	@returns The string without trailing whitespace.
]]
function ShortLua.LStrip(String: string): string
	local Output = String:gsub("%s*$", "")
	return Output
end

--[[
	Cleans a string by removing its surrounding quotes.
	
	@param String The string to clean.
	
	@returns The cleaned string.
]]
function ShortLua.CleanString(String: string): string
	local NewString = String
	
	if ShortLua.StartsWith(NewString, "'") and ShortLua.EndsWith(NewString, "'") then
		NewString = NewString:sub(2, -2)
	end
	
	return String:sub(2, -2)
end

--[[
	Returns the number of occurrences of a pattern in a string.
	
	@param String The string to search.
	@param Pattern The pattern to search for.
	
	@returns The number of occurrences.
]]
function ShortLua.Count(String: string, Pattern: string): number
	local _, Count = String:gsub(Pattern, "")
	return Count
end

--[[
	Returns whether or not any value in a table is true.
	
	@param Table The table to check.
	
	@returns If any value is true.
]]
function ShortLua.Any(Table: { boolean }): boolean
	for _, Value in Table do
		if not Value then
			continue
		end

		return true
	end
	
	return false
end

--[[
	Checks if a service exists.

	@param Service The service to check for.

	@returns Whether or not the service exists.
]]
function ShortLua.IsService(Service: string): boolean
	local Success, _ = pcall(function()
		return game:GetService(Service)
	end)
	
	return Success
end

--------------------------------------------------------------------------------------------------------

return ShortLua
