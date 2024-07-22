local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 33,
	--color = colors.bar.bg,
	color = "black",
	padding_right = 2,
	padding_left = 2,
	margin = 10,
	y_offset = 1,
})
