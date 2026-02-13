-- OWNER
ranks.register("owner", {
	prefix = "Owner",
	colour = "#000000",
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
	prefix = "Moderator",
	colour = "#FF0000",
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
	prefix = "Guardian",
	colour = "#0000FF",
	privs = {
		interact = true,
		shout = true,
		fast = true,
	},
})

-- STAFF
ranks.register("staff", {
	prefix = "Staff",
	colour = "#006400",
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
	prefix = "Build 1",
	colour = "#90EE90", 
	privs = builder_privs
})

ranks.register("builder2", {
	prefix = "Build 2",
	colour = "#FFA500", 
	privs = builder_privs
})

ranks.register("builder3", {
	prefix = "Build 3",
	colour = "#8B4513", 
	privs = builder_privs
})

ranks.register("builder4", {
	prefix = "Build 4",
	colour = "#800080", 
	privs = builder_privs
})

ranks.register("builder5", {
	prefix = "Build 5",
	colour = "#00FFFF", 
	privs = builder_privs
})

ranks.register("builder6", {
	prefix = "Build 6",
	colour = "#98FF98", 
	privs = builder_privs
})

ranks.register("builder7", {
	prefix = "Build 7",
	colour = "#FFFF00", 
	privs = builder_privs
})

ranks.register("builder8", {
	prefix = "Build 8",
	colour = "#CD853F",
	privs = builder_privs
})

ranks.register("builder9", {
	prefix = "Build 9",
	colour = "#FFD700", 
	privs = builder_privs
})

ranks.register("builder10", {
	prefix = "Build 10",
	colour = "#808080", 
	privs = {
		interact = true,
		shout = true,
		fly = true,
	}
})

