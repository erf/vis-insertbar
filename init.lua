local M = {}

-- An empty style leaves the cell unstyled, so only the terminal's bar shows
M.styles = {
	normal = "fore:black,back:white",
	insert = "",
	-- secondary cursors can't use the terminal's bar, so draw them as blocks;
	-- nil uses the theme's selection colors for a subtler look
	insert_secondary = nil,
}

-- DECSCUSR: 5 = blinking bar, 6 = steady bar
M.insert_shape = 5

-- vis hides the terminal cursor and draws it as a styled cell, so the real
-- cursor (bar) is only shown in insert mode
local function cursor_shape(n, visible)
	io.stdout:write("\27[" .. n .. " q" .. (visible and "\27[?25h" or "\27[?25l"))
	io.stdout:flush()
end

M.bar = false
M.last_mode = nil

function M.draw()
	cursor_shape(M.bar and M.insert_shape or 2, M.bar)
end

function M.update()
	local mode = vis.mode

	if mode == M.last_mode then
		return
	end

	M.last_mode = mode

	local style

	if mode == vis.modes.INSERT then
		style = M.styles.insert
		M.bar = true
	else
		style = M.styles.normal
		M.bar = false
	end

	local secondary = style
	if M.bar then
		secondary = M.styles.insert_secondary or vis.lexers.STYLE_SELECTION or ""
	end
	vis.ui:style_define(vis.ui.style_ids.CURSOR, secondary)
	vis.ui:style_define(vis.ui.style_ids.CURSOR_PRIMARY, style)

	-- vis also paints the character under the cursor with the selection style
	local selection = M.bar and "" or (vis.lexers.STYLE_SELECTION or "")
	vis.ui:style_define(vis.ui.style_ids.SELECTION, selection)
end

vis.events.subscribe(vis.events.WIN_HIGHLIGHT, M.update)
vis.events.subscribe(vis.events.UI_DRAW, M.draw)
return M
