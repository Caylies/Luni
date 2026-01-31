--!strict

--[[

	Luni Configuration

]]

--------------------------------------------------------------------------------------------------------

export type Config = {
	LINE_LENGTH: number,
	IGNORE_RULES: { string },
}

--------------------------------------------------------------------------------------------------------

return {

	LINE_LENGTH = 120,
	IGNORE_RULES = {},

} :: Config
