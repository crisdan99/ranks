-- ranks.lua
local S = minetest.get_translator("ranks")

-- OWNER
ranks.register("owner", {
	prefix = S("Owner"),
	colour = "#FF66FF", -- pastel magenta
	privs = {
		interact = true,
		shout = true,
		fly = true,
		fast = true,
		kick = true,
		ban = true,
		privs = true,
		server = true,
		rank = true,
	},
})

-- MODERATOR
ranks.register("moderator", {
	prefix = S("Moderator"),
	colour = "#FF6666", -- pastel red
	privs = {
		interact = true,
		shout = true,
		kick = true,
		ban = true,
		fly = true,
		fast = true,
		privs = true,
	},
})

-- GUARDIAN
ranks.register("guardian", {
	prefix = S("Guardian"),
	colour = "#6699FF", -- pastel blue
	privs = {
		interact = true,
		shout = true,
		fast = true,
	},
})

-- STAFF
ranks.register("staff", {
	prefix = S("Staff"),
	colour = "#66FF99", -- bright pastel green
	privs = {
		interact = true,
		shout = true,
		kick = true,
		rank = true,
	},
})

local builder_privs = {
	interact = true,
	shout = true,
}

-- BUILDER
ranks.register("builder1", {
	prefix = S("Build 1"),
	colour = "#99FF99", -- light green
	privs = builder_privs
})

ranks.register("builder2", {
	prefix = S("Build 2"),
	colour = "#FFB366", -- light orange
	privs = builder_privs
})

ranks.register("builder3", {
	prefix = S("Build 3"),
	colour = "#D9A066", -- light brown/tan
	privs = builder_privs
})

ranks.register("builder4", {
	prefix = S("Build 4"),
	colour = "#CC99FF", -- light purple
	privs = builder_privs
})

ranks.register("builder5", {
	prefix = S("Build 5"),
	colour = "#66FFFF", -- bright cyan
	privs = builder_privs
})

ranks.register("builder6", {
	prefix = S("Build 6"),
	colour = "#99FFCC", -- mint
	privs = builder_privs
})

ranks.register("builder7", {
	prefix = S("Build 7"),
	colour = "#FFFF66", -- bright yellow
	privs = builder_privs
})

ranks.register("builder8", {
	prefix = S("Build 8"),
	colour = "#FFCC99", -- peach
	privs = builder_privs
})

ranks.register("builder9", {
	prefix = S("Build 9"),
	colour = "#FFE066", -- gold/yellow
	privs = builder_privs
})

ranks.register("builder10", {
	prefix = S("Build 10"),
	colour = "#CCCCCC", -- light gray
	privs = {
		interact = true,
		shout = true,
		fly = true,
	}
})