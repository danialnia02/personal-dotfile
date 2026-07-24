-- Format timestamp as d/m/yyyy, h:mm am/pm
local function fmt_ts(ts)
	if not ts or ts <= 0 then return string.rep(" ", 20) end
	local ok, r = pcall(os.date, "%d|%m|%Y|%I|%M|%p", math.floor(ts))
	if not ok or not r then return string.rep(" ", 20) end

	local p = {}
	for part in r:gmatch("[^|]+") do p[#p + 1] = part end
	if #p ~= 6 then return string.rep(" ", 20) end

	local d    = tostring(tonumber(p[1]))
	local m    = tostring(tonumber(p[2]))
	local y    = p[3]
	local h    = tostring(tonumber(p[4]))
	local min  = p[5]
	local ampm = p[6]:lower()

	return string.format("%s/%s/%s, %s:%s %s", d, m, y, h, min, ampm)
end

local function fmt_type(cha, url)
	if cha.is_dir then return "File folder" end
	local ext = url.ext
	if ext and #ext > 0 then return ext:upper() .. " File" end
	return "File"
end

local function fmt_size(len, is_dir)
	if is_dir then return "     -" end
	if len >= 1073741824 then return string.format("%5.1fG", len / 1073741824)
	elseif len >= 1048576 then return string.format("%5.1fM", len / 1048576)
	elseif len >= 1024 then return string.format("%5.0fK", len / 1024)
	else return string.format("%5dB", len) end
end

-- Responsive column content based on panel width:
--   wide  (>= 70): Date modified  Type  Size
--   medium(>= 50): Date modified  Size
--   narrow(< 50) : Size only
local function make_line(w, mtime, ftype, fsize)
	if w >= 70 then
		return string.format("  %-20.20s  %-13.13s  %6s", mtime, ftype, fsize)
	elseif w >= 50 then
		return string.format("  %-20.20s  %6s", mtime, fsize)
	else
		return string.format("  %6s", fsize)
	end
end

local function make_hdr(w)
	if w >= 70 then
		return string.format("  %-20.20s  %-13.13s  %6s", "Date modified", "Type", "Size")
	elseif w >= 50 then
		return string.format("  %-20.20s  %6s", "Date modified", "Size")
	else
		return string.format("  %6s", "Size")
	end
end

-- Shared panel width, set by Current:redraw before orig_redraw iterates files
local PANEL_W = 0

-- Linemode: only show in the current (middle) pane
Linemode.size_and_mtime = function(self)
	if not self._file.in_current then return ui.Line("") end
	local cha = self._file.cha
	local url = self._file.url
	return ui.Line(make_line(PANEL_W, fmt_ts(cha.mtime), fmt_type(cha, url), fmt_size(cha.len, cha.is_dir)))
end

-- Shrink the panel height from the bottom (NOT the top) so that self._area.y
-- stays at its natural value. Yazi's cursor-highlight uses the natural layout
-- y, so keeping y unchanged makes cursor alignment correct. The column-header
-- row is placed at the last row of the original area (below the file list).
if type(Current) == "table" and type(Current.redraw) == "function" then
	local orig_redraw = Current.redraw
	function Current:redraw()
		local area = self._area
		if not area or area.h <= 2 then
			return orig_redraw(self)
		end

		PANEL_W = area.w

		self._area = ui.Rect { x = area.x, y = area.y, w = area.w, h = area.h - 1 }
		local ok, result = pcall(orig_redraw, self)
		self._area = area  -- restore so post-redraw cursor computation uses natural area

		if not ok then
			self._area = area
			return orig_redraw(self)
		end

		local ha     = ui.Rect { x = area.x, y = area.y + area.h - 1, w = area.w, h = 1 }
		local hstyle = ui.Style():bold()
		table.insert(result, ui.Line(ui.Span(" Name"):style(hstyle)):area(ha))
		table.insert(result, ui.Text(ui.Line(ui.Span(make_hdr(area.w)):style(hstyle))):area(ha):align(ui.Align.RIGHT))
		return result
	end
end
