--!strict

--[[

	Linter Class

	- Responsible for checking and formatting a ReadableScript.
	- Part of the Luni framework.

]]

local Linter = {}
Linter.__index = Linter

------------------------------------------------------------------------------------------------------------------------

local Config = require(script.Parent.Config)
local Packages = require(script.Parent.Packages)

local Lexer = Packages.Lexer
local sl = Packages.sl
local t = Packages.t

local Rules = script.Parent.Rules

------------------------------------------------------------------------------------------------------------------------

type ReadableScript = Script | LocalScript | ModuleScript

export type Linter = setmetatable<
	{
		_Index: number,
		read Script: ReadableScript,
		read Source: string,
	},
typeof(Linter)>

------------------------------------------------------------------------------------------------------------------------

local ReadableScriptCheck = t.union(
	t.instanceIsA("Script"), t.instanceIsA("LocalScript"), t.instanceIsA("ModuleScript")
)

------------------------------------------------------------------------------------------------------------------------

--[[
	Initializes a new Linter instance.

	@param Script The readable script to lint.
	@param Source The source that will be checked.

	@returns A new Linter instance.
]]
function Linter.new(Script: ReadableScript, Source: string?): Linter
	assert(ReadableScriptCheck(Script))
	assert(t.optional(t.string)(Source))

	return setmetatable(
		{
			Script = Script,
			Source = Source or Script.Source
		},
		Linter
	) :: Linter
end

--[[
	Lints the given readable script.
	
	@param Fix If true, attempts to fix the linting errors.
	
	@returns Whether or not any errors occured.
]]
function Linter.Check(self: Linter, Fix: boolean?): boolean
	assert(t.optional(t.boolean)(Fix))

	if Fix == nil then
		Fix = false
	end

	local Errors: { string } = {}
	local RawSplit = self.Source:split("\n")

	self._Index = 1

	local Navigator: any = Lexer.navigator()
	Navigator:SetSource(self.Source)

	for Token: string, Source: string in Navigator.Next do		
		for _, RuleFile: ModuleScript in Rules:GetChildren() do
			local Ignored = table.find(Config["IGNORE_RULES"] or {}, RuleFile.Name) ~= nil

			if not RuleFile:IsA("ModuleScript") or Ignored then
				continue
			end

			local Result = (require(RuleFile) :: any)(self._Index, Navigator)

			if not Result then
				continue
			end

			local RuleErrors: { string } = Result[2]

			for _, RuleError in RuleErrors do
				table.insert(Errors, self:_Log(self._Index, RuleFile.Name, RuleError))
			end
		end

		self._Index += sl.Count(Source, "\n")
	end

	for _, Error in Errors do
		warn(Error)
	end

	local Plural = if #Errors == 1 then "" else "s"

	if #Errors == 0 then
		print("✅ All checks passed!")
	else
		warn("⚠️ Found " .. #Errors .. " error" .. Plural)
	end

	return #Errors == 0
end

function Linter._Log(self: Linter, Line: number, ID: string, Message: string): string
	return `{self.Script.Name}:{Line}: [{ID}] {Message}`
end

return Linter
