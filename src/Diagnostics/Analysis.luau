--!strict

local ScriptEditorService = game:GetService("ScriptEditorService")

--------------------------------------------------------------------------------------------------------

local Luni = require(script.Parent.Parent.Luni)
local Packages = require(script.Parent.Packages)

--------------------------------------------------------------------------------------------------------

local sl = Packages.sl

--------------------------------------------------------------------------------------------------------

return {
	["LineLength"] = function(Request)
		local LineLength = Luni.Config.LINE_LENGTH

		local Script = Request.script
		local Source = ScriptEditorService:GetEditorSource(Script)
		local Diagnostics = {}

		for Index, Line in Source:split("\n") do
			if #Line <= LineLength then
				continue
			end

			table.insert(Diagnostics, {
				range = {
					start = {
						line = Index,
						character = LineLength
					},
					["end"] = {
						line = Index,
						character = #Line
					}
				},
				code = "Luni",
				message = (
					`Line length exceeds {LineLength} characters ({#Line} > {LineLength})`
				),
				severity = Enum.Severity.Warning
			})
		end
		
		return Diagnostics
	end,
}
